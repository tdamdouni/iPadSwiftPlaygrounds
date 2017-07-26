// 
//  Assessments.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
let success = "### Great job! \nYou’ve worked hard to get to this point. Breaking the problem into smaller parts that are easy to solve, and then putting those smaller solutions together into a bigger solution, is a great problem-solving approach. \n\n[Next Page](@next)"

let solution = "```swift\nfunc traverseStairway() {\n    for _ in 1 ... 7 {\n        moveForward()\n    }\n}\n\nfunc clearStairway() {\n    traverseStairway()\n    toggleSwitch()\n    turnRight()\n    turnRight()\n    traverseStairway()\n    turnRight()\n}\n\nfor i in 1 ... 3 {\n    moveForward()\n    moveForward()\n    turnRight()\n    clearStairway()\n}"

import PlaygroundSupport
public func assessmentPoint() -> AssessmentResults {
    let checker = ContentsChecker(contents: PlaygroundPage.current.text)
    
    var hints = [
        "For each major stairway you climb in this level, you can write a function that moves Byte to the top, toggle the switch, then move back down.",
        "You can use a `for` loop to repeat a set of actions that clears each stairway.",
        "Try solving the first stairway, and then use a loop to repeat the same set of actions for the other two stairways.",
        
        ]
    
//    switch currentPageRunCount {
//        
//    case 3..<6:
//        hints[0] = "### Remember, this is a challenge! \nYou can skip it and come back later."
//    case 6..<12:
//        hints[0] = "Here's one way to solve the challenge:\n\n```swift\nfunc traverseRidge() {\n    for _ in 1 ... 7 {\n        moveForward()\n    }\n}\n\nfunc clearRidge() {\n    traverseRidge()\n    toggleSwitch()\n    turnRight()\n    turnRight()\n    traverseRidge()\n    turnRight()\n}\n\nfor i in 1 ... 3 {\n    moveForward()\n    moveForward()\n    turnRight()\n    clearRidge()\n}\n```"
//    default:
//        break
//        
//    }
//    
//    
    
    
    
    return updateAssessment(successMessage: success, failureHints: hints, solution: solution)
}
