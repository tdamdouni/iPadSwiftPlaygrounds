// 
//  Assessments.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
let success = "### Nice work! \nYou're getting the hang of this. \n\n[Next Page](@next)"
let hints = [
    "First add a `for` loop to your code.",
    "There are two possible approaches to solving this puzzle. In one, Byte moves out from the center, then back to the center each time the loop runs. In the other, Byte moves to the outside of the square, then uses loops to walk around each corner.",
]

let solution = "```swift\nfor i in 1 ... 4 {\n    moveForward()\n    moveForward()\n    toggleSwitch()\n    turnRight()\n    turnRight()\n    moveForward()\n    moveForward()\n    turnLeft()\n}\n```"

public func assessmentPoint() -> AssessmentResults {
    return updateAssessment(successMessage: success, failureHints: hints, solution: solution)
}
