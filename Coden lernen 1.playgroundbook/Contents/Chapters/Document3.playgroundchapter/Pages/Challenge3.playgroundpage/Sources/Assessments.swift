// 
//  Assessments.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//

import Foundation

let success = NSLocalizedString("### Great job! \nYou’ve worked hard to get to this point. Breaking the problem into smaller parts that are easy to solve, and then putting those smaller solutions together into a bigger solution, is a great problem-solving approach. \n\n[**Next Page**](@next)", comment:"Success message")

let solution: String? = nil

import PlaygroundSupport
public func assessmentPoint() -> AssessmentResults {
    let checker = ContentsChecker(contents: PlaygroundPage.current.text)

    
    let hints = [
        NSLocalizedString("For each major stairway you climb in this level, you can write a function that makes your character move to the top, toggle the switch, then move back down.", comment:"Hint"),
        NSLocalizedString("You can use a `for` loop to repeat a set of actions that clears each stairway.", comment:"Hint"),
        NSLocalizedString("Try solving for the first stairway, and then use a loop to repeat the same set of actions for the other two stairways.", comment:"Hint"),
        NSLocalizedString("This puzzle is a **challenge** and has no provided solution. Strengthen your coding skills by creating your own approach to solving it.", comment:"Hint")
        
        ]
    
    
    
    return updateAssessment(successMessage: success, failureHints: hints, solution: solution)
}
