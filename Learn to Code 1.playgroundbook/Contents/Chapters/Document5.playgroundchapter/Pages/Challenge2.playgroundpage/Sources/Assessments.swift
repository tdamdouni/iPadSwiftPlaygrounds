// 
//  Assessments.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
let solution: String? = nil

let success = "### Congrats! \nYou just completed **Logical Operators**. Celebrate your hard work by throwing your hands in the air and yelling, \"I did it!\". \n\nNow it's time to learn your next major coding skill: `while` loops. \n\n[**Introduction to While Loops**](While%20Loops/Introduction)"

import PlaygroundSupport
public func assessmentPoint() -> AssessmentResults {
    pageIdentifier = "Logical_Labyrinth"

    var hints = [
        "First, think through some possible solutions for this challenge. Use conditional code and logical operators to create rules for how your character moves around the puzzle world. Then write your code and test it! \n\nIf at first you don't succeed, try, try again.",
        "Follow the switches. Sometimes your character is on a closed switch and blocked in front; sometimes your character is on a closed switch and not blocked in front.",
        "If on a closed switch and blocked in front, turn left and move forward.",
        "This puzzle is a **challenge** and has no provided solution. Strengthen your coding skills by creating your own approach to solving it."
    ]

    switch currentPageRunCount {
        
    case 0..<5:
        break
    case 5...7:
        hints[0] = "Remember, this is a challenge! \n\nYou can move on and come back later if you'd like."
    default:
        break
        
    }

    
    
    return updateAssessment(successMessage: success, failureHints: hints, solution: solution)
}
