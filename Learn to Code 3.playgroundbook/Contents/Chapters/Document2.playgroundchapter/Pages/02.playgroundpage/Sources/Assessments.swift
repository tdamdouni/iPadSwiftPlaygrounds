// 
//  Assessments.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//

import PlaygroundSupport
import Foundation
import CoreGraphics

/**
 A custom implementation of an Evaluator to determine the per-page messages,
 and the conditions which evaluate to a successful run.
 */
class PageAssessment: Evaluator {
    
    /// Custom per-page evaluation to determine pass/fail assessment.
    /// Return `true` to mark the page as successful.
    func evaluate(assessmentInfo: AssessmentInfo) -> Bool? {
        guard assessmentInfo.events.count >= 2 else { return nil }
        
        let checker = ContentsChecker(contents: PlaygroundPage.current.text)
        
        let conditionalStatements = checker.conditionalNodes.map { $0.condition }
        
        for statement in conditionalStatements where statement.contains("<10.0") {
            return false
        }
        
        return true
    }
}
