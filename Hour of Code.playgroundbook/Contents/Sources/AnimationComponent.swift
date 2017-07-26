//
//  AnimationComponent.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//

import SceneKit

class AnimationComponent: NSObject, CAAnimationDelegate, ActorComponent, ActorNode {
    // MARK: Properties
    
    unowned let actor: Actor
    
    var animationCache: AssetCache {
        return AssetCache.cache(forType: self.actor.type)
    }

    private var animationNode: SCNNode {
        // The base `scnNode` holds the node animation should be 
        // applied to as it's first child.
        let geo = actor.scnNode.childNodes.first
        return geo ?? actor.scnNode
    }
    
    private var animationStepIndex = 0
    
    var currentAnimationDuration = 0.0
    
    // MARK: Initializers
    
    init(actor: Actor) {
        self.actor = actor
        super.init()
    }
    
    func setInitialState(for action: Action) {
        switch action {
        case .move(let dis, _): actor.position = dis.from
        case .turn(let dis, _): actor.rotation = dis.from
        default: break
        }
    }
    
    // MARK: Performer
    
    func applyStateChange(for action: Action) {
        switch action {
        case .move(let dis, _): actor.position = dis.to
        case .turn(let dis, _): actor.rotation = dis.to
            
        case .run(let event, variation: _) where event == .leave:
            actor.scnNode.isHidden = true
            
        default: break
        }
    }
    
    func cancel(_: Action) {
        removeAnimations()
    }
    
    // MARK: ActorComponent
    
    func perform(event: EventGroup, variation index: Int, speed: Float) -> PerformerResult {
        guard let action = actor.currentAction else { return .done(self) }
        
        // Ensure the initial state is correct.
        setInitialState(for: action)
        
        // If the actor is not in the world, execute the action immediately.
        guard actor.isInWorld || actor.isInCharacterPicker else {
            applyStateChange(for: action)
            return .done(self)
        }
        
        let animation: CAAnimation?
        
        // Look for a faster variation of the requested action to play at speeds above `WorldConfiguration.Actor.walkRunSpeed`.
        if speed >= WorldConfiguration.Actor.walkRunSpeed,
            let fastVariation = event.fastVariation,
            let fastAnimation = animationCache.animation(for: fastVariation, index: animationStepIndex) {
            
            animation = fastAnimation
            animation?.speed = max(speed - WorldConfiguration.Actor.walkRunSpeed, 1)
            animationStepIndex = animationStepIndex == 0 ? 1 : 0
        }
        else {
            animation = animationCache.animation(for: event, index: index)
            animation?.speed = speed
        }
        
        guard let readyAnimation = animation?.copy() as? CAAnimation else { return .done(self) }
        readyAnimation.setDefaultAnimationValues(isStationary: event.isStationary)
        
        let result = PerformerResult.differed(self)
        readyAnimation.stopCompletionBlock = { [weak self] isFinished in
            guard isFinished else { return }
            // Move the character after the animation completes.
            self?.completeCurrentCommand()
                
            // Mark the component as complete. 
            DispatchQueue.main.async {
                result.complete()
            }
        }
        
        // Remove any lingering animations that may still be attached to the node.
        removeAnimations()
        animationNode.addAnimation(readyAnimation, forKey: event.rawValue)
        
        // Set the current animation duration.
        currentAnimationDuration = readyAnimation.duration / Double(readyAnimation.speed)
        
        return result
    }
    
    // MARK: Remove
    
    func removeAnimations() {
        func removeAnimations(from node: SCNNode) {
            // Remove all animations.
            for key in node.animationKeys {
                node.removeAnimation(forKey: key)
            }
        }
        removeAnimations(from: actor.scnNode)
        removeAnimations(from: animationNode)
    }

    // MARK: Complete 
    
    /// Translates the character based on the type of action.
    private func completeCurrentCommand() {
        // Cleanup current state.
        currentAnimationDuration = 0.0

        SCNTransaction.begin()
        SCNTransaction.animationDuration = 0.0
        
        if let action = actor.currentAction {
            // Update the node's position.
            applyStateChange(for: action)
        }
        removeAnimations()
        
        SCNTransaction.commit()
    }
}
