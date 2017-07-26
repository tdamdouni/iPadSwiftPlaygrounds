// 
//  Assessments.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//

import Foundation

let solution: String? = nil

let success = NSLocalizedString("### Congrats! \nYou just completed **Logical Operators**. Celebrate your hard work by throwing your hands in the air and yelling, \"I did it!\". \n\nNow it's time to learn your next major coding skill: `while` loops. \n\n[**Introduction to While Loops**](@next)", comment:"Success message")

import PlaygroundSupport
public func assessmentPoint() -> AssessmentResults {
    pageIdentifier = "Logical_Labyrinth"

    var hints = [
        NSLocalizedString("First, think through some possible solutions for this challenge. Use conditional code and logical operators to create rules for how your character moves around the puzzle world. Then write your code and test it! \n\nIf at first you don't succeed, try, try again.", comment:"Hint"),
        NSLocalizedString("There are three different situations you should plan for in your code:\n        \n- Your character is on a gem AND a closed switch.\n- Your character is on a closed switch only.\n- Your character is on a gem only.", comment:"Hint"),
        NSLocalizedString("Check for each situation your character could be in, and take a different action for each:\n        \n`if isOnGem && isOnClosedSwitch {`\n\n   *do something*\n\n`} else if isOnClosedSwitch {`\n\n   *do something else*\n\n`} else if isOnGem {`\n\n   *do the last thing*\n\n`}`", comment:"Hint"),
        NSLocalizedString("This puzzle is a **challenge** and has no provided solution. Strengthen your coding skills by creating your own approach to solving it.", comment:"Hint")
    ]

    switch currentPageRunCount {
        
    case 0..<5:
        break
    case 5...7:
        hints[0] = NSLocalizedString("Remember, this is a challenge! \n\nYou can move on and come back later if you'd like.", comment:"Hint")
    default:
        break
        
    }

    
    
    return updateAssessment(successMessage: success, failureHints: hints, solution: solution)
}
