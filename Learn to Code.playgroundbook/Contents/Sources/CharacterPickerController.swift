//
//  CharacterPickerController.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//

import Foundation
import UIKit
import SceneKit
import SpriteKit

let animationYOffset = Float(100)

public class CharacterPickerController : NSObject {
    
    weak var worldViewController : WorldViewController?
    var selectedActor: Actor?
    var pickerContainerNode: SCNNode?
    var worldContainerNode: SCNNode?
    var worldScene: Scene?
    var pickerScene: Scene?
    var isCharacterPickerActive = false
    var isCharacterPickerAnimating = false
    var bluActor: Actor?
    var byteActor: Actor?
    var hopperActor: Actor?
    var actorAnimationsActionInfo: [ActorType : SCNAction]!
    var bluAnimations: ActorAnimation!
    var byteAnimations: ActorAnimation!
    var hopperAnimations: ActorAnimation!
    var originalActorCoordinate: Coordinate?
    var originalActorHeading: Direction?
    var originalActorTransform: SCNMatrix4?
    var originalWorldActor : Actor?

    init(worldViewController: WorldViewController) {
        super.init()
        self.worldViewController = worldViewController
        registerCharacterPickerGestureRecognizer()
    }
    
    
    var unhideAction: SCNAction {
        return .sequence([.wait(forDuration: 0.1), .run({ $0.isHidden = false })])
    }


    func registerCharacterPickerGestureRecognizer() {
        assert(worldViewController != nil)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(CharacterPickerController.tapAction(_:)))
        worldViewController!.view.addGestureRecognizer(tapGesture)
    }
    
    func tapAction(_ recognizer: UITapGestureRecognizer) {
        guard !isCharacterPickerAnimating else { return }
        
        let scene = worldViewController!.scene
        let view = worldViewController!.scnView
        
        /* 
            The character picker should be useable when the `commandQueue` is finished
            (no pending commands remain) or the `commandQueue` is not being continually
            run.
        */
        guard scene?.commandQueue.isFinished == true || scene?.commandQueue.runMode == .randomAccess else {  return }
        let p = recognizer.location(in: view)
        let onlyGridOption = [SCNHitTestRootNodeKey: scene?.gridWorld.grid.scnNode as! AnyObject]
        let hitResults = view?.hitTest(p, options: onlyGridOption)
        
        guard let closestHit = hitResults?.first else { return }
        guard let hitActorNode = closestHit.node.anscestorNode(named: "Actor") else { return }
        
        // Compare the `scnNode`s to determine which actor was hit.
        let hitActors = scene?.actors.filter {
            $0.scnNode == hitActorNode
        }
        
        // Check to make sure the main actor was hit.
        guard let mainActor = hitActors?.first else { return }
        selectedActor = mainActor
        
        isCharacterPickerAnimating = true
        if isCharacterPickerActive {
            
            // Persist actor choice.
            DispatchQueue.main.async {
                mainActor.type.saveAsDefault()
            }
            
            startPickSelectedAnimation()
        }
        else {
            startCharacterPickerAnimation()
        }
    }
    
    private func startPickSelectedAnimation() {
        guard selectedActor != nil else { return }
        
        //Setup required Actor Animations for: picker leave + world enter + character interactions.
        let selectedActorAnimations = ActorAnimation(type: self.selectedActor!.type)
        ActorAnimation.loadAnimations(for: selectedActor!.type, actions: [.leave, .arrive, .default])
        
        //load all character animations for sequence.

            if let _ = self.pickerScene {
                for actor in (self.pickerScene!.actors) {
                    actor.scnNode.removeAllActions()
                    actor.scnNode.removeAllAnimations()
                }
            }
        let dismissPickerNodeAction = SCNAction.run { [unowned self] _ in
            self.pickerContainerNode?.run(.moveBy(x: 0, y: animationYOffset.cgFloat, z: 0, duration: 1.2)) { [unowned self] in
                DispatchQueue.main.async { [unowned self] in
                    self.worldViewController!.scene = self.worldScene
                    self.worldViewController!.scnView.present(self.worldScene!.scnScene, with: .crossFade(withDuration: 0.75), incomingPointOfView: nil, completionHandler: nil)
                    for childNode in self.pickerScene!.scnScene.rootNode.childNodes {
                        childNode.removeAllAnimations()
                        childNode.removeAllActions()
                        childNode.removeFromParentNode()
                    }
                    self.isCharacterPickerActive = true
                    let moveAction = SCNAction.moveBy(x: 0, y: animationYOffset.cgFloat, z: 0, duration: 1)
                    moveAction.timingMode = .easeOut
                    
                    self.worldContainerNode!.run(moveAction) { [unowned self] in

                        self.originalWorldActor?.swap(with: self.selectedActor!)
                        self.originalWorldActor!.scnNode.isHidden = false
                        
                        if let wvc = self.worldViewController {
                            self.worldViewController!.scene.gridWorld.isAnimated = false
                            wvc.scene.gridWorld.place(self.originalWorldActor!, facing: self.originalActorHeading!, at: self.originalActorCoordinate!)
                            wvc.scene.gridWorld.percolateNodes(at: self.originalActorCoordinate!)
                            wvc.scene.gridWorld.isAnimated = true
                        }
                        let arriveAnimation = selectedActorAnimations[.arrive].first!
                        
                        self.originalWorldActor!.scnNode.run(.group([self.unhideAction, .animate(with: arriveAnimation)])) { [unowned self] in
                            DispatchQueue.main.async {
                                // Restart the scene to add the idle animations back to the characters.
                                self.pickerContainerNode = nil
                                self.bluActor = nil
                                self.byteActor = nil
                                self.hopperActor = nil
                                self.actorAnimationsActionInfo = nil
                                self.bluAnimations = nil
                                self.byteAnimations = nil
                                self.hopperAnimations = nil
                                self.worldScene = nil
                                self.originalWorldActor = nil
                                self.worldViewController!.scene.state = .ready
                                self.isCharacterPickerAnimating = false
                                self.isCharacterPickerActive = false
                                self.worldViewController?.showContinuousIdle()

                            }
                        }
                    }
                }
            }
        }
        
        let leave = SCNAction.animate(with: selectedActorAnimations[.leave].first!)
        self.selectedActor!.scnNode.run(.sequence([leave, dismissPickerNodeAction]))
   }
    
    
    //This action animates the picker world downward and manages character animations.
    func createAnimatePickerWorldOnScreenAction() ->SCNAction {
        return SCNAction.run { [unowned self] (node) in
            self.pickerScene = try! Scene(named: "1.2")
            let pickerWorldRootNode = self.pickerScene!.scnScene.rootNode
            self.pickerContainerNode = SCNNode()
            self.pickerContainerNode!.name = "nodeContainer"
            
            //reparent nodes
            for node in pickerWorldRootNode.childNodes {
                if let name = node.name {
                    switch name {
                    case CameraHandleName:
                        break
                    case "HIGH_QUALITY_FX":
                        node.removeFromParentNode()
                    default:
                        self.pickerContainerNode!.addChildNode(node)
                    }
                }
            }
            self.pickerScene!.scnScene.rootNode.addChildNode(self.pickerContainerNode!)
            
            // Set new scene's camera to match outgoing camera (otherwise skybox jumps).
            let originalCamera = self.worldViewController!.scene.rootNode.childNode(withName: CameraHandleName, recursively: false)!
            let newCamera = self.pickerScene!.rootNode.childNode(withName: CameraHandleName, recursively: false)!
            newCamera.transform = originalCamera.transform
            
            // Set initial orientation and position.
            self.pickerContainerNode!.position.y = animationYOffset
            self.pickerContainerNode!.rotation = newCamera.rotation
            
            
            newCamera.eulerAngles.x += 0.148
            
            DispatchQueue.main.async { [unowned self] in
                self.worldViewController!.scene = self.pickerScene
                self.worldViewController!.scnView.present(self.pickerScene!.scnScene, with: .crossFade(withDuration: 0.75), incomingPointOfView: nil, completionHandler: nil)
                
                let moveScene = SCNAction.moveBy(x: 0, y: -animationYOffset.cgFloat, z: 0, duration: 1.2)
                moveScene.timingMode = .easeOut

                let gridWorld = self.pickerScene!.gridWorld
                gridWorld.isAnimated = false
                gridWorld.place(self.bluActor!, at: Coordinate(column: 1, row: 2))
                gridWorld.place(self.byteActor!, at: Coordinate(column: 3, row: 2))
                gridWorld.place(self.hopperActor!, at: Coordinate(column: 5, row: 2))
                
                // Load geometry for the new characters.
                self.worldViewController!.beginLoadingGeometry()
                
                gridWorld.isAnimated = true
                self.pickerContainerNode!.run(moveScene) { _ in
                    DispatchQueue.main.async { [unowned self] in
                        self.runPickerArriveAnimations()
                    }
                }
              
                // Force a verification pass on the actor to add the start markers.
                self.pickerScene!.state = .built
            }
        }
    }
    
    private func runPickerArriveAnimations() {
        let actors = [bluActor!, hopperActor!, byteActor!]
        let actorAnimationsDispatchGroup = DispatchGroup()
        for actor in actors {
            guard let action = actorAnimationsActionInfo[actor.type] else { continue }
            actorAnimationsDispatchGroup.enter()
            actor.scnNode.run(action) { [unowned self] in
                self.worldViewController?.showContinuousIdle()
                actorAnimationsDispatchGroup.leave()
            }
        }
        actorAnimationsDispatchGroup.notify(queue:DispatchQueue.main) { [unowned self] in
            self.isCharacterPickerAnimating = false
        }
        
    }

    private func startCharacterPickerAnimation() {
        guard !isCharacterPickerActive else { return }
        isCharacterPickerActive = true

        let mainActor = worldViewController!.scene.mainActor!
        originalWorldActor = mainActor
        // Grab the initial state before removing the actor so we can place the newly selected actor there later.
        self.originalActorCoordinate = mainActor.coordinate
        self.originalActorHeading = mainActor.heading
        self.originalActorTransform = mainActor.scnNode.transform
        
        //Setup Needed Actor Animations for: world leave + picker enter + character interactions.
        let actorAnimations = ActorAnimation(type:mainActor.type)
        bluAnimations = ActorAnimation(type:.blu)
        byteAnimations = ActorAnimation(type:.byte)
        hopperAnimations = ActorAnimation(type:.hopper)
        actorAnimationsActionInfo = [ActorType : SCNAction]()
        
        //load character animations for the main character
        ActorAnimation.loadAnimations(for: mainActor.type, actions:[.leave, .arrive, .idle])
        
        self.bluActor    = Actor(name: .blu)
        self.byteActor   = Actor(name: .byte)
        self.hopperActor = Actor(name: .hopper)
        
        //setup character animations
        switch mainActor.type {
        case .blu:
            ActorAnimation.loadAnimations(for: .byte, actions:[.pickerReactRight, .idle])
            ActorAnimation.loadAnimations(for: .hopper, actions: [.pickerReactRight, .idle])
            actorAnimationsActionInfo[.byte] = SCNAction.animate(with: byteAnimations[.pickerReactRight].first!)
            actorAnimationsActionInfo[.hopper] = SCNAction.animate(with: hopperAnimations[.pickerReactRight].first!)
            actorAnimationsActionInfo[.blu] = SCNAction.group([unhideAction, .animate(with: bluAnimations[.arrive].first!)])
            bluActor?.scnNode.isHidden = true
            
        case .byte:
            ActorAnimation.loadAnimations(for: .blu, actions:[.pickerReactLeft, .idle])
            ActorAnimation.loadAnimations(for: .hopper, actions:[.pickerReactRight, .idle])
            actorAnimationsActionInfo[.blu] = SCNAction.animate(with: bluAnimations[.pickerReactLeft].first!)
            actorAnimationsActionInfo[.hopper] = SCNAction.animate(with: hopperAnimations[.pickerReactRight].first!)
            actorAnimationsActionInfo[.byte] = SCNAction.group([unhideAction, .animate(with: byteAnimations[.arrive].first!)])
            byteActor?.scnNode.isHidden = true
            
        case .hopper:
            ActorAnimation.loadAnimations(for: .blu, actions:[.pickerReactLeft, .idle])
            ActorAnimation.loadAnimations(for: .byte, actions:[.pickerReactLeft, .idle])
            actorAnimationsActionInfo[.blu] = SCNAction.animate(with: bluAnimations[.pickerReactLeft].first!)
            actorAnimationsActionInfo[.byte] = SCNAction.animate(with: byteAnimations[.pickerReactLeft].first!)
            actorAnimationsActionInfo[.hopper] = SCNAction.group([unhideAction, .animate(with: hopperAnimations[.arrive].first!)])
            hopperActor?.scnNode.isHidden = true
            
        case .expert:
            // Expert cannot be selected from the character picker.
            break
        }
        let leaveWorldAnimationAction = SCNAction.animate(with: actorAnimations[.leave].first!) // actor animated off screen (upward direction)
 
        //animation complete - clean up
        mainActor.scnNode.removeAllAnimations()
        mainActor.scnNode.removeAllActions()
        
        self.worldScene = self.worldViewController!.scene

        mainActor.scnNode.run(leaveWorldAnimationAction) { [unowned self] in // now animate world downward.
            
            mainActor.scnNode.removeAllAnimations()
            mainActor.scnNode.removeAllActions()
            mainActor.scnNode.isHidden = true
            if self.worldContainerNode == nil {
                //reparent world objs under new node that will be used to animate the world downward.
                let excludedNodes = Set<String>(["CameraHandle", "Lights", "HIGH_QUALITY_FX"]) //these are nodes we do not want to move.
                self.worldContainerNode = SCNNode()
                
                for node in self.worldScene!.scnScene.rootNode.childNodes where node.name != nil && !excludedNodes.contains(node.name!) {
                    self.worldContainerNode!.addChildNode(node)
                }
                
                self.worldScene!.scnScene.rootNode.addChildNode(self.worldContainerNode!) // now we are reparented.
            }
            let moveAction = SCNAction.moveBy(x: 0, y: -animationYOffset.cgFloat, z: 0, duration: 0.8)
            moveAction.timingMode = .easeOut
            self.worldContainerNode!.run(.sequence([moveAction, self.createAnimatePickerWorldOnScreenAction()]))
        }
    }

}
