// 
//  Assessments.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//

import Foundation

let success = NSLocalizedString("### Your coding skills are growing! \nAs you develop your skills, you’ll get better and better at figuring out the appropriate tools to solve a problem. The more you work at it, the better you'll become! \n\n[**Next Page**](@next)", comment:"Success message")

let solution: String? = nil
public func assessmentPoint() -> AssessmentResults {
    pageIdentifier = "Four_By_Four"

    var hints = [
        NSLocalizedString("You could use either a [`for` loop](glossary://for%20loop) or a [`while` loop](glossary://while%20loop) to solve this puzzle.", comment:"Hint"),
        NSLocalizedString("This puzzle is a **challenge** and has no provided solution. Strengthen your coding skills by creating your own approach to solving it.", comment:"Hint")

    ]
    
    switch currentPageRunCount {
    case 0..<5:
        break
    case 5...7:
        hints[0] = NSLocalizedString("When you work hard to figure something out, you remember it far better than if you'd found the answer more easily. Keep trying now, or come back later to solve this challenge.", comment:"Hint")
    default:
        break
    }
    
    return updateAssessment(successMessage: success, failureHints: hints, solution: solution)
}
