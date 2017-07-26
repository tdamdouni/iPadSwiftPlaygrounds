// 
//  Assessments.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
let success = "### All that hard work is paying off! \nAs you master each coding skill, you’ll start to recognize where each is most useful for solving specific types of problems.\n\nSometimes, just combining these skills in different ways can result in powerful functionality. \n\n[**Next Page**](@next)"

let solution: String? = nil

public func assessmentPoint() -> AssessmentResults {
    pageIdentifier = "Land_of_Bounty"

    var hints = [
        "The length of the platform changes every time you run your code. Use a solution that accounts for this type of change.",
        "You'll need to use some form of [conditional code](glossary://conditional%20code).",
        "A great way to approach this problem is to use a [`while` loop](glossary://while%20loop) to move down the length of the platform while your character is not blocked.",
        "On each tile, use [conditional code](glossary://condtional%20code) to check whether your character is on a closed switch or a gem.",
        "This puzzle is a **challenge** and has no provided solution. Strengthen your coding skills by creating your own approach to solving it."
    ]
   
    if currentPageRunCount > 5 {
        hints[0] = "When you work hard to figure something out, you remember it far better than if you'd found the answer more easily. Keep trying now, or come back later to solve this challenge."
    }
    
    return updateAssessment(successMessage: success, failureHints: hints, solution: solution)
}



