//
//  CharacterPickerController.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//

import UIKit
import SceneKit
import SpriteKit

let focalBlurRadiusMax = CGFloat(20)
let focalDistanceMax   = CGFloat(0.2)

protocol CharacterPickerDelegate: class {
    func characterPickerWillShow(_ picker: CharacterPickerController)
    func characterPicker(_ picker: CharacterPickerController, willDismissPicking: ActorType)
    func characterPicker(_ picker: CharacterPickerController, didDismissPicking: ActorType)
}

public class CharacterPickerController {
    // MARK: Types
    
    enum State: Int {
        case inactive
        case active
        case animatingToPicker
        case animatingToWorld
    }
    
    static let fadeDuration = 0.35
    
    // MARK: Properties
    
    weak var view: UIView?
    weak var scene: SCNScene?
    
    weak var delegate: CharacterPickerDelegate?
    
    var overlayView = SCNView()
    
    let tapSource: SCNAudioSource = {
        let source = Asset.sound(named: "PickerTap", in: .environmentSound)!
        source.isPositional = false
        return source
    }()
    
    var state: State = .inactive
    
    var isVisible: Bool {
        return state == .active
    }
    
    let bluActor = Actor(name: .blu)
    let byteActor = Actor(name: .byte)
    let hopperActor = Actor(name: .hopper)
    var pickerActors: [Actor] {
        return [
            bluActor,
            byteActor,
            hopperActor
        ]
    }
    
    var originalActorTransform: SCNMatrix4?
    var originalWorldActor: Actor?

    // MARK: Initialization
    
    init(view: UIView, for scene: SCNScene) {
        self.view = view
        self.scene = scene
    }
    
    func cleanUpOnExit() {
        for actor in pickerActors {
            actor.reset()
        }
        
        overlayView.scene = nil
        overlayView.removeFromSuperview()
        overlayView.gestureRecognizers = nil
    }
    
    // MARK: Show Picker
    
    /// Present the characterPicker. Pulls the actor from the world.
    func show(from actor: Actor) {
        guard state == .inactive else { return }
        state = .animatingToPicker
        
        // Use the idle for the character picker animations.
        Actor.commandSpeed = WorldConfiguration.Actor.idleSpeed
        
        originalWorldActor = actor
        originalActorTransform = actor.scnNode.transform
        actor.reset()
        
        actor.scnNode.runAction(.playSoundEffect(tapSource))
        
        // Reset the existing `pickerActors`. (They may have been recycled).
        for pickerActor in pickerActors {
            pickerActor.reset()
            pickerActor.isInCharacterPicker = true
        }
        
        let result = actor.perform(event: .leave)
        result.completionHandler = { _ in
            guard self.state == .animatingToPicker else { return }
            
            self.triggerDepthOfField(intro: true) { [unowned self] in
                self.loadAndDisplayCharacters()
            }
        }
    }
    
    func triggerDepthOfField(intro: Bool, completion: CompletionBlock? = nil) {
        let root = scene?.rootNode
        guard let cameraNode = root?.childNode(withName: "camera", recursively: true),
            let camera = cameraNode.camera else { return }
        
        SCNTransaction.begin()
        SCNTransaction.animationDuration = CharacterPickerController.fadeDuration
        camera.focalDistance = intro ? focalDistanceMax : 0
        camera.focalBlurRadius = intro ? focalBlurRadiusMax : 0
        
        SCNTransaction.completionBlock = completion
        SCNTransaction.commit()
    }
    
    private func loadAndDisplayCharacters() {
        guard let view = view else { return }
        
        // Setup overlay view & constraints
        overlayView.alpha = 0
        overlayView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(overlayView)
        overlayView.frame = view.bounds
        
        // Add a gesture recognizer to detect when character selection happens.
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(selectCharacter(_:)))
        overlayView.gestureRecognizers = [tapGesture]
        
        // Setup overlay scene
        let worldTemplatePath = Asset.Directory.templates.path + "WorldTemplate"
        let worldURL = Bundle.main.url(forResource: worldTemplatePath, withExtension: "scn")!
        
        let overlayScene = try! SCNScene(url: worldURL)
        overlayView.scene = overlayScene
        overlayScene.background.contents = UIColor.black.withAlphaComponent(0.35)
        
        // Lights and camera looking at Byte.
        let overlayCameraNode = SCNNode()
        overlayCameraNode.camera = SCNCamera()
        overlayCameraNode.position = SCNVector3(0, 0.4, 0.8)
        overlayCameraNode.eulerAngles = SCNVector3(-0.3, 0, 0)
        overlayScene.rootNode.addChildNode(overlayCameraNode)
        overlayView.pointOfView = overlayCameraNode
        
        let light = overlayScene.rootNode.childNode(withName: DirectionalLightName, recursively: true)
        light?.position.x -= 5
        light?.position.y -= 2
        
        let lookAtByte = SCNLookAtConstraint(target: byteActor.scnNode)
        light?.constraints = [lookAtByte]
        
        // Add the characters to the scene.
        positionPickerCharacters(in: overlayScene)
        
        // Setup opacity fade in animation on overlayView.
        UIView.animate(withDuration: CharacterPickerController.fadeDuration, animations: {
            self.overlayView.alpha = 1
            
        }, completion: { _ in
            // Trigger the character animations.
            self.playCharacterArriveArriveAnimations()
            
            // Showing the character dropping in.
            self.delegate?.characterPickerWillShow(self)
        })
    }
    
    private func positionPickerCharacters(in scene: SCNScene) {
        var actorXOffset: CGFloat = -0.75
        
        for actor in pickerActors {
            actor.loadGeometry()
            
            let actualNode = actor.scnNode
            actualNode.position = SCNVector3(actorXOffset, -1.1, -2.5)
            actualNode.scale = SCNVector3(0.5, 0.5, 0.5)
            actorXOffset += 0.75
            
            // Hide the actor who will "arrive" in the scene.
            if actor.type == originalWorldActor?.type {
                actualNode.isHidden = true
            }
            
            actualNode.isAccessibilityElement = true
            actualNode.accessibilityLabel = actor.speakableName
            actualNode.accessibilityHint = NSLocalizedString("Character selection",
                                                             comment: "The accessility hint for a character in the character picker")
            scene.rootNode.addChildNode(actualNode)
            
            // Add a platform below the actor.
            let platform = Platform()
            platform.loadGeometry()
            platform.position = actualNode.position
            platform.scnNode.scale = actualNode.scale
            platform.scnNode.scale.y = 0.1
            platform.glyphNode?.removeFromParentNode()
            scene.rootNode.addChildNode(platform.scnNode)
        }
    }
    
    private func playCharacterArriveArriveAnimations() {
        guard let originalActor = originalWorldActor else { return }
        
        // Setup animations for the character to arrive in the picker, and the reactions the other two actors.
        let arriving: ActorEvent
        let firstReaction: ActorEvent
        let secondReaction: ActorEvent
        
        switch originalActor.type {
        case .byte:
            arriving = ActorEvent(actor: byteActor, event: .arrive)
            firstReaction = ActorEvent(actor: bluActor, event: .pickerReactLeft)
            secondReaction = ActorEvent(actor: hopperActor, event: .pickerReactRight)
            
        case .blu:
            arriving = ActorEvent(actor: bluActor, event: .arrive)
            firstReaction = ActorEvent(actor: byteActor, event: .pickerReactRight)
            secondReaction = ActorEvent(actor: hopperActor, event: .pickerReactRight)
            
        case .hopper:
            arriving = ActorEvent(actor: hopperActor, event: .arrive)
            firstReaction = ActorEvent(actor: byteActor, event: .pickerReactLeft)
            secondReaction = ActorEvent(actor: bluActor, event: .pickerReactLeft)
            
        case .expert:
            fatalError("Found `Expert` in the character picker.")
        }
        
        // Arriving
        let arrivingResult = arriving.performEvent()
        arriving.actor.scnNode.isHidden = false
        
        arrivingResult.completionHandler = { _ in
            // Mark the state as `.active` after the arrival animation has finished.
            self.state = .active
            
            arriving.actor.startContinuousIdle()
        }
        
        // Reactions
        let reactionHandler: PerformerHandler = { performer in
            let actor = performer as? Actor
            actor?.startContinuousIdle()
        }
        
        firstReaction.performEvent().completionHandler = reactionHandler
        secondReaction.performEvent().completionHandler = reactionHandler
    }
    
    // MARK: Dismissal
    
    dynamic func selectCharacter(_ recognizer: UITapGestureRecognizer) {
        guard state == .active else { return }
        
        let p = recognizer.location(in: overlayView)
        let hitResults = overlayView.hitTest(p, options: nil)
        
        // Compare the `scnNode`s to determine which actor was hit.
        guard let closestHit = hitResults.first,
            let hitActorNode = closestHit.node.anscestorNode(named: "Actor"),
            let selectedActor = pickerActors.first(where: { $0.scnNode == hitActorNode }) else {
                return
        }
        
        // Animate selected character off picker.
        state = .animatingToWorld
        selectedActor.reset()
        selectedActor.scnNode.runAction(.playSoundEffect(tapSource))

        let type = selectedActor.type
        
        // Persist character choice.
        type.saveAsDefault()
        self.delegate?.characterPicker(self, willDismissPicking: type)
        
        let result = selectedActor.perform(event: .leave)
        result.completionHandler = { [unowned self] _ in
            // Swap the actor into the `originalActor`
            self.swapMainActor(for: selectedActor)
            self.originalWorldActor?.scnNode.isHidden = true
            
            UIView.animate(withDuration: CharacterPickerController.fadeDuration, animations: {
                self.overlayView.alpha = 0
            })
            
            self.triggerDepthOfField(intro: false) { [unowned self] in
                self.jumpActorBackIntoWorld()

                self.delegate?.characterPicker(self, didDismissPicking: selectedActor.type)
            }
        }
    }
    
    /// Dismiss the character picker without a new actor choice.
    /// Returns the `originalWorldActor` to a continuous idle if `toIdle` is true.
    func dismiss(toIdle: Bool = true) {
        guard state == .active || state == .animatingToPicker else { return }
        
        self.originalWorldActor?.reset()

        UIView.animate(withDuration: CharacterPickerController.fadeDuration, animations: {
            self.overlayView.alpha = 0
            
        }, completion: { _ in
            guard let actor = self.originalWorldActor else { return }
            
            // Unhide the original actor.
            actor.scnNode.isHidden = false
            if toIdle {
                actor.startContinuousIdle()
            }
            
            self.triggerDepthOfField(intro: false) { [unowned self] in
                self.state = .inactive
                self.cleanUpOnExit()

                self.delegate?.characterPicker(self, didDismissPicking: actor.type)
            }
        })
    }
    
    /// Apply the "WorldArriveAnimation" to the `originalWorldActor`.
    func jumpActorBackIntoWorld() {
        // Kick off world arrive animation.
        guard let originalActor = self.originalWorldActor else { fatalError("Failed to find original world actor.") }

        let result = originalActor.perform(event: .arrive)
        originalActor.scnNode.isHidden = false
        
        result.completionHandler = { _ in
            self.state = .inactive

            originalActor.startContinuousIdle()
        }
        
        // Clean up the scene and picker actors.
        cleanUpOnExit()
    }
    
    private func swapMainActor(for actor: Actor) {
        guard let originalActor = originalWorldActor else { return }
        originalActor.scnNode.transform = self.originalActorTransform!
        
        actor.reset()
        originalActor.reset()
        originalActor.swap(with: actor)
    }
}

// MARK: ActorEvent

private final class ActorEvent {
    let actor: Actor
    let event: EventGroup
    
    init(actor: Actor, event: EventGroup) {
        self.actor = actor
        self.event = event
    }
    
    func performEvent() -> PerformerResult {
        return actor.perform(event: event)
    }
}
