// 
//  Performer.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
import SceneKit

// MARK: Performer

protocol Performer: class, Identifiable {
    /// Applies an immediate state change for the action without an animation.
    func applyStateChange(for action: Action)
    
    /// Performs the action with an animation.
    /// Returns `true` if the action is running.
    func perform(_ action: Action) -> PerformerResult
    
    /// Cancels any inflight animations.
    func cancel(_ action: Action)
}

// MARK: PerformerResult

typealias PerformerHandler = (Performer) -> Void

class PerformerResult {
    var completionHandler: PerformerHandler? {
        didSet {
            guard !isAsynchronous && completionHandler != nil else { return }
            DispatchQueue.main.async {
                self.complete()
            }
        }
    }
    
    let isAsynchronous: Bool
    
    private(set) weak var performer: Performer?
    
    static func done(_ performer: Performer) -> PerformerResult {
        return PerformerResult(performer, isAsynchronous: false)
    }
    
    static func differed(_ performer: Performer) -> PerformerResult {
        return PerformerResult(performer, isAsynchronous: true)
    }
    
    init(_ performer: Performer, isAsynchronous: Bool) {
        self.performer = performer
        self.isAsynchronous = isAsynchronous
    }
    
    func complete() {
        guard let performer = performer else { return }
        completionHandler?(performer)
        
        // A result may only be completed once.
        completionHandler = nil
    }
}

// MARK: ActorComponent

/// Used by the ActorComponents as a generic interface for running a action.
protocol ActorComponent: Performer {
    /// The actor with which this component applies to.
    unowned var actor: Actor { get }
    
    /// Performs the requested event, with the specified variation.
    /// Returns a `PerformerResult` to handle the completion of the event.
    func perform(event: EventGroup, variation: Int, speed: Float) -> PerformerResult
}

extension ActorComponent {
    // MARK: ActorComponent default implementations

    var id: ItemID {
        return actor.id
    }
    
    var node: SCNNode {
        return actor.scnNode
    }
    
    var currentAction: Action? {
        return actor.currentAction
    }
    
    func key(for action: Action) -> String {
        return "\(self).\(action)"
    }
    
    func applyStateChange(for action: Action) {
        // Optional implementation.
    }
    
    func cancel(_ action: Action) {
        node.removeAnimation(forKey: key(for: action))
        node.removeAction(forKey: key(for: action))
    }
    
    /// Performs the first animation corresponding to the action (if one exists).
    func perform(_ action: Action) -> PerformerResult {
        // Optional implementation.
        return PerformerResult.done(self)
    }
    
    /// Runs the animation, if one exists, for the specified type. Returns the duration.
    func perform(event: EventGroup, variation: Int) -> PerformerResult {
        return perform(event: event, variation: variation, speed: Actor.commandSpeed)
    }
    
    func perform(event: EventGroup, variation: Int, speed: Float) -> PerformerResult {
        // Fallback to the basic `perform` request if a more specific `perform(event:variation:speed)` is not provided.
        guard let action = actor.currentAction else { return PerformerResult.done(self) }
        
        return perform(action)
    }
}

extension Performer where Self: Item {
    // MARK: Performer-Item default implementations
    
    func applyStateChange(for action: Action) {
        switch action {
        case .move(let dis, _): position = dis.to
        case .turn(let dis, _): rotation = dis.to
        default:
            fatalError("\(self) is not capable of performing \(action).")
        }
    }
    
    func perform(_ action: Action) -> PerformerResult {
        applyStateChange(for: action)
        return PerformerResult.done(self)
    }
    
    func cancel(_ action: Action) {}
}
