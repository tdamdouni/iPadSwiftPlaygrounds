//
//  SceneController.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//

import SceneKit
import UIKit
import Darwin


fileprivate var currentSceneController: SceneController? = nil

func prepare(_ objects: [Any], completionHandler: ((Bool) -> Swift.Void)? = nil) {
    guard let controller = currentSceneController, let completionHandler = completionHandler else { return }
    controller.scnView.prepare(objects) { (successful) in
        completionHandler(successful)
    }
}


final class SceneController: UIViewController {
    // MARK: Properties
   
    var startTime = NSDate()

    let scene: Scene
    
    /// The initial view shown while the scene loads.
    var posterImageView: UIView? = UIView()
    
    let scnView = SCNView()
    
    /// A control which allows the user to adjust world and character speed.
    let speedButton = UIButton()
    
    /// A control which presents a menu to adjust audio preferences with.
    let audioButton = UIButton()

    /// The queue with which all loading work (animation & geometry) is submitted to.
    let loadingQueue = OperationQueue()
    
    /// The object which manages all background audio.
    let audioController = AudioController()
    
    /// Marks if loading is currently in progress. 
    /// Set after the first call to `startRunningSceneIfReady()`.
    var isLoading = false
    
    var cameraController: CameraController?
    
    /// The view which controls character selection.
    var characterPicker: CharacterPickerController?
    
    /// A view which displays the current goal count.
    let goalCounter = GoalCounter()

    /// The color of the liveview poster view.
    let liveViewPosterColor = UIColor(red: 0.517, green: 0.712, blue: 0.998, alpha: 1)
    
    /// An overlay which shows the underlying coordinate system when touching the grid.
    var overlay: GridOverlay?
    
    /// End-State
    
    private(set) var isSceneVisible = false
    
    // MARK: Initialization
    
    init(scene: Scene) {
        self.scene = scene
        super.init(nibName: nil, bundle: nil)
        currentSceneController = self
        
        // Register as the delegate to update with state changes. See SceneController+StateChanges.swift
        scene.delegate = self
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("This method has not been implemented.")
    }
    
    /// Loads any new geometry and animation for the current `commandQueue`.
    /// Specific a `queue` with which to load geometry on.
    /// If immediately displaying the item, `.main` is recommended.
    func beginLoading(queue: OperationQueue = .main) {
        // Loading
        loadingQueue.qualityOfService = .userInitiated
        loadingQueue.maxConcurrentOperationCount = 2
        
        beginLoadingGeometry()
        beginLoadingAnimations()
    }
    
    // MARK: View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addViews()
        let center = CFNotificationCenterGetDarwinNotifyCenter()
        let name = CFNotificationName("EE_LOADED" as CFString)
        CFNotificationCenterPostNotification(center, name, nil, nil, true)
        log(message: "EE_LOADED: \(-startTime.timeIntervalSinceNow)")
        startTime = NSDate()
        
        loadingQueue.addOperation { [weak self] in
            /// Load the `SCNScene`.
            guard let scene = self?.scene.scnScene else { return }
            
            DispatchQueue.main.async {
                self?.scnView.scene = scene
                self?.sceneDidLoad(scene)
            }
        }
        
        /*
         Register as an `SCNSceneRendererDelegate` to receive updates.
         (Used to determine when the LiveView poster should be removed).
         */
        scnView.delegate = self
        
        scnView.isPlaying = true
        scnView.contentMode = .center
        configureViewForDevice()
        
        // Register for accessibility notifications to update view if 
        // VoiceOver status changes while level is running.
        registerForAccessibilityNotifications()
        
        // Register for tap a tap gesture to display the character picker, or an overlay marker.
        registerForTapGesture()
        
        // Run through the `Display` options.
        if Display.coordinateMarkers {
            // Adds an overlay to mark the underlying coordinate system.
            overlay = GridOverlay(world: scene.gridWorld)
        }
        
        if Display.goalCounter {
            // Add a view to display the current goal collection/ toggle count.
            addGoalCounter()
        }
        
        // Controls
        addControlButtons()
        showControls(false, animated: false)
        
        // Register as the `commandQueue` delegate to drive commands,
        // and update counters when commands are run.
        scene.commandQueue.performingDelegate = self
        
        // Configure the audio session to listen to background audio notifications.
        AudioSession.current.delegate = self
        AudioSession.current.configureEnvironment()
                
        #if DEBUG
        scnView.showsStatistics = true
        #endif
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Reconfigure the view for the current VoiceOver status whenever
        // the layout changes.
        setVoiceOverForCurrentStatus(forceLayout: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        unregisterForAccessibilityNotifications()
        loadingQueue.cancelAllOperations()
    }
    
    /// Adds the `scnView` and `posterImageView`.
    private func addViews() {
        scnView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(scnView)
        scnView.frame = view.bounds
        if let posterImageView = posterImageView {
            posterImageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            view.addSubview(posterImageView)
            posterImageView.frame = view.bounds
            posterImageView.backgroundColor = liveViewPosterColor
        }
    }
    
    /// Called after the scene has been manually assigned to the SCNView.
    private func sceneDidLoad(_: SCNScene) {
        // Now that the scene has been loaded, trigger a
        // verification pass.
        scene.state = .built
        
        // Set controller after scene has been initialized on `scnView`.
        cameraController = CameraController(view: scnView)
        
        // Queue up the puzzle section for playback (start playing by default).
        audioController.resumePlaying()
        updateAudioButtonImage()
        let center = CFNotificationCenterGetDarwinNotifyCenter()
        let name = CFNotificationName("SCENE_UNARCHIVED" as CFString)
        CFNotificationCenterPostNotification(center, name, nil, nil, true)
        log(message: "SCENE_UNARCHIVED: \(-startTime.timeIntervalSinceNow)")
        startTime = NSDate()
        // Adjust the `effectsLevel` based on the hardware class.
        #if (arch(i386) || arch(x86_64)) && os(iOS)
        // Setup for the simulator
        scene.effectsLevel = .med
        #else
        if let defaultDevice = scnView.device,
            defaultDevice.supportsFeatureSet(.iOS_GPUFamily2_v2) {
            scene.effectsLevel = .high
        }
        else {
            scene.effectsLevel = .med
        }
        #endif
    }
    
    // MARK: Start
    
    func startPlayback() {
        // Make sure the scene is not already running.
        guard scene.state != .run else { return }
        
        // Prepare the scene for playback.
        if case .built = scene.state {
            scene.state = .ready
        }
        
        startRunningSceneWhenReady()
        audioController.transitionFromSuccess()
    }
    
    private func startRunningSceneWhenReady() {
        // Ensure that the scene is not already running or in the process of loading.
        guard scene.state != .run && !isLoading else { return }
        isLoading = true
        
        // Load any new animations and geometry that may be associated with this run.
        beginLoading(queue: loadingQueue)
                
        let readyOperation = BlockOperation { [weak self] in
            self?.isLoading = false
            
            // After the scene is prepared, and all animations are loaded, transition to the run state.
            self?.scene.state = .run
            // Post the time spent loading the scene.
            let center = CFNotificationCenterGetDarwinNotifyCenter()
            let name = CFNotificationName("SCENE_LOADED" as CFString)
            CFNotificationCenterPostNotification(center, name, nil, nil, true)
            log(message: "SCENE_LOADED: \(-(self?.startTime.timeIntervalSinceNow ?? -1))")
            self?.startTime = NSDate()
        }
        
        for operation in loadingQueue.operations {
            readyOperation.addDependency(operation)
        }
        OperationQueue.main.addOperation(readyOperation)
    }
    
    fileprivate func performStartingFlyover() {
        let animationDuration = WorldConfiguration.introPanDuration
        cameraController?.resetCamera(duration: animationDuration) {
            self.posterImageView?.removeFromSuperview()
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration) {
            self.isSceneVisible = true
            self.startRunningSceneWhenReady()
            self.showControls(true)

            self.setVoiceOverForCurrentStatus(forceLayout: true)
        }
    }
    
    func configureViewForDevice() {
        // Grab the device from the scene view and interrogate it.
        #if (arch(i386) || arch(x86_64)) && os(iOS)
        // Setup for the sim
        scnView.contentScaleFactor = 1.5
        scnView.preferredFramesPerSecond = 30
        #else
        if let defaultDevice = scnView.device,
            defaultDevice.supportsFeatureSet(.iOS_GPUFamily2_v2) {
            scnView.antialiasingMode = .multisampling2X
        }
        #endif
    }
    
    func configureEnvironmentAudio() {
        let environmentParams = scnView.audioEnvironmentNode.distanceAttenuationParameters
        environmentParams.distanceAttenuationModel = .exponential
        environmentParams.rolloffFactor = WorldConfiguration.Scene.audioRolloffFactor
        scene.configureAmbientAudio()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

private var renderedFrameCount = 0
extension SceneController: SCNSceneRendererDelegate {
    func renderer(_ renderer: SCNSceneRenderer, didRenderScene _: SCNScene, atTime time: TimeInterval) {
        
        // Offset the camera to initially match the poster while allowing frames to be rendered.
        self.cameraController?.switchToPosterView()
        
        renderedFrameCount += 1
        guard renderedFrameCount > WorldConfiguration.Scene.warmupFrameCount else { return }
        
        // Release the delegate.
        scnView.delegate = nil
        

        DispatchQueue.main.async {
            if let posterImageView = self.posterImageView {
                posterImageView.superview?.insertSubview(posterImageView, at: 0)
            }
            
            UIView.performWithoutAnimation {
              self.scnView.alpha = 0
            }
            
            UIView.animate(withDuration: 1.0, animations: {
                UIView.setAnimationCurve(.easeOut)
                self.scnView.alpha = 1.0
            })
            
            
            // Configure environment audio.
            self.configureEnvironmentAudio()
            
            self.performStartingFlyover()
        }
    }
}

extension SceneController: CommandQueuePerformingDelegate {
    // MARK: CommandQueuePerformingDelegate
    
    func commandQueue(_ queue: CommandQueue, added command: Command) {}
    
    func commandQueue(_ queue: CommandQueue, willPerform command: Command) {
        // Ensure accessibility info is up to date.
        setVoiceOverForCurrentStatus()
        
        // Update the speed before running the next command.
        setCommandSpeedForSpeedIndex()
    }
    
    func commandQueue(_ queue: CommandQueue, didPerform command: Command) {
        // Evaluate end state
        if !scene.gridWorld.worldBuildComplete {
            let awaitingCommands = queue.pendingCommands
            if let nextCommand = awaitingCommands.first {
                if !nextCommand.isWorldBuildCommand {
                    scene.gridWorld.worldBuildComplete = true
                }
            }
            else {
                // No commands left, world must be complete
                scene.gridWorld.worldBuildComplete = true
            }
        }

        if queue.isFinished {
            // Signal that the LVP is ready for more commands.
            let moreCommands = sendReadyForMoreCommands()
            
            // If the end state has been requested, or there are no more commands
            // mark the scene as done.
            if isFinishedProcessingCommands || !moreCommands {
                scene.state = .done
            }
        }
        
        // If the user closes the connection (by hitting the stop button)
        // display the end state.
        if !Process.isLiveViewConnectionOpen && queue.runMode == .randomAccess {
           scene.state = .done
        }
        
        // Update goal counter.
        switch command.action {
        case .add(_),
             .remove(_) where command.performer is GridWorld:
            updateCounterLabelTotals()
            
            // For randomly placed items which are not animated, the running
            // counts need to be updated when the map is initially configured.
            updateCounterLabelRunningCounts()
            
        case .control(_), .remove(_):
            updateCounterLabelRunningCounts()
            
        default:
            break
        }
    }
}
