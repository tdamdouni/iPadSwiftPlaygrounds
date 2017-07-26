// 
//  WorldViewController.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//

import SceneKit
import UIKit

@objc(WorldViewController)
public class WorldViewController: UIViewController {
    @IBOutlet weak var speedAdjustButton: UIButton!
    
    @IBOutlet weak var posterImageView: UIImageView! {
        didSet {
            posterImageView?.image = UIImage(named: "LiveViewPoster.jpg")
        }
    }
    
    @IBOutlet var scnView: SCNView!
    
    var characterPickerController: CharacterPickerController?
    
    public var scene: Scene! {
        didSet {
            scene.delegate = self
        }
    }
    
    let loadingQueue = OperationQueue()
    
    /// Marks if loading is currently in progress. 
    /// Set after the first call to `startRunningSceneIfReady()`.
    var isLoading = false
    
    var cameraController: CameraController?
    
    /// End-State
    
    /// Marks if the current run of the world ended in a passing state.
    var isPassingRun = false
    
    var isDisplayingEndState = false
    
//    let backgroundAudioNode = SCNAudioSource(url: Bundle.main().urlForResource("Background", withExtension: "wav", subdirectory: "Audio")!)!
    
    // MARK: Factory Initialization
    
    public class func makeController(with scene: Scene) -> WorldViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main())
        let sceneController = storyboard.instantiateViewController(withIdentifier: "WorldViewController") as! WorldViewController
        
        sceneController.scene = scene
        
        // At this point the world is fully built.
        scene.state = .built
        
        return sceneController
    }
    
    // MARK: View Controller Life Cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.bringSubview(toFront: posterImageView)
        
        /// Loading
        loadingQueue.qualityOfService = .userInitiated
        loadingQueue.addOperation { [unowned self] in
            self.scnView.scene = self.scene.scnScene
            
            // Now that the scene has been loaded, trigger another 
            // verification pass. 
            self.scene.state = .built
            
            // Set controller after scene has been initialized on `scnView`.
            self.cameraController = CameraController(view: self.scnView)
            self.cameraController?.setInitialCameraPosition()
            UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, self.scene.gridWorld.speakableDescription as AnyObject?)
        }
        
        /*
         Register as an `SCNRender` to receive updates.
         (Used to determine when the LiveViewPoster should be removed).
         */
        scnView?.delegate = self
        
        // Register for accessibility notifications to update view if 
        // VoiceOver status changes while level is running.
        registerForAccessibilityNotifications()
        
        // Uncomment to produce a LiveViewPoster.png.
        // WARNING: This will remove all animations (so byte looks good for the pic).
        // This can be confusing if you're testing worlds.
        //        self.saveLiveViewPoster()
        
        speedAdjustButton.isHidden = true
        
        // Grab the device from the scene view and interrogate it.
        if let defaultDevice = scnView.device {
            if (defaultDevice.supportsFeatureSet(MTLFeatureSet.iOS_GPUFamily2_v2)) {
                scnView.antialiasingMode = .multisampling2X
            } else {
                scnView.contentScaleFactor = 1.5
                scnView.preferredFramesPerSecond = 30
            }
        } else {
            // Assume we're in GL-land 
            scnView.contentScaleFactor = 1.5
            scnView.preferredFramesPerSecond = 30
        }
        scnView.contentMode = .center
        scnView.backgroundColor = .clear()
        self.characterPickerController = CharacterPickerController(worldViewController: self)
        
        #if DEBUG
        scnView.showsStatistics = true
        #endif
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Play background music.
        
        //        backgroundAudioNode.loops = true
        //        let sound = SCNAction.playAudioSource(backgroundAudioNode, waitForCompletion: true)
        //        scene.rootNode.runAction(sound)
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Reconfigure the view for the current VoiceOver status whenever
        // the layout changes.
        setVoiceOverForCurrentStatus()
    }
    
    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        unregisterForAccessibilityNotifications()
    }
    
    // MARK: Start
    
    func startPlayback() {
        // Remove any remaining actions on the actor (from WVC+StateChange.swift).
        for actor in scene.actors {
            actor.scnNode.removeAllActions()
        }
        
        // Prepare the scene for playback.
        if case .built = scene.state {
            scene.state = .ready
        }

        beginLoadingAnimations()
        beginLoadingGeometry()
        
        startRunningSceneWhenReady()
        
        // Reset end state.
        isDisplayingEndState = false
    }
    
    func startRunningSceneWhenReady() {
        // Ensure that the scene is not already running or in the process of loading.
        guard scene.state != .run && !isLoading else { return }
        isLoading = true
                
        let readyOperation = BlockOperation  { [unowned self] in
            self.isLoading = false

            // Verify that the LiveViewPoster has been removed.
            guard self.posterImageView?.superview == nil else { return }
            
            // After the scene is prepared, and all animations are loaded, transition to the run state.
            self.scene.state = .run
        }
        
        for operation in loadingQueue.operations {
            readyOperation.addDependency(operation)
        }
        OperationQueue.main().addOperation(readyOperation)
    }
    
    /// NOTE: This can be run off the main queue.
    func saveLiveViewPoster() {
        scene.state = .initial
        scene.commandQueue.runMode = .randomAccess

        // Prevent animations from running.
        for actor in self.scene.actors {
            actor.scnNode.removeFromParentNode()
            actor.removeComponent(AnimationComponent.self)
        }
        
        dispatch_after(seconds: 3.5) {
            let image = self.scnView.snapshot()
            let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
            let filePath = "\(paths[0])/LiveViewPoster.png"
            
            // Save image to be retrieved by UIApplication tests.
            do {
                try UIImagePNGRepresentation(image)?.write(to: URL(fileURLWithPath: filePath), options: [])
            } catch {
                log(message: "Unable to save live view poster")
            }
        }
    }
}

private var renderedFrameCount = 0
extension WorldViewController: SCNSceneRendererDelegate {
    public func renderer(_ renderer: SCNSceneRenderer, didRenderScene _: SCNScene, atTime time: TimeInterval) {
        renderedFrameCount += 1
        guard renderedFrameCount > WorldConfiguration.Scene.warmupFrameCount else { return }
        
        /*
         Swap the scene in as the render delegate to receive future updates.
         (Used to determine when world is complete `scene.state == .done`).
         */
        scnView?.delegate = scene

        DispatchQueue.main.async { [unowned self] in
            // Remove the poster now that we know the scene is rendered.
            UIView.animate(withDuration: 0.5, animations: { [unowned self] in
                self.posterImageView?.alpha = 0.0
            }, completion: { [unowned self] _ in
                self.posterImageView?.removeFromSuperview()

                self.startRunningSceneWhenReady()
            })
        }
    }
}

extension WorldViewController {
    // MARK: Debug options
    
    var showsCenterMarker: Bool {
        set {
            if newValue == false {
                let centerNode = scene.rootNode.childNode(withName: #function, recursively: true)
                centerNode?.removeFromParentNode()
            }
            else {
                let centerNode = SCNNode(geometry: SCNCylinder(radius: 0.01, height: 2))
                centerNode.position = SCNVector3Make(0, 0, 0)
                centerNode.geometry!.firstMaterial!.diffuse.contents = UIColor.red()
                centerNode.name = #function
                scene.rootNode.addChildNode(centerNode)
            }
        }
        get {
            return scene.rootNode.childNode(withName: #function, recursively: true) != nil
        }
    }
}
