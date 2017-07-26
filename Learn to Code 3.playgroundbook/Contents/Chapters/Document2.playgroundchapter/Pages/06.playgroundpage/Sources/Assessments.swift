// 
//  Assessments.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//

import PlaygroundSupport
import CoreGraphics

/**
 A custom implementation of an Evaluator to determine the per-page messages,
 and the conditions which evaluate to a successful run.
 */
class PageAssessment: Evaluator {
    
    /// Custom per-page evaluation to determine pass/fail assessment.
    /// Return `true` to mark the page as successful.
    func evaluate(assessmentInfo: AssessmentInfo) -> Bool? {
        
        var firstImage: Image?
        for event in assessmentInfo.events {
            if case .placeAt(let graphic, _) = event, let image = graphic.image {
                if firstImage == nil {
                    firstImage = image
                } else if image != firstImage {
                    // Check for randomInt call
                    let checker = ContentsChecker(contents: PlaygroundPage.current.text)
                    return checker.functionCallCount(forName: "randomInt") > 0
                }
            }
        }
        
        return false
    }
}
