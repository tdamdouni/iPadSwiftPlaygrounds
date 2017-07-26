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
    
    /// Custom per-page evaluation to determine pass/fail assessment.
    /// Return `true` to mark the page as successful.
    func evaluate(assessmentInfo: AssessmentInfo) -> Bool? {
        var textPlaced = 0
        for event in assessmentInfo.events {
            if case .placeAt(let graphic, let position) = event {
                // Only count placement of graphics with text.
                if graphic.text != "" {
                    textPlaced += 1
                }
            }
        }
        
        if textPlaced > 3 {
            return true
        }
        return false
    }
}
