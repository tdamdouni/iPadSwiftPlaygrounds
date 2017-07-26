// 
//  Assessments.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
let success = "### Outstanding solution! \nTake a second to celebrate—you’ve just completed `while` loops! Your concentration and effort are paying off. Now it's time to learn about algorithms. \n\n[Introduction to Algorithms](Algorithms/Introduction)"

let solution: String? = "```swift\nwhile !isOnGem {\n    while !isBlocked {\n        moveForward()\n        if isOnClosedSwitch {\n            toggleSwitch()\n        }\n    }\n    turnRight()\n}\n\ncollectGem()\n"

public func assessmentPoint() -> AssessmentResults {
    
    let hints = [
        "Find your way to the gem while toggling all of the closed switches. Figure out which of the skills you've learned will work best to accomplish this goal.",
        "`while` loops are quite useful in this scenario.",
        
        ]
    
//    switch currentPageRunCount {
//        
//    case 4..<6:
//        hints[0] = "You're doing great! Some of the smartest people in the world try and fail often. Every time you make a mistake, your brain gets a little better at what you're doing, even if it doesn't feel that way!"
//    case 5..<15:
//        solution = "Here's one way to solve the puzzle:\n\n```swift\nwhile !isOnGem {\n    while !isBlocked {\n        moveForward\n        if isOnClosedSwitch {\n            toggleSwitch()\n        }\n    }\n    turnRight()\n}\n\ncollectGem()\n"
//    default:
//        break
//        
//    }
    
    
    return updateAssessment(successMessage: success, failureHints: hints, solution: solution)
}





