// 
//  Assessments.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
let success = "### Your coding skills are growing! \nAs you develop your skills, you’ll get better and better at figuring out the appropriate tools to solve a problem. The more you work at it, the better you'll become! \n\n[Next Page](@next)"

let solution: String? = "```swift\nfor i in 1…4 {\n    moveForward()\n    moveForward()\n    moveForward()\n    if isOnClosedSwitch {\n        toggleSwitch()\n    }\n    turnRight()\n}"

public func assessmentPoint() -> AssessmentResults {
    pageIdentifier = "Four_By_Four"

    var hints = [
        "You could use either a `for` loop or a `while` loop to solve this puzzle."
    ]
    
//    switch currentPageRunCount {
//    case 4..<6:
//        hints[0] = "When you work hard to figure something out, you remember it far better than if you'd found the answer more easily. Keep trying now, or come back later to solve this challenge."
//    case 5..<15:
//        solution = "Here's one way to solve the puzzle:\n\n```swift\nfor i in 1…4 {\n    moveForward()\n    moveForward()\n    moveForward()\n    toggleSwitch()\n    turnRight()\n}"
//    default:
//        break
//    }
    
    return updateAssessment(successMessage: success, failureHints: hints, solution: solution)
}
