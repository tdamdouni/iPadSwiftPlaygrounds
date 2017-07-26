// 
//  Command.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
import Foundation

/// An `Command` associates a command with the actor that can perform that command.
public struct Command {
    unowned let performer: Performer
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
    
    /// Convenience to run the command against the `performer`.
    func perform() {
        performer.perform(action)
    }
    
    func cancel() {
        performer.cancel(action)
    }
}

extension Command: CustomDebugStringConvertible {
    public var debugDescription: String {
        return "\(performer.dynamicType): \(action)"
    }
}

extension Command: Equatable {}

public func ==(lhs: Command, rhs: Command) -> Bool {
    return lhs.action == rhs.action && lhs.performer === rhs.performer
}
