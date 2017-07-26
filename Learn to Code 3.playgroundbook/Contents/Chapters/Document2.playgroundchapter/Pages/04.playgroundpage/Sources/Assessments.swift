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
        var previousImage: Image?
        
        for event in assessmentInfo.events {
            if case .placeAt(let graphic, _) = event, let image = graphic.image  {
                
                if previousImage != nil && image == previousImage {
                    return false
                }
                
                previousImage = image
                numberOfGraphics += 1
                
                if numberOfGraphics > 6 {
                    return true
                }
            }
        }
        
        return nil
    }
}
