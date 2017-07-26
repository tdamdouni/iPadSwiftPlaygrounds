//
//  CommandSender.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//

import Foundation

protocol CommandPauseDelegate {
    var isReadyForMoreCommands: Bool { get set }
}

extension CommandPauseDelegate {
    /// Waits until `isReadyForMoreCommands` is set to true.
    func wait() {
        // Do not block the LiveView process.
        guard !Process.isLiveViewProcess else { return }
        
        repeat {
            RunLoop.main.run(mode: .defaultRunLoopMode, before: Date(timeIntervalSinceNow: 0.1))
        } while !isReadyForMoreCommands
    }
}

class CommandSender: CommandQueueDelegate, CommandPauseDelegate {
    // MARK: Properties
    
    let encoder: CommandEncoder
    
    /// Indicates if the process should wait after adding a command.
    var shouldWaitForResponse = true
    
    var isReadyForMoreCommands = true
    
    init(world: GridWorld) {
        encoder = CommandEncoder(world: world)
        
        world.commandQueue.addingDelegate = self
    }
    
    // MARK: CommandEnqueuingDelegate
    
    func commandQueue(_ queue: CommandQueue, added command: Command) {
        guard let messageHandler = liveViewMessageHandler else {
            fatalError("Unable to send commands, missing `liveViewMessageHandler`.")
        }

        let value = encoder.createValue(from: command)
        messageHandler.send(value)

        if shouldWaitForResponse {
            // Spin the runloop until the LiveView process has completed the current command.
            isReadyForMoreCommands = false
            wait()
        }
    }
}
