// 
//  Assessments.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
let success = "### All that hard work is paying off! \nAs you master each coding skill, you’ll start to recognize where each is most useful for solving specific types of problems.\n\nSometimes, just combining these skills in different ways can result in powerful functionality. \n\n[Next Page](@next)"

let solution = "```swift\nfunc solveColumn() {\n    while !isBlocked {\n        if isOnClosedSwitch {\n            toggleSwitch()\n        } else if isOnGem {\n            collectGem()\n        }\n        moveForward()\n    }\n}\n\nsolveColumn()\nturnRight()\nmoveForward()\nturnRight()\nsolveColumn()\nturnLeft()\nmoveForward()\nturnLeft()\nsolveColumn()"

public func assessmentPoint() -> AssessmentResults {
    pageIdentifier = "Land_of_Bounty"

    var hints = [
        "The length of the platform changes every time you run your code. Use a solution that accounts for this type of change.",
        "You will need to use some form of [conditional code](glossary://conditional%20code).",
        "A great way to approach this problem is to use a `while` loop to move down the length of the platform while Byte is not blocked.",
        "On each tile, use conditional code to check whether Byte is on a closed switch or a gem."
    ]
   
//    switch currentPageRunCount {
//        
//    case 4..<6:
//        hints[0] = "When you work hard to figure something out, you remember it far better than if you'd found the answer more easily. Keep trying now, or come back later to solve this challenge."
//    case 5..<15:
//        solution = "Here's one way to solve the puzzle:\n\n```swift\nfunc solveColumn() {\n    while !isBlocked {\n        if isOnClosedSwitch {\n            toggleSwitch()\n        } else if isOnGem {\n            collectGem()\n        }\n        moveForward()\n    }\n}\n\nsolveColumn()\nturnRight()\nmoveForward()\nturnRight()\nsolveColumn()\nturnLeft()\nmoveForward()\nturnLeft()\nsolveColumn()"
//    default:
//        break
//        
//    }
//    
    
    return updateAssessment(successMessage: success, failureHints: hints, solution: solution)
}



