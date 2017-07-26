//
//  Command.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
import Foundation

/// A `Command` associates an action with the performer that can handle that command.
public struct Command {
    let performer: Performer
    let action: Action
    
    init(performer: Performer, action: Action) {
        self.performer = performer
        self.action = action
    }
    
    // MARK:
    
    func applyStateChange(inReverse reversed: Bool = false) {
        let directionalCommand = reversed ? action.reversed : action
        performer.applyStateChange(for: directionalCommand)
    }
    
    /// Convenience to run the `action` against the `performer`.
    /// Returns the result for the performer. 
    func perform() -> PerformerResult {
        return performer.perform(action)
    }
    
    func cancel() {
        performer.cancel(action)
    }
}

extension Command: CustomDebugStringConvertible {
    public var debugDescription: String {
        return "\(type(of: performer)): \(action)"
    }
}

extension Command: Equatable {}

public func ==(lhs: Command, rhs: Command) -> Bool {
    return lhs.action == rhs.action && lhs.performer === rhs.performer
}
