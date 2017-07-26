//
//  CommandQueue.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//

import Foundation

protocol CommandQueueDelegate: class {
    func commandQueue(_ queue: CommandQueue, added command: Command)
}

protocol CommandQueuePerformingDelegate: CommandQueueDelegate {
    func commandQueue(_ queue: CommandQueue, willPerform command: Command)
    func commandQueue(_ queue: CommandQueue, didPerform command: Command)
}

/**
    A queue which all commands are added so that top level code always 
    executers in order, one command at a time.
*/
public final class CommandQueue {
    // MARK: Types
    
    enum RunMode {
        case continuous, randomAccess
        
        /// Testing purposes only. Run the command as soon as it is added to the queue.
        case completeImmediately
    }
    
    // MARK: Properties 
    
    var runMode: RunMode = .continuous
    
    /// A delegate to report when commands are added to the queue.
    weak var addingDelegate: CommandQueueDelegate?
    
    /// A delegate which responds to commands being performed.
    weak var performingDelegate: CommandQueuePerformingDelegate?

    var isFinished: Bool {
        return currentIndex >= endIndex || isEmpty
    }
    
    /// Returns `true` if the queue is running the `currentCommand`.
    private(set) var isRunning = false
    
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
    fileprivate var commands = [Command]()
    
    /// Return an index that clamps `currentCommandIndex` between 0...commands.count.
    fileprivate var currentClampedIndex: Int {
        return currentIndex.clamp(min: 0, max: commands.count)
    }

    /// Used to synchronously dispatch around `currentCommandIndex`.
    private let commandIndexQueue = DispatchQueue(label: "com.LTC.CommandQueue")
    
    /// Points at the currently running instruction (none initially).
    private var _currentIndex = -1
    fileprivate var currentIndex: Int {
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
    
    public func append(_ commands: [Command]) {
        for command in commands {
            append(command)
        }
    }
    
    public func append(_ command: Command) {
        append(command, applyingState: false)
    }
    
    func append(_ command: Command, applyingState: Bool) {
        commands.append(command)
        
        if applyingState {
            applyStateAdvancingCurrentIndex(for: command)
        }
        
        addingDelegate?.commandQueue(self, added: command)
        performingDelegate?.commandQueue(self, added: command)
        
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
    private func applyStateAdvancingCurrentIndex(for command: Command) {
        precondition(command == commands.last)
        currentIndex = endIndex

        command.applyStateChange()
    }
    
    // MARK: Run Commands
    
    func runCurrentCommand() {
        guard !isRunning else { return }
        runCommand(atIndex: currentIndex)
    }
    
    func runNextCommand() {
        let nextIndex = commands.index(after: currentIndex)
        runCommand(atIndex: nextIndex)
    }
    
    /// Returns the command if the index is valid and can be run.
    func runCommand(atIndex index: Int) {
        guard commands.indices.contains(index) else {
            // Mark the `currentIndex` at the end.
            currentIndex = endIndex
            return
        }
        
        // Adjust runMode for the requested index. (Makes it easier on the caller).
        let indexDelta = abs(currentIndex - index)
        if indexDelta > 1 {
            runMode = .randomAccess
            
            // Cancel the current command before running another command.
            cancelCurrentCommand()
            
            // If not accessing commands in order, the world state has to updated.
            correctState(movingFrom: currentIndex, to: index)
        }
        
        // Set the current index before running the command, otherwise it's possible to loop continuously.
        currentIndex = index

        let command = commands[index]
        performingDelegate?.commandQueue(self, willPerform: command)
        
        isRunning = true
        let result = command.perform()
        
        result.completionHandler = { [weak self] _ in
            self?.finishCommand(command)
        }
    }
    
    /// Convenience method to mark the command as complete, inform the `performingDelegate`, and
    /// determine the next behavior based on the `runMode`.
    fileprivate func finishCommand(_ command: Command) {
        // Mark that the queue is no longer running a command.
        isRunning = false
        
        // Advance the index to the next command (before calling the delegate).
        // This allows the delegate to get the correct response for `isFinished`. 
        currentIndex = commands.index(after: currentIndex)
        performingDelegate?.commandQueue(self, didPerform: command)
        
        // Run the next command.
        if runMode == .continuous {
            runCommand(atIndex: currentIndex)
        }
    }
    
    /// Cancels the `currentCommand`.
    fileprivate func cancelCurrentCommand() {
        guard let command = currentCommand else { return }
        command.cancel()
    }
    
    /// Completes all the commands in the queue. (Does not animate)
    func complete() {
        correctState(movingFrom: currentIndex, to: endIndex)
        currentIndex = endIndex
    }
    
    // MARK: Reset Commands
    
    func resetPreviousCommand() {
        runMode = .randomAccess
        cancelCurrentCommand()
        
        // The world state has to updated for the command that is being reset.
        let zeroClampedIndex = Swift.max(commands.index(before: currentIndex), 0)
        correctState(movingFrom: currentIndex, to: zeroClampedIndex)
        
        // Decrement the index if it's within a valid range.
        if currentIndex >= 0 {
            currentIndex -= 1
        }
    }
    
    /// Resets the queue's state back to the start
    /// from the `currentIndex`.
    func rewind() {
        // Make sure the `currentCommand` state has been applied.
        currentCommand?.applyStateChange()
        
        // Corrects the state for completed commands.
        correctState(movingFrom: currentIndex, to: startIndex)
        currentIndex = -1
    }
    
    /// Clears the queue.
    /// NOTE: This does not rewind the world state. Call `rewind()` prior to `clear()`
    /// if the world state needs to be reset. 
    func clear() {
        cancelCurrentCommand()
        
        commands = []
        currentIndex = -1
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
    fileprivate func correctState(movingFrom start: Int, to end: Int) {
        guard !commands.isEmpty && start != end else { return }
        
        let maxIndex = endIndex - 1
        let startClamped = start.clamp(min: 0, max: maxIndex)
        let endClamped = end.clamp(min: 0, max: maxIndex)
        
        let isReversing = endClamped <= startClamped
        let commandsRange = isReversing ? endClamped...startClamped : startClamped...endClamped
        let stateIndices: [Int] = isReversing ? Array(commandsRange).reversed() : Array(commandsRange)
        
        for index in stateIndices {
            let command = commands[index]
            command.applyStateChange(inReverse: isReversing)
        }
    }
}

// MARK: Collection 

extension CommandQueue: RangeReplaceableCollection {
    
    public var startIndex: Int {
        return 0
    }
    
    public var endIndex: Int {
        return commands.endIndex
    }
    
    public subscript(position: Int) -> Command {
        return commands[position]
    }
    
    public func index(after i: Int) -> Int {
        return i + 1
    }
    
    // MARK: RangeReplaceable
    
    public func replaceSubrange<C: Collection>(_ subrange: Range<Int>, with newElements: C) where C.Iterator.Element == Command {
        
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
        var counter = 0
        let commandsDesc = commands.reduce("") { str, command in
            let currentCmd = "\(counter): \(command)\n"
            counter += 1
            
            return str + currentCmd
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
    
    public func indexOfFirstCorrectToggle(for actor: Actor? = nil) -> Int? {
        let commands = completedCommands(for: actor)
        
        return commands.index {
            if case let .control(contr) = $0, contr.kind == .toggle {
                return contr.state
            }
            return false
        }
    }
    
    public func indexOfFirstCollectedGem(for actor: Actor? = nil) -> Int? {
        let commands = completedCommands(for: actor)
        
        return commands.index {
            // If an actor executed a remove action, it has to be for a gem. 
            if case .remove(_) = $0 {
                return true
            }
            return false
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
            if case let .control(contr) = $0, contr.kind == .toggle  {
                return !contr.state
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
            guard case let .fail(action) = $0 else { return nil }
            return action
        }
    }
}

// MARK: CollapseCommands

extension CommandQueue {
    func collapsePlacementCommands(in cmdRange: CountableRange<Int>) {
        let commands = self[cmdRange]
        
        let nonPlacementCommands = commands.filter { currentCommand in
            if case .add(_) = currentCommand.action {
                return false
            }
            return true
        }
        
        /// Only placement commands for the world can be collapsed.
        var world: GridWorld!
        let placementIds = commands.reduce([ItemID]()) { combiningIds, currentCommand in
            if case let .add(ids) = currentCommand.action, let performer = currentCommand.performer as? GridWorld {
                world = performer
                return combiningIds + ids
            }
            return combiningIds
        }
        guard !placementIds.isEmpty else { return }
        
        let collapsedPlacement = Command(performer: world, action: .add(placementIds))
        let collapsedCommands = [collapsedPlacement] + nonPlacementCommands
        
        let range = Range(uncheckedBounds: (cmdRange.startIndex, cmdRange.endIndex))
        
        // Adjust `currentIndex` around the replaced range to ensure the commands are not marked as `completed`.
        currentIndex = range.lowerBound
        replaceSubrange(range, with: collapsedCommands)
        currentIndex = range.upperBound
    }
}
