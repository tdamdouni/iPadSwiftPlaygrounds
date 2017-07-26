// 
//  _AlwaysOn.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//

import PlaygroundSupport
import SceneKit

private var _isLiveViewConnectionOpen = false

extension PlaygroundPage {
    var isLiveViewConnectionOpen: Bool {
        return _isLiveViewConnectionOpen
    }
}

extension WorldViewController: PlaygroundLiveViewMessageHandler {
    // MARK: PlaygroundLiveViewMessageHandler
    
    public func liveViewMessageConnectionOpened() {
        _isLiveViewConnectionOpen = true
        
        // Mark the scene as `ready` to receive more commands.
        scene.reset(duration: 0.5)
        
        // In the LiveView process clear the commandQueue delegates.
        // Overflow from infinite loops will be checked in the user process,
        // Randomized Queue Observation will also take place in the user process.
        scene.commandQueue.reportsAddedCommands = false
    }
    
    public func receive(_ message: PlaygroundValue) {
        guard case let .dictionary(dict) = message else {
            log(message: "Received invalid message: \(message).")
            return
        }
        
        if case let .boolean(passed)? = dict[LiveViewMessageKey.finishedSendingCommands] {
            // Increment the execution count.
            currentPageRunCount += 1
            
            isPassingRun = passed
            
            startPlayback()
            return
        }
        
        let world = scene.gridWorld
        let decoder = CommandDecoder(world: world)
        guard let command = decoder.command(from: message) else {
            log(message: "Failed to decode message: \(message).")
            return
        }
        
        // Directly add the performer. 
        world.commandQueue.append(command)
    }
    
    public func liveViewMessageConnectionClosed() {
        _isLiveViewConnectionOpen = false
        
        // Stop running the command queue.
        scene.commandQueue.runMode = .randomAccess
        scene.state = .initial
    }
}

// MARK: Send Commands

public func sendCommands(for world: GridWorld) {
    let liveView = PlaygroundPage.current.liveView
    guard let liveViewMessageHandler = liveView as? PlaygroundLiveViewMessageHandler else {
        log(message: "Attempting to send commands, but the connection is closed.")
        return
    }
    
    guard world.isAnimated else {
        presentAlert(title: "Failed To Send Commands.", message: "Missing call to `finalizeWorldBuilding(for: world)` in page sources.")
        return
    }
    
    // Complete the queue to ensure the last command is run. 
    world.commandQueue.completeCommands()
    
    // Calculate the results before the world is reset.
    let results = world.calculateResults()
    let passed = results.passesCriteria
    assessmentObserver?.passedCriteria = passed
    
    // Reset the queue to reset state items like Switches, Portals, etc.
    world.commandQueue.reset()
    
    let encoder = CommandEncoder(world: world)
    
    for command in world.commandQueue {
        let message = encoder.createMessage(from: command)
        liveViewMessageHandler.send(message)
        
        #if DEBUG
        // Testing in app.
        let appDelegate = (UIApplication.shared().delegate as! AppDelegate).rootVC
        appDelegate?.receive(message)
        #endif
    }
    
    // Mark that all the commands have been sent, and pass the result of the world.
    let finished = PlaygroundValue.boolean(passed)
    let finalMessage = [LiveViewMessageKey.finishedSendingCommands: finished]
    liveViewMessageHandler.send(.dictionary(finalMessage))
    
    #if DEBUG
    let appDelegate = (UIApplication.shared().delegate as! AppDelegate).rootVC
    appDelegate?.receive(.dictionary(finalMessage))
    #endif
}
