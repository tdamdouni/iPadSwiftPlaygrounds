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
        
        let topRightQuad = CGRect(x: -1, y: -1, width: 501, height: 501)
        let topLeftQuad = CGRect(x: -501, y: -1, width: 501, height: 501)
        let bottomRightQuad = CGRect(x: -1, y: -501, width: 501, height: 501)
        let bottomLeftQuad = CGRect(x: -501, y: -501, width: 501, height: 501)
        
        let quads = [topRightQuad, topLeftQuad, bottomRightQuad, bottomLeftQuad]

        var points = [Point]()
        for event in assessmentInfo.events {
            if case .placeAt(_, let point) = event {
                points.append(point)
            }
        }

        let topRightCount = points.filter { topRightQuad.contains(CGPoint($0)) }.count
        let topLeftCount = points.filter { topLeftQuad.contains(CGPoint($0)) }.count
        let bottomRightCount = points.filter { bottomRightQuad.contains(CGPoint($0)) }.count
        let bottomLeftCount = points.filter { bottomLeftQuad.contains(CGPoint($0)) }.count
        return topRightCount == 2 && topLeftCount == 1 && bottomRightCount == 1 && bottomLeftCount == 1
  
    }
}
