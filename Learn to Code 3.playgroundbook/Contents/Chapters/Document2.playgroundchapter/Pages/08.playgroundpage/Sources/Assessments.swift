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
        guard let placePoints: [Point] = assessmentInfo["points"] as? [Point] else { return nil }
        
        var index = 0
        for event in assessmentInfo.events {
            if case .moveTo(let graphic, let position) = event {
                if placePoints.count > index {
                    let point = placePoints[index]
                    if point.x != position.x && point.y != position.y {
                        return false
                    } else if index > 2 {
                        return true
                    }
                    index += 1
                }
            }
        }
        
        return false        
    }
    
}

