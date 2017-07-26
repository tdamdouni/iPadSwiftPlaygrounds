//
//  ContinuousIdleQueue.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//

import Foundation

/// Runs a set of initial commands before having the actor idle continuously.
final class ContinuousIdleQueue: CommandQueuePerformingDelegate {
    // MARK: Properties
    
    private weak var actor: Actor?
    
    private let queue = CommandQueue()
    
    private(set) var isRunning = false
    
    private(set) var isBreathingOnly = false
    
    init(actor: Actor) {
        self.actor = actor
        
        // Wire up the delegates.
        queue.performingDelegate = self
    }
    
    deinit {
        stop()
    }
    
    func start(initialAnimations: [EventGroup] = [.default], breathingOnly: Bool = false) {
        guard let actor = actor else { return }
        isRunning = true
        isBreathingOnly = breathingOnly
        
        queue.clear()
        
        // Fill the queue with the initial commands.
        let commands = actor.animationCommands(initialAnimations)
        queue.append(commands)
        
        // Manually drive the commandQueue.
        queue.runMode = .randomAccess

        queue.runNextCommand()
    }
    
    func stop() {
        isRunning = false
        
        // Clear the queue to ensure that it is not still running.
        queue.clear()
    }
    
    // MARK: CommandQueueDelegate
    
    func commandQueue(_ queue: CommandQueue, added _: Command) {}
    
    func commandQueue(_ queue: CommandQueue, willPerform _: Command) {
        // Mark all the idle commands to run at the idle speed.
        Actor.commandSpeed = WorldConfiguration.Actor.idleSpeed
    }
    
    func commandQueue(_ queue: CommandQueue, didPerform cmd: Command) {
        guard let actor = actor, isRunning else { return }
        assert(queue === self.queue)
        
        if queue.isFinished {
            queue.clear()
            
            // Add a random delay of `default` breathing animations.
            let delay = actor.animationCommand(.default)
            
            for _ in 0..<randomInt(from: 1, to: 5) {
                queue.append(delay)
            }
            
            if !isBreathingOnly {
                // Add a random idle to the end.
                let idle = actor.animationCommand(.idle)
                queue.append(idle)
            }
            
            // Must run the next command because the queue has been cleared. 
            queue.runNextCommand()
        }
        else {
            // Continue to run the queue. 
            queue.runCurrentCommand()
        }
    }
}
