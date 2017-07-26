// 
//  Assessments.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//

import CoreGraphics

/**
 A custom implementation of an Evaluator to determine the per-page messages,
 and the conditions which evaluate to a successful run.
 */
class PageAssessment: Evaluator {
    
    var soundsPlayed = Set<Sound>()
    
    /// Custom per-page evaluation to determine pass/fail assessment.
    /// Return `true` to mark the page as successful.
    func evaluate(assessmentInfo: AssessmentInfo) -> Bool? {
        if assessmentInfo.context != .tool { return nil }
        
        for event in assessmentInfo.events {
            if case .playSound(let sound, _) = event {
                soundsPlayed.insert(sound)
            }
        }
        
        if soundsPlayed.count > 2 {
            return true
        }
        return nil
    }
}
