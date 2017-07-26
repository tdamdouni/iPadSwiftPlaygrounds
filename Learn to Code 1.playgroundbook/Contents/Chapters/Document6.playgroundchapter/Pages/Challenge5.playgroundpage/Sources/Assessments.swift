// 
//  Assessments.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
let success = "### Outstanding solution! \nTake a second to celebrate—you’ve just completed `while` loops! Your concentration and effort are paying off. Now it's time to learn about algorithms. \n\n[**Introduction to Algorithms**](Algorithms/Introduction)"

let solution: String? = nil

public func assessmentPoint() -> AssessmentResults {
    pageIdentifier = "Youre_Always_Right"
    
    var hints = [
        "Find your way to the gem while toggling all of the closed switches. Figure out which of the skills you've learned will work best to accomplish this goal.",
        "[`while` loops](glossary://while%20loop) are quite useful in this scenario.",
        "This puzzle is a **challenge** and has no provided solution. Strengthen your coding skills by creating your own approach to solving it."
        
        ]
    
    switch currentPageRunCount {
    
    case 0..<5:
        break
    case 5...7:
        hints[0] = "You're doing great! Some of the best programmers in the world try and fail often. Every time you correct a mistake, your brain gets a little better at what you're doing, even if it doesn't feel that way!"
    default:
        break
        
    }
    
    
    return updateAssessment(successMessage: success, failureHints: hints, solution: solution)
}





