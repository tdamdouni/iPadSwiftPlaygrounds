// 
//  Assessments.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
let solution = "```swift\nfor i in 1…6 {\n    moveForward()\n    if isOnClosedSwitch && isBlocked {\n        toggleSwitch()\n        turnLeft()\n        moveForward()\n    } else if isOnClosedSwitch {\n        toggleSwitch()\n        turnRight()\n        moveForward()\n        moveForward()\n        collectGem()\n        turnRight()\n        turnRight()\n        moveForward()\n        moveForward()\n        turnRight()\n    }"

let success = "### Congrats! \nYou just completed **Logical Operators**. Celebrate your hard work by throwing your hands in the air and yelling, \"I did it!\". \n\nNow it's time to learn your next major coding skill: `while` loops. \n\n[Introduction to While Loops](While%20Loops/Introduction)"

import PlaygroundSupport
public func assessmentPoint() -> AssessmentResults {
    pageIdentifier = "Logical_Labyrinth"

    var hints = [
        "First, think through some possible solutions for this challenge. Use conditional code and logical operators to create rules for how Byte moves around the world. Then write your code and test it out! \n\nIf at first you don't succeed, try, try again.",
        "Follow the switches. Sometimes Byte is on a closed switch and blocked in front; sometimes Byte is on a closed switch and not blocked in front.",
        "If on a closed switch and blocked in front, Byte should turn left and move forward."
    ]

//    switch currentPageRunCount {
//        
//    case 3..<5:
//        hints[0] = "### Remember, this is a challenge! \nYou can move on and come back later if you'd like."
//    case 5..<12:
//        solution = "Here's one way to solve the puzzle:\n\n```swift\nfor i in 1…6 {\n    moveForward()\n    if isOnClosedSwitch && isBlocked {\n        toggleSwitch()\n        turnLeft()\n        moveForward()\n    } else if isOnClosedSwitch {\n        toggleSwitch()\n        turnRight()\n        moveForward()\n        moveForward()\n        collectGem()\n        turnRight()\n        turnRight()\n        moveForward()\n        moveForward()\n        turnRight()\n    }"
//    default:
//        break
//        
//    }
//
    
    
    return updateAssessment(successMessage: success, failureHints: hints, solution: solution)
}
