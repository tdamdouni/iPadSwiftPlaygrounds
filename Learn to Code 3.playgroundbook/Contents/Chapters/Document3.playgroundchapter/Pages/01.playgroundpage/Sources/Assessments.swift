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
        var numberOfPrintStatements = 0
        for event in assessmentInfo.events {
            if case .print(let graphic) = event {
                numberOfPrintStatements += 1
            }
        }
        if numberOfPrintStatements > 1 {
            return true 
        }
        
        return false
    }
}
