//
//  AssessmentInfo.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//

import Foundation
import PlaygroundSupport

class AssessmentInfo {
    
    /// Defers the assessment of the world until `finishedEvaluating` message
    /// has been received.
    var evaluate: () -> AssessmentResults
    
    /// Set to indicate if the current run is a pass or fail.
    /// (Only set within the User process).
    var passedCriteria = false
    
    init(evaluate: @escaping () -> AssessmentResults) {
        self.evaluate = evaluate
    }
    
    func setAssessmentStatus() {
        PlaygroundPage.current.assessmentStatus = evaluate()
    }
}

extension SceneController {
    // MARK: Playback Observation
    
    /// Returns `true` if the message was sent.
    func sendReadyForMoreCommands() -> Bool {
        guard Process.isLiveViewConnectionOpen else { return false }

        send(.boolean(true), forKey: .readyForMoreCommands)
        
        return true
    }
    
    func sendAssessmentMessage() {
        // Check that the connection is open.
        guard Process.isLiveViewConnectionOpen else { return }
        
        // Indicate from the LiveViewProcess that the world is finished and ready for the
        // hints to be displayed.
        send(.boolean(isPassingRun), forKey: .finishedEvaluating)
    }
}
