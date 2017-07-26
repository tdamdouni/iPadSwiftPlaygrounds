// 
//  Assessments.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//

import CoreGraphics

/**
 A custom implementation of an Evaluator to determine the per-page messages,
 and the conditions which evaluate to a successful run.
 */
class PageAssessment: Evaluator {
    
    /// Custom per-page evaluation to determine pass/fail assessment.
    /// Return `true` to mark the page as successful.
    func evaluate(assessmentInfo: AssessmentInfo) -> Bool? {
        var counter = 0
        for event in assessmentInfo.events {
            // Check how many times orbit was called. 
            if case .orbit = event {
                counter += 1
                if counter == 5 {
                    return true
                }
            }
        }
        return false
    }
}