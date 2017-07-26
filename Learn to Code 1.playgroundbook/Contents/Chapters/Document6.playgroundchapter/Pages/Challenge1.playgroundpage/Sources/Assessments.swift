// 
//  Assessments.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
let success = "### Your coding skills are growing! \nAs you develop your skills, you’ll get better and better at figuring out the appropriate tools to solve a problem. The more you work at it, the better you'll become! \n\n[**Next Page**](@next)"

let solution: String? = nil
public func assessmentPoint() -> AssessmentResults {
    pageIdentifier = "Four_By_Four"

    var hints = [
        "You could use either a [`for` loop](glossary://for%20loop) or a [`while` loop](glossary://while%20loop) to solve this puzzle.",
        "This puzzle is a **challenge** and has no provided solution. Strengthen your coding skills by creating your own approach to solving it."

    ]
    
    switch currentPageRunCount {
    case 0..<5:
        break
    case 5...7:
        hints[0] = "When you work hard to figure something out, you remember it far better than if you'd found the answer more easily. Keep trying now, or come back later to solve this challenge."
    default:
        break
    }
    
    return updateAssessment(successMessage: success, failureHints: hints, solution: solution)
}
