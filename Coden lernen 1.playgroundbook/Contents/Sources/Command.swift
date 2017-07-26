//
//  Command.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//
import Foundation

/// A `Command` associates an action with the performer that can handle that command.
public struct Command {
    let performer: Performer
    let action: Action
    var isWorldBuildCommand: Bool = false
    
    init(performer: Performer, action: Action) {
        self.performer = performer
        self.action = action
        self.isWorldBuildCommand = Command.processingWorldBuildingCommands
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
    
    // This value is set to false at the end of finalizeWorldBuilding() to indicate that all world building commands have been submitted.
    static var processingWorldBuildingCommands = true
}

extension Command: CustomDebugStringConvertible {
    public var debugDescription: String {
        return "\(type(of: performer)):" + (isWorldBuildCommand == true ? " [world build cmd] " : " ") + "\(action)"
    }
}

extension Command: Equatable {}

public func ==(lhs: Command, rhs: Command) -> Bool {
    return lhs.action == rhs.action && lhs.performer === rhs.performer && lhs.isWorldBuildCommand == rhs.isWorldBuildCommand
}
