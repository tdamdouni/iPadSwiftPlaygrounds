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
   
    var hasFaded = false

    /// Custom per-page evaluation to determine pass/fail assessment.
    /// Return `true` to mark the page as successful.
    func evaluate(assessmentInfo: AssessmentInfo) -> Bool? {
        
        for event in assessmentInfo.events {
            if case .setAlpha(let graphic, let alpha) = event {
                
                if alpha <= 0.5 {
                    hasFaded = true
                }
                if hasFaded && alpha == 1.0 {
                    return true
                }
            }
        }
        
        return nil
    }
}
