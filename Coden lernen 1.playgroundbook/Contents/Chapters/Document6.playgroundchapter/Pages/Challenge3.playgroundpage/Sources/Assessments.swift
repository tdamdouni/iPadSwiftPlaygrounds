// 
//  Assessments.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//

import Foundation

let success = NSLocalizedString("### All that hard work is paying off! \nAs you master each coding skill, you’ll start to recognize where each is most useful for solving specific types of problems.\n\nSometimes, just combining these skills in different ways can result in powerful functionality. \n\n[**Next Page**](@next)", comment:"Success message")

let solution: String? = nil

public func assessmentPoint() -> AssessmentResults {
    pageIdentifier = "Land_of_Bounty"

    var hints = [
        NSLocalizedString("The length of the platform changes every time you run your code. Use a solution that accounts for this type of change.", comment:"Hint"),
        NSLocalizedString("You'll need to use some form of [conditional code](glossary://conditional%20code).", comment:"Hint"),
        NSLocalizedString("A great way to approach this problem is to use a [`while` loop](glossary://while%20loop) to move down the length of the platform while your character is not blocked.", comment:"Hint"),
        NSLocalizedString("On each tile, use [conditional code](glossary://conditional%20code) to check whether your character is on a closed switch or a gem.", comment:"Hint"),
        NSLocalizedString("This puzzle is a **challenge** and has no provided solution. Strengthen your coding skills by creating your own approach to solving it.", comment:"Hint")
    ]
   
    if currentPageRunCount > 5 {
        hints[0] = NSLocalizedString("When you work hard to figure something out, you remember it far better than if you'd found the answer more easily. Keep trying now, or come back later to solve this challenge.", comment:"Hint")
    }
    
    return updateAssessment(successMessage: success, failureHints: hints, solution: solution)
}



