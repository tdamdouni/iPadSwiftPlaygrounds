// 
//  QueueOverflowHandler.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//

import Foundation
import PlaygroundSupport

class QueueOverflowHandler: CommandQueueDelegate {
    
    // Allow 250 commands to be enqueued at a time before starting to run.
    static let commandLimit = 250
    
    unowned let world: GridWorld
    
    var isReadyForMoreCommands = true
    
    init(world: GridWorld) {
        self.world = world
        
        world.commandQueue.overflowDelegate = self
    }
    
    // MARK: CommandQueueDelegate
    
    func commandQueue(_ queue: CommandQueue, added _: Command) {
        
        guard isReadyForMoreCommands else { return }

        if queue.count > QueueOverflowHandler.commandLimit {
            isReadyForMoreCommands = false
            
            // Set the assessment status to update the hints. 
            assessmentObserver?.setAssessmentStatus()
            
            sendCommands(for: world)
            
            // Spin the runloop until the LiveView process is ready for more commands. 
            repeat {
                RunLoop.main().run(mode: .defaultRunLoopMode, before: Date(timeIntervalSinceNow: 0.1))
            } while !isReadyForMoreCommands
        }
    }
}
