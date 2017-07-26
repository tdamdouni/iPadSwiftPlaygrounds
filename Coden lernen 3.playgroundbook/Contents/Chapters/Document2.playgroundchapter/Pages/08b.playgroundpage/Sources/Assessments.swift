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
        var firstText: String?

        for event in assessmentInfo.events {
            if case .placeAt(let graphic, _) = event {
                let phrase = graphic.text
                if firstText == nil {
                    firstText = phrase
                } else if graphic.text != firstText {
                    //Passed this flag
                    return true
                }
            }
        }

        return false
    }
}
