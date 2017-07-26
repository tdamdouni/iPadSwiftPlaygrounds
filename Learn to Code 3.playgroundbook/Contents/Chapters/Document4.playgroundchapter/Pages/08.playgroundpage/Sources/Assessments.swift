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
        if assessmentInfo.context != .button { return nil }

        var spunAndZapped: [Graphic] = []
        for event in assessmentInfo.events {
            if case .moveAndZap(let graphic, _) = event {
                spunAndZapped.append(graphic)
            }
        }
        if spunAndZapped.count > 5 {
            return true 
        }
        
        return nil
    }
}
