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
        let region = CGRect(x: 150, y: 250, width: 220, height: 220)
        var points: [Point] = []
        
        for event in assessmentInfo.events {
            if case .placeAt(let graphic, let position) = event {
                points.append(position)
            }
        }
        let pointsInRegion = points.filter { region.contains(CGPoint($0)) }.count
        
        if pointsInRegion == 2 {
            return true
        }

        return false
    }
}
