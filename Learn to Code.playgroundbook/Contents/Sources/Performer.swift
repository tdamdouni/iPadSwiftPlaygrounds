// 
//  Performer.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
import SceneKit

// MARK: PerformerDelegate

protocol PerformerDelegate: class {
    func performerFinished(_ performer: Performer)
}

// MARK: Performer

protocol Performer: class {
    
    var id: Int { get }
    
    func perform(_ action: Action)
    func cancel(_ action: Action)
    
    // O(1) immediate state change. 
    func applyStateChange(for action: Action)
}

// MARK: ActorComponent

/// Used by the ActorComponents as a generic interface for running a action.
protocol ActorComponent: Performer {
    unowned var actor: Actor { get }

    init(actor: Actor)

    func playRandom(animation: AnimationType, withSpeed: Float)
    func play(animation: AnimationType, atIndex: Int, speed: Float)
}

// Default implementations
extension ActorComponent {
    var node: SCNNode {
        return actor.scnNode
    }
    
    var id: Int {
        return actor.id
    }
    
    func key(for action: Action) -> String {
        return "\(self).\(action)"
    }
    
    func applyStateChange(for action: Action) {
        // Optional implementation
    }
    
    func perform(_ action: Action) {
        // Not all commands apply to the actor, return immediately if there is no action.
        guard let animation = action.animation else { return }
        playRandom(animation: animation)
    }
    
    func cancel(_ action: Action) {
        node.removeAnimation(forKey: key(for: action))
        node.removeAction(forKey: key(for: action))
    }
    
    /// Runs the animation, if one exists, for the specified type. Returns the duration.
    func playRandom(animation: AnimationType) {
        playRandom(animation: animation, withSpeed: actor.commandSpeed)
    }
    
    func playRandom(animation: AnimationType, withSpeed: Float) {
        // Optional implementation
    }
    
    func play(animation: AnimationType, atIndex index: Int, speed: Float) {
        // Optional implementation
    }
}
