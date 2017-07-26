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
    var backgroundNotEmpty = false

    func evaluate(assessmentInfo: AssessmentInfo) -> Bool? {
        
        var backgroundImageCount = 0
        
        for event in assessmentInfo.events {
            if case .setSceneBackgroundImage(let image) = event {
                if image?.isEmpty == false {
                    backgroundImageCount += 1
                    if backgroundImageCount > 1 {
                        return true
                    }
                }
            }
        }
        return false
        
    }
}
