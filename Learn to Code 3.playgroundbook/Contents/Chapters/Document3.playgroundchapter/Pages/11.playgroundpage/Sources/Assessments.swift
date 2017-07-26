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
   
    var textPrinted: [String] = []
    var spokenLines: [String] = []

    /// Custom per-page evaluation to determine pass/fail assessment.
    /// Return `true` to mark the page as successful.
    func evaluate(assessmentInfo: AssessmentInfo) -> Bool? {

        guard let originalLines: [String] = assessmentInfo["lines"] as? [String], let originalEmojis = assessmentInfo["emojis"] as? [String] else { return nil }

        // The page has a check for this as well, but a safety to ensure they match.
        if originalLines.count != originalEmojis.count {
            return nil
        }
        
        for event in assessmentInfo.events {
            if case .print(let graphic) = event {
                textPrinted.append(graphic.text)
            }
            if case .speak(let text) = event {
                spokenLines.append(text)
            }
        }

        var match = 0
 
        // Only assessing if they stepped through two lines.
        if textPrinted.count >= (originalLines.count * 2) && spokenLines.count >= originalLines.count {
            
            for i in 0..<originalLines.count {
                let userLine = textPrinted[i*2]
                let userEmoji = textPrinted[1+(i*2)]
                let userSpokenLine = spokenLines[i]
                
                // Confirm the printing and spoken words match for each line
                if userLine != originalLines[i]
                    || userEmoji != originalEmojis[i] ||
                    userSpokenLine != originalLines[i] {
                    return false
                }
            }
            
            return true
        }
 
        return nil
    }
}
