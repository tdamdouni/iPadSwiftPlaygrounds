// 
//  AnimationComponent.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
import SceneKit

class AnimationComponent: NSObject, ActorComponent {
    static let defaultAnimationKey = "DefaultAnimation-Key"
    
    // MARK: Properties
    
    unowned let actor: Actor
    
    lazy var actionAnimations: ActorAnimation = ActorAnimation(type: self.actor.type)

    private var animationNode: SCNNode? {
        // The base `scnNode` holds the node animation should be 
        // applied to as it's first child.
        return actor.scnNode.childNodes.first
    }

    /// The action that is currently running, if any.
    private var currentAction: Action?
    
    private var animationIndex = 0
    
    var currentAnimationDuration = 0.0
    
    // MARK: Initializers
    
    required init(actor: Actor) {
        self.actor = actor
        super.init()
    }
    
    func runDefaultAnimationIndefinitely() {
        guard let defaultAnimation = actionAnimations[.default].first else { return }
        animationNode?.removeAllAnimations()
        
        defaultAnimation.repeatCount = Float.infinity
        defaultAnimation.fadeInDuration = 0.3
        defaultAnimation.fadeOutDuration = 0.3
        animationNode?.add(defaultAnimation, forKey: AnimationComponent.defaultAnimationKey)
    }
    
    func setInitialState(for action: Action) {
        switch action {
        case .move(let startingPosition, _): actor.position = startingPosition
        case .jump(let startingPosition, _): actor.position = startingPosition
        case .turn(let startingRotation, _, _): actor.rotation = startingRotation
        case .teleport(let startingPosition, _): actor.position = startingPosition
        default: break
        }
    }
    
    // MARK: Performer
    
    func applyStateChange(for action: Action) {
        switch action {
        case .move(_, let destination): actor.position = destination
        case .jump(_, let destination): actor.position = destination
        case .turn(_, let rotation, _): actor.rotation = rotation
        case .teleport(_, let destination): actor.position = destination
        default: break
        }
    }
    
    func perform(_ action: Action) {
        // Not all actions apply to the actor, return immediately if there is no animtion.
        guard let animation = action.animation else { return }
        
        currentAction = action
        
        // Ensure that the initial state is correctly set.
        setInitialState(for: action)
        
        playRandom(animation: animation, withSpeed: actor.commandSpeed)
    }
    
    func cancel(_: Action) {
        removeCommandAnimations()
        currentAction = nil
    }
    
    // MARK: ActorComponent
    
    func playRandom(animation: AnimationType, withSpeed speed: Float) {
        let animations = self.actionAnimations[animation]
        
        play(animation: animation, atIndex: animations.randomIndex, speed: speed)
    }
    
    func play(animation animationType: AnimationType, atIndex index: Int, speed: Float) {
        let animation: CAAnimation?
        
        // Look for a faster variation of the requested action to play at speeds above `WorldConfiguration.Actor.walkRunSpeed`.
        if speed > WorldConfiguration.Actor.walkRunSpeed,
            let fastVariation = animationType.fastVariation,
            fastAnimation = actionAnimations.animation(for: fastVariation, index: animationIndex) {
            
            animation = fastAnimation
            animationIndex = animationIndex == 0 ? 1 : 0
        }
        else {
            animation = actionAnimations.animation(for: animationType, index: index)
            animation?.speed = speed //AnimationType.walkingAnimations.contains(action) ? speed : 1.0
        }
        
        guard let readyAnimation = animation else { return }
        readyAnimation.delegate = self
        
        // Remove any lingering animations that may still be attached to the node.
        removeCommandAnimations()
        
        animationNode?.add(readyAnimation, forKey: animationType.rawValue)
        
        // Set the current animation duration.
        currentAnimationDuration = readyAnimation.duration / Double(readyAnimation.speed)
    }
    
    // MARK: Remove
    
    func removeCommandAnimations() {
        guard let animationNode = animationNode else { return }
        
        // Remove all animations, but the default.
        for key in animationNode.animationKeys where key != AnimationComponent.defaultAnimationKey {
            animationNode.removeAnimation(forKey: key)
        }
    }
    
    // MARK: CAAnimation Delegate
    
    override func animationDidStop(_: CAAnimation, finished isFinished: Bool) {
        // Move the character after the animation completes.
        if isFinished {
            completeCurrentCommand()
        }
    }
    
    /// Translates the character based on the type of action.
    private func completeCurrentCommand() {
        SCNTransaction.begin()
        SCNTransaction.animationDuration = 0.0
        
        if let action = currentAction {
            // Update the node's position.
            applyStateChange(for: action)
        }
        
        removeCommandAnimations()
        #if DEBUG
        let existingKeys = animationNode?.animationKeys.count ?? 0
        assert(existingKeys < 3, "There should never be more than the default and current action animations on the actor.")
        #endif
        
        // Cleanup current state. 
        currentAction = nil
        currentAnimationDuration = 0.0
        
        SCNTransaction.commit()
        
        // Fire off the next animation.
        DispatchQueue.main.async { [unowned self] in
            self.actor.performerFinished(self)
        }
    }
}
