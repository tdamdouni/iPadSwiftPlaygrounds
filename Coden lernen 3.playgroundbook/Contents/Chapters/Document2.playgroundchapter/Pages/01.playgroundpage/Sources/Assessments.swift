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

        guard let userChangedImage = assessmentInfo["isDifferentImage"] as? Bool else { return nil}
        
        if !userChangedImage {
            return false
        }
        
        var placedItems = 0
        
        for event in assessmentInfo.events {
            if case .placeAt(_,_) = event {
                placedItems += 1
                if placedItems > 3 {
                    return true
                }
            }
        }

       return nil
    }
}
