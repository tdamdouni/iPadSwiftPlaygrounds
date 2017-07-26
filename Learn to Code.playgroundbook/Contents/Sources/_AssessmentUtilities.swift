// 
//  _AssessmentUtilities.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//

import Foundation
import PlaygroundSupport

public typealias AssessmentResults = PlaygroundPage.AssessmentStatus

// MARK: Assessment Hooks

var assessmentObserver: AssessmentObserver?
var overflowHandler: QueueOverflowHandler?

// MARK: Assessment Registration

public func registerAssessment(_ world: GridWorld, assessment: () -> AssessmentResults) {
    // Add an `QueueOverflowHandler` to catch infinite loops.
    overflowHandler = QueueOverflowHandler(world: world)
    
    // The assessment observer handles the assessment notifications.
    assessmentObserver = AssessmentObserver(evaluate: assessment)
    
    let page = PlaygroundPage.current
    
    // Mark the page as needing indefinite execution to wait for assessment.
    page.needsIndefiniteExecution = true
    
    let proxy = page.liveView as? PlaygroundRemoteLiveViewProxy
    proxy?.delegate = assessmentObserver
    
    #if DEBUG
    mockProxy.delegate = assessmentObserver
    #endif
}

// MARK: Assessment Update

/// A helper function to be used when writing assessment code to produce the correct `AssessmentResults`.
public func updateAssessment(successMessage: String, failureHints: [String], solution: String?) -> AssessmentResults {
    if let passed = assessmentObserver?.passedCriteria where passed {
        return .pass(message: successMessage)
    }
    else {
        return .fail(hints: failureHints, solution: solution)
    }
}

// MARK: AssessmentObserver

class AssessmentObserver: PlaygroundRemoteLiveViewProxyDelegate {
    var observer: NSObjectProtocol!
    
    /// Defers the assessment of the world until `finishedEvaluating` message
    /// has been received.
    var evaluate: () -> AssessmentResults
    
    /// Set to indicate if the current run is a pass or fail.
    /// (Only set within the User process).
    var passedCriteria = false

    init(evaluate: () -> AssessmentResults) {
        self.evaluate = evaluate
        
        /// Observer to look for `WorldPlaybackCompleteNotification` from the LiveViewProcess.
        let updateNotification = Notification.Name(rawValue: WorldPlaybackCompleteNotification)
        self.observer = NotificationCenter.default().addObserver(forName: updateNotification, object: nil, queue: .main()) { [weak self] _ in
            
            // If an AlwaysOn connection is open, send assessment status to the other process.
            if PlaygroundPage.current.isLiveViewConnectionOpen {
                self?.sendAssessmentMessage()
            }
            else {
                // Else set the status directly.
                self?.setAssessmentStatus()
            }
        }
    }
    
    deinit {
        NotificationCenter.default().removeObserver(self.observer)
    }
    
    func sendAssessmentMessage() {
        // Double Check that the connection is open.
        guard PlaygroundPage.current.isLiveViewConnectionOpen else {
            log(message: "Attempting to send assessment message, but the connection is closed.")
            return
        }
        
        let liveView = PlaygroundPage.current.liveView
        guard let liveViewMessageHandler = liveView as? PlaygroundLiveViewMessageHandler else { return }
        
        // Indicate from the LiveViewProcess that the world is finished and ready for the 
        // hints to be displayed.
        let message: PlaygroundValue = .dictionary([LiveViewMessageKey.finishedEvaluating: .boolean(false)])
        liveViewMessageHandler.send(message)
    }
    
    // MARK: PlaygroundRemoteLiveViewProxyDelegate
    
    /*
     PlaygroundRemoteLiveViewProxyDelegate lives in the user processor. 
     
     The methods below are only called in the user process.
    */
    
    func remoteLiveViewProxyConnectionClosed(_ remoteLiveViewProxy: PlaygroundRemoteLiveViewProxy) {
        // Kill user process if LiveView process closed.
        PlaygroundPage.current.finishExecution()
    }
    
    func remoteLiveViewProxy(_ remoteLiveViewProxy: PlaygroundRemoteLiveViewProxy, received message: PlaygroundValue) {
        guard case let .dictionary(dict) = message else { return }
        
        if case .boolean(_)? = dict[LiveViewMessageKey.finishedEvaluating] {
            setAssessmentStatus()
            
            // Finish the user process execution.
            PlaygroundPage.current.finishExecution()
        }
    }
    
    func setAssessmentStatus() {
        PlaygroundPage.current.assessmentStatus = evaluate()
    }
}
