// 
//  Assessments.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//

import CoreGraphics
import UIKit

/**
 A custom implementation of an Evaluator to determine the per-page messages,
 and the conditions which evaluate to a successful run.
 */
class PageAssessment: Evaluator {
        
    /// Custom per-page evaluation to determine pass/fail assessment.
    /// Return `true` to mark the page as successful.
    func evaluate(assessmentInfo: AssessmentInfo) -> Bool? {

        if let correctArray = assessmentInfo["correctArray"] as? [Image],
            let imagesArray = assessmentInfo["imagesArray"] as? [Image] {
            if imagesArray == correctArray {
                return true
            }
        }

        return false
    }
}
