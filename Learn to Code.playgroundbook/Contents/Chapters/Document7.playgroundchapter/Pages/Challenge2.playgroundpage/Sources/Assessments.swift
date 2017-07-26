// 
//  Assessments.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
let success = "### Right on! \nDeveloping your own solutions for new problems enables you to figure out what types of tools work in certain situations. As your skills grow, you’ll be able to choose those tools more quickly and intelligently. How awesome is that? \n\n[Next Page](@next)"

let solution = "```swift\nmoveForward()\nwhile isOnGem {\n    turnLeft()\n    collectGem()\n    moveForward()\n    collectGem()\n    turnLeft()\n    moveForward()\n    turnRight()\n    moveForward()\n}"

public func assessmentPoint() -> AssessmentResults {
    pageIdentifier = "Turned_Around"

    var hints = [
        "Think of all the tools you've learned about so far: functions, `for` loops, `while` loops, conditional code, and operators. How can you use these existing tools to solve this puzzle?",
        ]
    
//    switch currentPageRunCount {
//        
//    case 4..<6:
//        hints[0] = "When you work hard to figure something out, you remember it far better than if you'd found the answer more easily. Keep trying now, or come back later to solve this challenge."
//    case 5..<15:
//        solution = "Here's one way to solve the puzzle:\n\n```swift\nmoveForward()\nwhile isOnGem {\n    turnLeft()\n    collectGem()\n    moveForward()\n    collectGem()\n    turnLeft()\n    moveForward()\n    turnRight()\n    moveForward()\n}"
//    default:
//        break
//        
//    }
    
    
    return updateAssessment(successMessage: success, failureHints: hints, solution: solution)
}



