// 
//  Assessments.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
let success = "### Very good! \nIt's time to celebrate—you've mastered `for` loops! Think back to the skills you've learned: simple commands, functions, and `for` loops. You'll continue to use all of these skills as you grow as a coder. \n\n[Next Page](@next)"
let hints = [
    "First look at the puzzle. The pattern might be a bit tougher to spot at first. Try solving one part of the puzzle before creating your loop.",
    "You will need to move forward, turn left, move forward twice, then turn right.",
]

let solution = "```swift\nfor i in 1 ... 5 {\n    moveForward()\n    turnLeft()\n    moveForward()\n    moveForward()\n    collectGem()\n    turnRight()\n}\n```"

public func assessmentPoint() -> AssessmentResults {
    return updateAssessment(successMessage: success, failureHints: hints, solution: solution)
}
