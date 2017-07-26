//
//  _AlwaysOn.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//

import PlaygroundSupport
import SceneKit

// MARK: Configuration

public enum Process {
    private(set) static var isLiveViewProcess = false
    fileprivate(set) static var isLiveViewConnectionOpen = false
    
    /// To be called from the Always-on LiveView process to
    /// configure the initial scene set up.
    public static func configureForAlwaysOnLiveView() {
        isLiveViewProcess = true
    }
}

/// Marks if the current run ended in a passing state.
fileprivate(set) var isPassingRun = false

/// Marks that all commands have finished being received from the User Process.
fileprivate(set) var isFinishedProcessingCommands = true

extension SceneController: PlaygroundLiveViewMessageHandler {
    // MARK: PlaygroundLiveViewMessageHandler
    
    public func liveViewMessageConnectionOpened() {
        Process.isLiveViewConnectionOpen = true
        
        // Reset end state and prepare to run the scene.
        isPassingRun = false
        isFinishedProcessingCommands = false
        scene.commandQueue.runMode = .continuous

        // Determine the reset duration based on what state the liveView is in.
        let duration: Double
        if let characterPicker = characterPicker {
            // Rest after dismissing the character picker.
            duration = CharacterPickerController.fadeDuration
            characterPicker.dismiss(toIdle: false)
        }
        else if scene.commandQueue.isEmpty {
            duration = 0
        }
        else {
            duration = WorldConfiguration.Scene.resetDuration
        }
        
        // Mark the scene as `ready` to receive more commands.
        scene.reset(duration: duration)
    }
    
    /// Breaks apart the message looking for info about commands and success criteria.
    public func receive(_ messageValue: PlaygroundValue) {
        guard let message = Message(value: messageValue) else { fatalError("Received invalid message \(messageValue)") }
        
        let world = scene.gridWorld
        
        // Attempt to find the criteria if more specific info is needed for the goal counter.
        if let criteriaValue = message[.successCriteriaInfo],
            let criteria = GridWorld.SuccessCriteria.init(message: criteriaValue) {
            world.successCriteria = criteria
        }
    
        // Try to decode a command from within the message.
        let decoder = CommandDecoder(world: world)
        if let command = decoder.command(from: message) {
            let queue = world.commandQueue
            
            // Check if the queue is finished before adding the command.
            let isFinished = queue.isFinished
            
            // Add the command to the queue.
            queue.append(command)
            
            if scene.state != .run {
                startPlayback()
            }
            else if isFinished {
                queue.runCurrentCommand()
            }
        }
        
        if let passed = message.type(Bool.self, forKey: .finishedSendingCommands) {
            isPassingRun = passed
            
            // All commands have been processed.
            isFinishedProcessingCommands = true
            
            if scene.commandQueue.isFinished {
                scene.state = .done
            }
        }
    }
    
    public func liveViewMessageConnectionClosed() {
        Process.isLiveViewConnectionOpen = false
        
        // Stop running the command queue.
        scene.commandQueue.runMode = .randomAccess
        scene.state = .initial
    }
}

// MARK: Message Sending

var liveViewMessageHandler: PlaygroundLiveViewMessageHandler? {
    let liveView = PlaygroundPage.current.liveView
    return liveView as? PlaygroundLiveViewMessageHandler
}

/// Sends the assessment results for the final world state.
public func sendCommands(for world: GridWorld) {
    guard world.isAnimated else {
        log(message: "Missing call to `finalizeWorldBuilding(for: world)` in page sources.")
        return
    }
    
    // Complete the queue to ensure the last command is run. 
    world.commandQueue.complete()
    
    // Calculate the results before the world is reset.
    let results = world.calculateResults()
    let passed = results.passesCriteria
    assessmentInfo?.passedCriteria = passed
    
    // Mark that all the commands have been sent, and pass the result of the world.
    liveViewMessageHandler?.send(.boolean(passed), forKey: .finishedSendingCommands)
}
