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
        
        guard let correctWords = assessmentInfo["correctWords"] as? [String] else {
            return nil
        }

        var wordIndex = 0
        for event in assessmentInfo.events {
            if case .print(let graphic) = event {
                
                if wordIndex < correctWords.count {
                    let correctWord = correctWords[wordIndex]
                    
                    // Simple check to see if their length matches for each word, as the user may have reversed or shuffled the string.
                    if correctWord.numberOfCharacters != graphic.text.numberOfCharacters {
                        return false
                    }
                } else {
                    break
                }
                
                wordIndex += 1
            }
        }
        
        if wordIndex >= correctWords.count {
            return true
        }
        return false
    }
}
