// 
//  Assessments.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
let solution: String? = "```swift\nwhile !isBlocked {\n    moveForward()\n    if isOnGem {\n        turnRight()\n        collectGem()\n        moveForward()\n        collectGem()\n        while !isBlocked {\n            moveForward()\n        }\n        turnLeft()\n    } else {\n        toggleSwitch()\n        turnLeft()\n        moveForward()\n        toggleSwitch()\n        while !isOnClosedSwitch {\n            moveForward()\n        }\n        toggleSwitch()\n        turnRight()\n    }\n}"


import PlaygroundSupport
public func assessmentPoint() -> AssessmentResults {
    pageIdentifier = "Roll_Right,_Roll_Left"
    
    
    let success = "### Outstanding work! \nYou've just completed Algorithms. Time to shout out, \"I'm a coding master!\" and do a celebratory dance. \n\nYou've come a long way from writing simple commands. Now it's time to start the next part of your coding journey—**variables**. \n\n[Introduction to Variables](Variables/Introduction)"
    var hints = [
        "First, look for a pattern in the puzzle. When you find a pattern, think through which rules and instructions will solve each piece of that pattern. When you figure out an approach, write your code.",
        "Notice that whenever gems are present, the path moves to the right. Whenever switches are present, the path moves to the left. Use this pattern to create your algorithm."
    ]
    
    
//    switch currentPageRunCount {
//        
//    case 2..<4:
//        hints[0] = "Whenever a gem is present, Byte should collect the gem and move to the right. Whenever a switch is present, Byte should toggle the switch and move to the left."
//    case 4..<6:
//        hints[0] = "Continue to run the algorithm for as long as Byte is not blocked."
//    case 5..<9:
//        hints[0] = "Even if it doesn't feel like it, you're always making progress. Getting stuck means you're only a few tries away from finding an answer. Keep trying!"
//    case 6..<15:
//        solution = "```swift\nwhile !isBlocked {\n    moveForward()\n    if isOnGem {\n        turnRight()\n        collectGem()\n        moveForward()\n        collectGem()\n        while !isBlocked {\n            moveForward()\n        }\n        turnLeft()\n    } else {\n        toggleSwitch()\n        turnLeft()\n        toggleSwitch()\n        while !isOnClosedSwitch {\n            moveForward()\n        }\n        toggleSwitch()\n        turnRight()\n    }\n}"
//    default:
//        break
//        
//    }
    
    
    
    
    return updateAssessment(successMessage: success, failureHints: hints, solution: solution)
}
