// 
//  Assessments.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
let success = "### Incredible work! \nYou found all the bugs in the code! \n\n[**Next Page**](@next)"

let solution: String? = nil

import PlaygroundSupport
public func assessmentPoint() -> AssessmentResults {
    let checker = ContentsChecker(contents: PlaygroundPage.current.text)
    
    var hints = [
        "Sometimes a bug is just one out-of-place command. Think about which commands, in which order, will get you to the switch and the gem. Can you move one or more commands to make that happen?",
        "Imagine moving step by step through the puzzle world. Compare those moves to the existing commands to see what's gone wrong.",
        "This puzzle is a **challenge** and has no provided solution. Strengthen your coding skills by creating your own approach to solving it."

    ]
    
    let defaultContents = [
        "moveForward",
        "moveForward",
        "moveForward",
        "turnLeft",
        "toggleSwitch",
        "moveForward",
        "moveForward",
        "moveForward",
        "collectGem",
        "moveForward"
    ]
    
    if checker.calledFunctions == defaultContents {
        hints[0] = "Byte toggled an **open** switch **closed**. This is a bug! Figure out how to rearrange the existing commands to toggle all switches open and collect the gem."
    } else if checker.numberOfStatements > 10 {
        hints[0] = "Adding more commands might not help here. Try rearranging your existing code by tapping on a command to select it, then dragging it to a new location."
        
    } else if checker.numberOfStatements > 12 {
        hints[0] = "If you'd like to start over, tap the three dots at the top right, then select \"Reset Page...\""
    }
    
    

    return updateAssessment(successMessage: success, failureHints: hints, solution: solution)
}






