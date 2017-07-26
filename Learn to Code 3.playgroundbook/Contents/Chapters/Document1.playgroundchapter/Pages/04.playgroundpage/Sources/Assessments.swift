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
        var numberOfGraphics = 0
        var positionsX = Set<Double>()
        var positionsY = Set<Double>()
        
        for event in assessmentInfo.events {
            if case .placeAt(let graphic, let position) = event {
                numberOfGraphics += 1
                positionsX.insert(position.x)
                positionsY.insert(position.y)            
            }
        }
        
        return numberOfGraphics == 6 && positionsX.count == 6 && positionsY.count == 6
    }
}

