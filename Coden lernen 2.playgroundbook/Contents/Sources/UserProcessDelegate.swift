//
//  UserProcessDelegate.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//

import PlaygroundSupport

/**
 UserProcessDelegate responds to messages coming from the LiveView processor.
 
 The methods below are only called in the user process.
 */
final class UserProcessDelegate: PlaygroundRemoteLiveViewProxyDelegate {
    // MARK: Properties
    
    var pauseHandler: CommandPauseDelegate?
    
    init(pauseHandler: CommandPauseDelegate?) {
        self.pauseHandler = pauseHandler
    }
    
    // MARK: PlaygroundRemoteLiveViewProxyDelegate
    
    func remoteLiveViewProxyConnectionClosed(_ remoteLiveViewProxy: PlaygroundRemoteLiveViewProxy) {
        
        // Finish the user process if LiveView process closed.
        PlaygroundPage.current.finishExecution()
    }
    
    func remoteLiveViewProxy(_ remoteLiveViewProxy: PlaygroundRemoteLiveViewProxy, received value: PlaygroundValue) {
        guard let message = Message(value: value) else { return }

        if message.type(Bool.self, forKey: .finishedEvaluating) != nil {
            assessmentInfo?.setAssessmentStatus()
            
            // Finish the user process execution.
            PlaygroundPage.current.finishExecution()
        }
        else if message.type(Bool.self, forKey: .readyForMoreCommands) != nil {
            // Indicate that the handler is ready for more commands.
            pauseHandler?.isReadyForMoreCommands = true
        }
    }
}

