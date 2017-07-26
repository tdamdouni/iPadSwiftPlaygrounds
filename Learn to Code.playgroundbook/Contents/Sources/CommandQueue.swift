//
//  CommandQueue.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//

import Foundation

protocol CommandQueueDelegate: class {
    func commandQueue(_ queue: CommandQueue, added command: Command)
}

/**
    CommandQueue is a single queue in which all commands are added
    so that top level code always executers in order, one command at
    at time.
*/
public final class CommandQueue {
    // MARK: Types
    
    enum RunMode {
        case continuous
        case randomAccess
        
        /// Testing purposes only. Run the command as soon as it is added to the queue.
        case completeImmediately
        
        var isDiscrete: Bool {
            return self == .randomAccess
        }
    }
    
    // MARK: Properties 
    
    var runMode: RunMode = .continuous
    
    /// A flag used to enable/disable delegate calls depending on what process the queue is in.
    var reportsAddedCommands = true
    
    weak var delegate: CommandQueueDelegate?
    weak var overflowDelegate: CommandQueueDelegate?
    
    var isFinished: Bool {
        return currentIndex == endIndex || isEmpty
    }
    
    /// Return an index that clamps `currentCommandIndex` between 0...commands.count.
    private var currentClampedIndex: Int {
        return currentIndex.clamp(min: 0, max: commands.count)
    }
    
    /// Includes all commands yet to complete (including the current command).
    var pendingCommands: ArraySlice<Command> {
        let index = currentClampedIndex
        guard index <= endIndex else { return [] }
        return commands.suffix(from: index)
    }
    
    /// Includes all commands that have been run.
    var completedCommands: ArraySlice<Command> {
        let index = commands.index(before: currentClampedIndex)
        guard !isEmpty && index >= startIndex else { return [] }
        return commands.prefix(through: index)
    }
    
    /// The command that is currently being run.
    var currentCommand: Command? {
        guard indices.contains(currentIndex) else { return nil }
        return commands[currentIndex]
    }
    
    /// Underlying commands may only be mutated by accessor methods. @see `addCommand(_:)`
    private var commands = [Command]()

    /// Used to synchronously dispatch around `currentCommandIndex`.
    private let commandIndexQueue = DispatchQueue(label: "com.MicroWorlds.CommandQueue")
    
    /// -1 initially because it points at the currently running instruction (None initially).
    private var _currentIndex = -1
    private var currentIndex: Int {
        get {
            return _currentIndex
        }
        set {
            commandIndexQueue.sync {
                _currentIndex = newValue
            }
        }
    }
    
    public init() {}
    
    // MARK: Add Commands
    
    public func append(_ command: Command) {
        append(command, applyingState: false)
    }
    
    func append(_ command: Command, applyingState: Bool) {
        commands.append(command)
        
        if applyingState {
            applyStateAdvancingCurrentIndex(for: command)
        }
        
        if reportsAddedCommands {
            delegate?.commandQueue(self, added: command)
            overflowDelegate?.commandQueue(self, added: command)
        }
        
        // Testing purposes only.
        if runMode == .completeImmediately {
            runNextCommand()
        }
    }
    
    /**
        Currently all commands are enqueued before being reversed
        and played back. Whenever a new command is added,
        apply the current state to update the world for future
        calculations.
    */
    func applyStateAdvancingCurrentIndex(for command: Command) {
        precondition(command == commands.last)
        currentIndex = endIndex

        command.applyStateChange()
    }
    
    // MARK: Run Commands
    
    func runNextCommand() {
        runCommand(atIndex: commands.index(after: currentIndex))
    }
    
    /// Returns the command if the index is valid and can be run.
    func runCommand(atIndex index: Int) {
        // Reset index for invalid indices.
        guard index < commands.count else { currentIndex = commands.count; return }
        guard index >= 0 else { currentIndex = -1; return }
        
        let indexDelta = abs(currentIndex - index)
        
        // Adjust runMode for the requested index. (Makes it easier on the caller).
        if indexDelta > 1 {
            runMode = .randomAccess
            
            // Cancel the current command before running another command.
            currentCommand?.cancel()
            
            // If not accessing commands in order, the world state has to updated.
            correctState(movingFrom: currentIndex, to: index)
        }
        
        // Set the current index before running the command, otherwise it's possible to loop continuously.
        currentIndex = index
        
        let command = commands[index]
        command.perform()
    }
    
    /// Completes all the commands in the queue. (Does not animate)
    func completeCommands() {
        correctState(movingFrom: currentIndex, to: endIndex)
        currentIndex = endIndex
    }
    
    // MARK: Reset Commands
    
    func resetPreviousCommand() {
        runMode = .randomAccess
        currentCommand?.cancel()
        
        // The world state has to updated for the command that is being reset.
        let zeroClampedIndex = Swift.max(commands.index(before: currentIndex), 0)
        correctState(movingFrom: currentIndex, to: zeroClampedIndex)
        
        // Decrement the index only if it's within a valid range.
        if currentIndex >= 0 {
            currentIndex -= 1
        }
    }
    
    /// Resets the queue's state back to the start
    /// from the `currentIndex`.
    func reset() {
        let index = self.index(after: currentIndex)
        
        // Corrects the state for completed commands.
        correctState(movingFrom: index, to: startIndex)
        currentIndex = -1
    }
    
    /// Clears the queue and resets all necessary state.
    func clear() {
        currentCommand?.cancel()
        
        reset()
        commands = []
    }
    
    /**
        Adjusts the world state to match commands between the provided indices.
     
        This may involve rolling the state forward to a specified index or reversing 
        the commands to restore the state back to a specified index.
     
        e.g. calling `correctState(between: endIndex, end: 0)`
        rewinds the worlds state back to before the first command was executed
        by reversing every command (placing collected gems, toggling switches
        appropriately).
    */
    private func correctState(movingFrom start: Int, to end: Int) {
        guard !commands.isEmpty && start != end else { return }
        
        let maxIndex = endIndex - 1
        let startClamped = start.clamp(min: 0, max: maxIndex)
        let endClamped = end.clamp(min: 0, max: maxIndex)
        
        let isReversing = endClamped <= startClamped
        let commandsRange = isReversing ? endClamped...startClamped : startClamped...endClamped
        let stateIndices: [Int] = isReversing ? Array(commandsRange).reversed() : Array(commandsRange)
        
        for index in stateIndices {
            let commandPerformer = commands[index]
            commandPerformer.applyStateChange(inReverse: isReversing)
        }
    }
}

// MARK: Collection 

extension CommandQueue: RangeReplaceableCollection {
    // MARK: Collection 
    
    public var startIndex: Int {
        return 0
    }
    
    public var endIndex: Int {
        return commands.count
    }
    
    public subscript(position: Int) -> Command {
        return commands[position]
    }
    
    public func index(after i: Int) -> Int {
        return i + 1
    }
    
    // MARK: RangeReplaceable
    
    public func replaceSubrange<C: Collection where C.Iterator.Element == Command>(_ subrange: Range<Int>, with newElements: C) {
        
        // Create closed range.
        let subrange = subrange.lowerBound..<subrange.upperBound
        let completedRange = startIndex..<currentClampedIndex
        
        // Check for commands that need to be reversed before they are replaced.
        if completedRange.upperBound > subrange.lowerBound {
            let overlap = subrange.clamped(to: completedRange)
            
            correctState(movingFrom: overlap.upperBound, to: overlap.lowerBound)
        }
        
        // Have the underlying `commands` array perform the replacement.
        commands.replaceSubrange(subrange, with: newElements)
    }
}

extension CommandQueue: CustomDebugStringConvertible {
    public var debugDescription: String {
        let commandsDesc = commands.reduce("") { str, command in
            str + "\(command)\n"
        }
        
        return "\(count) commands\nIndex: \(currentIndex)\n" + commandsDesc
    }
}

extension CommandQueue {
    // MARK: Assessment Count
    
    public func collectedGemCount(for actor: Actor? = nil) -> Int {
        let commands = completedCommands(for: actor)

        return commands.reduce(0) { count, command in
            guard case .remove(let items) = command else {
                return count
            }
            
            return count + items.count
        }
    }
    
    // MARK: Assessment Incorrect Commands

    public func containsIncorrectMoveForwardCommand(for actor: Actor? = nil) -> Bool {
        let commands = incorrectCommands(for: actor)
        
        let incorrectMoveForwardCommands: [IncorrectAction] = [
            .offEdge,
            .intoWall
        ]
        
        return commands.contains {
            return incorrectMoveForwardCommands.contains($0)
        }
    }
    
    public func containsIncorrectCollectGemCommand(for actor: Actor? = nil) -> Bool {
        let commands = incorrectCommands(for: actor)
        return commands.contains(.missingGem)
    }
    
    public func containsIncorrectToggleCommand(for actor: Actor? = nil) -> Bool {
        let commands = incorrectCommands(for: actor)
        
        return commands.contains(.missingSwitch)
    }
    
    public func triedToMoveOffEdge(for actor: Actor? = nil) -> Bool {
        let commands = incorrectCommands(for: actor)
        
        return commands.contains(.offEdge)
    }
    
    public func triedToMoveIntoWall(for actor: Actor? = nil) -> Bool {
        let commands = incorrectCommands(for: actor)
        
        return commands.contains(.intoWall)
    }
    
    // MARK: Suboptimal Commands
    
    public func closedAnOpenSwitch(for actor: Actor? = nil) -> Bool {
        let commands = completedCommands(for: actor)
        
        return commands.contains {
            if case let .toggle(_, on) = $0  {
                return !on
            }
            return false
        }
    }
    
    // MARK: Convenience
    
    /// Returns the commands for a specified actor, or all 
    /// commands if the actor is `nil`.
    func completedCommands(for actor: Actor?) -> [Action] {
        return completedCommands.flatMap { actorCommand in
            
            // Ignore commands performed on any `performer`s other than an Actor.
            guard let commandActor = actorCommand.performer as? Actor else {
                return nil
            }
            
            // If no actor was specified return the action (includes all actor commands).
            guard let actor = actor else {
                return actorCommand.action
            }
            
            // Make sure the command's actor matches the requested actor.
            guard commandActor == actor else {
                return nil
            }
            
            return actorCommand.action
        }
    }
    
    func incorrectCommands(for actor: Actor?) -> [IncorrectAction] {
        let commands = self.completedCommands(for: actor)
        
        return commands.flatMap {
            guard case let .incorrect(action) = $0 else { return nil }
            return action
        }
    }
}

// MARK: CollapseCommands

extension CommandQueue {
    func collapsePlacementCommands(in cmdRange: CountableRange<Int>) {
        let commands = self[cmdRange]
        
        let nonPlacementCommands = commands.filter { currentCommand in
            if case .place(_) = currentCommand.action {
                return false
            }
            return true
        }
        
        /// Only placement commands for the world can be collapsed.
        var world: GridWorld!
        let placementIds = commands.reduce([Int]()) { combiningIds, currentCommand in
            if case let .place(ids) = currentCommand.action, let performer = currentCommand.performer as? GridWorld {
                world = performer
                return combiningIds + ids
            }
            return combiningIds
        }
        guard !placementIds.isEmpty else { return }
        
        let collapsedPlacement = Command(performer: world, action: .place(placementIds))
        let collapsedCommands = [collapsedPlacement] + nonPlacementCommands
        
        let range = Range(uncheckedBounds: (cmdRange.startIndex, cmdRange.endIndex))
        
        // Adjust `currentIndex` around the replaced range to ensure the commands are not marked as `completed`.
        currentIndex = range.lowerBound
        replaceSubrange(range, with: collapsedCommands)
        currentIndex = range.upperBound
    }
}
