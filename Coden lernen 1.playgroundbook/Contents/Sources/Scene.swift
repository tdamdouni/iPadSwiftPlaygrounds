//
//  Scene.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//

import SceneKit

/// Reports changes to the worlds state.
protocol SceneStateDelegate: class {
    func scene(_ scene: Scene, didEnterState: Scene.State)
}

final class Scene: NSObject {
    // MARK: Types
    
    enum State {
        /// The starting state of the scene before anything has been added.
        case initial
        
        /// The state after all inanimate elements have been placed.
        case built
        
        /// The state which rewinds the `commandQueue` in preparation for playback.
        case ready
        
        /// The state which starts running commands in the `commandQueue`.
        case run
        
        /// The final state after all commands have been run.
        case done
    }
    
    enum EffectsLevel: Int {
        case high, med, low
    }
    
    // MARK: Properties
    
    private let source: SCNSceneSource
    
    let gridWorld: GridWorld
    
    /// The queue which all commands are added to before being run.
    var commandQueue: CommandQueue {
        return gridWorld.commandQueue
    }
    
    lazy var scnScene: SCNScene = {
        let scene: SCNScene
        do {
            scene = try self.source.scene()
        }
        catch {
            presentAlert(title: "Failed To Load Scene.", message: "\(error)")
            fatalError("Failed To Load Scene.\n\(error)")
        }
        
        // Remove the old grid node that exists in loaded scenes. 
        scene.rootNode.childNode(withName: GridNodeName, recursively: false)?.removeFromParentNode()
        scene.rootNode.addChildNode(self.gridWorld.grid.scnNode)
        
        // Give the `rootNode` a name for easy lookup.
        scene.rootNode.name = "rootNode"
        
        // Load the skybox. 
        scene.background.contents = Asset.texture(named: "zon_bg_skyBox_a_DIFF")
        
        self.positionCameraToFitGrid(around: scene.rootNode)
        self.adjustDirectionalLight(in: scene.rootNode)
        self.cleanupScene(scene)
        
        return scene
    }()
    
    var rootNode: SCNNode {
        return scnScene.rootNode
    }
    
    lazy var lights: [SCNLight] = {
        var lights = [SCNLight]()
        self.rootNode.enumerateHierarchy { node, _ in
            if let light = node.light {
                lights.append(light)
            }
        }
        
        return lights
    }()
    
    lazy var waterfalls: [SCNNode] = {
        guard let water = self.rootNode.childNode(withName: "WATER", recursively: true) else { return [] }
        
        return water.childNodes { child, _ in
            let name = child.name ?? ""
            return name.hasPrefix("zon_barrier_waterfall") && name.hasSuffix("reference")
        }
    }()
    
    let environmentSounds = AudioSectionPlayer()
    
    ///  Actors operating within this scene.
    var actors: [Actor] {
        return gridWorld.grid.actors
    }
    
    /// The first actor (which is not an expert) in the scene.
    var mainActor: Actor? {
        return actors.first(where: { type(of: $0) == Actor.self })
    }
    
    /// The duration used when rewinding the scene.
    var resetDuration: TimeInterval = 0.0
    
    weak var delegate: SceneStateDelegate?
    
    var state: State = .initial {
        didSet {
            guard oldValue != state else { return }
            
            let newState = state
            enterState(newState)
            
            OperationQueue.main.addOperation {
                self.delegate?.scene(self, didEnterState: newState)
            }
        }
    }
    
    // Effect Nodes
    
    lazy var highEffectsNode: SCNNode? = self.rootNode.childNode(withName: "HIGH_QUALITY_FX", recursively: true)
    
    lazy var lowEffectsNode: SCNNode? = self.rootNode.childNode(withName: "LOW_QUALITY_FX", recursively: true)
    
    var directionalLight: SCNLight? = nil
    
    var effectsLevel: EffectsLevel = .high {
        didSet {
            let med = EffectsLevel.med.rawValue
            highEffectsNode?.isHidden = effectsLevel != .high
            lowEffectsNode?.isHidden = effectsLevel.rawValue > med
            
            directionalLight?.shadowMapSize = effectsLevel.rawValue >= med ? CGSize(width:  1024, height:  1024) : CGSize(width:  2048, height:  2048)
            
            // Destructive
            if effectsLevel == .low {
                rootNode.enumerateChildNodes { node, _ in
                    for system in node.particleSystems ?? [] {
                        node.removeParticleSystem(system)
                    }
                }
                
                scnScene.fogStartDistance = 0
                scnScene.fogEndDistance = 0
            }
        }
    }
    
    // MARK: Initialization
    
    init(world: GridWorld) {
        gridWorld = world
        
        // Load template scene.
        let worldTemplatePath = Asset.Directory.templates.path + "WorldTemplate"
        let worldURL = Bundle.main.url(forResource: worldTemplatePath, withExtension: "scn")!
        source = SCNSceneSource(url: worldURL, options: nil)!
    }
    
    /// Initialize with an ".scn" scene.
    convenience init(named sceneName: String) throws {
        let path = Asset.Directory.scenes.path + sceneName
        
        guard
            let sceneURL = Bundle.main.url(forResource: path, withExtension: "scn"),
            let source = SCNSceneSource(url: sceneURL, options: nil) else {
                throw GridLoadingError.invalidSceneName(sceneName)
        }
        
        try self.init(source: source)
    }
    
    init(source: SCNSceneSource) throws {
        self.source = source
        
        // Check for `GridNodeName` node.
        guard let baseGridNode = source.entry(withID: GridNodeName, ofType: SCNNode.self) else {
            throw GridLoadingError.missingGridNode(GridNodeName)
        }

        gridWorld = GridWorld(node: baseGridNode)
        
        super.init()
        
        // Ensure at least one tile node is contained in the scene as the floor node.
        guard !gridWorld.existingItems(ofType: Block.self, at: gridWorld.allPossibleCoordinates).isEmpty else {
            throw GridLoadingError.missingFloor("No nodes of with name `Block` were found.")
        }
        
        let cols = gridWorld.columnCount
        let rows = gridWorld.rowCount
        guard cols > 0 && rows > 0 else { throw GridLoadingError.invalidDimensions(cols, rows) }
    }
    
    // MARK: Scene Adjustments
    
    func enterState(_ newState: State) {
        switch newState {
        case .initial:
            break
            
        case .built:
            // Never animate `built` steps.
            gridWorld.applyChanges() {
                gridWorld.verifyNodePositions()
            }
            
        case .ready:
            SCNTransaction.begin()
            SCNTransaction.animationDuration = resetDuration
            // Reset the state of the world for playback.
            commandQueue.rewind()
            SCNTransaction.commit()
            
            // Ensure the dimensions of the `gridWorld` are correct.
            gridWorld.calculateRowColumnCount()
            
        case .run:
            if commandQueue.isFinished {
                // If there are no commands, mark the scene as done.
                state = .done
            }
            else {
                DispatchQueue.main.asyncAfter(deadline: .now() + resetDuration) {
                    guard self.state == .run else { return }
                    self.commandQueue.runCommand(atIndex: 0)
                }
            }
            
        case .done:
            // Recalculate the dimensions of the world for any placed items.
            gridWorld.calculateRowColumnCount()            
        }
    }
    
    func adjustDirectionalLight(in root: SCNNode) {
        guard let lightNode = root.childNode(withName: DirectionalLightName, recursively: true) else { return }
        
        var light: SCNLight?
        lightNode.enumerateHierarchy { node, stop in
            if let directional = node.light {
                light = directional
                stop.initialize(to: true)
            }
        }
    
        directionalLight = light
        light?.orthographicScale = 10
        light?.shadowMapSize = CGSize(width:  2048, height:  2048)

    }
    
    func positionCameraToFitGrid(around node: SCNNode) {
        // Set up the camera.
        let cameraNode = node.childNode(withName: "camera", recursively: true)!
        let boundingNode = node.childNode(withName: "Scenery", recursively: true) ?? gridWorld.grid.scnNode
        
        var (_, sceneWidth) = boundingNode.boundingSphere
        // Expand so we make sure to get the whole thing with a bit of overlap.
        sceneWidth *= 2
        
        let dominateDimension = Float(max(gridWorld.rowCount, gridWorld.columnCount))
        sceneWidth = max(dominateDimension * 2.5, sceneWidth)
        guard sceneWidth.isFinite && sceneWidth > 0 else { return }
        
        let cameraDistance = Double(cameraNode.position.z)
        let halfSceneWidth = Double(sceneWidth / 2.0)
        let distanceToEdge = sqrt(cameraDistance * cameraDistance + halfSceneWidth * halfSceneWidth)
        let cos = cameraDistance / distanceToEdge
        let sin = halfSceneWidth / distanceToEdge
        let halfAngle = atan2(sin, cos)
        
        cameraNode.camera?.yFov = 2.0 * halfAngle * 180.0 / M_PI
    }
    
    /// Removes unnecessary adornments in scene file.
    func cleanupScene(_ scene: SCNScene) {
        let root = scene.rootNode
        
        let bokeh = root.childNode(withName: "bokeh particles", recursively: true)
        bokeh?.removeFromParentNode()
        
        let reflectionPlane = root.childNode(withName: "reflections", recursively: true)
        reflectionPlane?.removeFromParentNode()
    }
    
    /// Reset's the scene in preparation for another run.
    func reset(duration: TimeInterval) {
        resetDuration = duration
        
        // Rewinds the commandQueue to correct all world state.
        state = .ready
        
        // Remove all commands from previous run.
        commandQueue.clear()
        
        // Clear any items no longer in the world from the previous run.
        // (Before receiving more commands).
        gridWorld.grid.removeItemsNotInWorld()
    }
}

extension Scene: AudioSectionPlayerDelegate {
    
    struct AmbientAudioOptions: OptionSet {
        let rawValue: Int
        
        static let waterfalls  = AmbientAudioOptions(rawValue: 1 << 0)
        static let birds  = AmbientAudioOptions(rawValue: 1 << 1)
    }
    
    // MARK: Ambient Audio
    
    static func persistedAmbientAudioOptions() -> AmbientAudioOptions {
        var options: Scene.AmbientAudioOptions = []
        if Persisted.areSoundEffectsEnabled {
            options.insert(.waterfalls)
            
            if !Persisted.isBackgroundAudioEnabled {
                options.insert(.birds)
            }
        }
        
        return options
    }
    
    func configureAmbientAudio(options: AmbientAudioOptions = Scene.persistedAmbientAudioOptions()) {
        let audioChildName = "audioPlayerNode"
        let audioCoefficient: Float = Persisted.isBackgroundAudioEnabled ? 1/3 : 1
        
        if options.contains(.waterfalls) {
            let source = Asset.sound(named: "BackgroundWaterfall", in: .environmentSound)!
            let volume = WorldConfiguration.Scene.waterfallVolume * audioCoefficient
            
            // Ignore small waterfalls.
            let bigWaterfalls = waterfalls.filter {
                return $0.name?.contains("1x1") == false
            }
            
            // The auditory offset for starting distinct waterfall noise.
            // Prevents interference when playing the same track close together.
            var offset = 0.0
            for node in bigWaterfalls {
                let existingChild = node.childNode(withName: audioChildName, recursively: false)
                existingChild?.removeFromParentNode()

                let audioNode = SCNNode()
                audioNode.name = audioChildName
                node.addChildNode(audioNode)

                // Offset the audio source to exaggerate the positional effects.
                audioNode.position.x += 5
                audioNode.position.y += 5
                
                source.volume = volume
                source.loops = true
                source.reverbBlend = 0.5
                
                DispatchQueue.main.asyncAfter(deadline: .now() + offset) {
                    let player = SCNAudioPlayer(source: source)
                    audioNode.addAudioPlayer(player)
                }
                offset += 1
            }
        }
        else {
            for node in waterfalls {
                let audioNode = node.childNode(withName: audioChildName, recursively: false)
                audioNode?.removeFromParentNode()
            }
        }
        
        if options.contains(.birds) {
            environmentSounds.delegate = self
            environmentSounds.isPlaying = true
        }
        else {
            environmentSounds.isPlaying = false
        }
    }
    
    // MARK: AudioSectionPlayerDelegate
    
    func audioSectionPlayerIsReadyForNextSection(_: AudioSectionPlayer) -> AudioSection {
        return EnvironmentSoundsSong.shuffledSection()
    }
}
