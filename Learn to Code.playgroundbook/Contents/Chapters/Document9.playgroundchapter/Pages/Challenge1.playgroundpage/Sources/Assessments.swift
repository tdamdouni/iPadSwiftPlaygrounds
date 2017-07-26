// 
//  Assessments.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
let success = "### Excellent work! \nBy continuously updating the `gemCounter` value, you can track that value as it changes over time. Next, you'll learn a more efficient way to do this.\n\n[Next Page](@next)"
let hints = [
                "Just like in the previous exercise, you need to update the value of the `gemCounter` variable each time Byte collects a gem.",
                "Collect a gem, and then use the assignment operator to set a new `gemCounter` value. \nExample: `gemCounter = 3`",
                "After Byte collects all the gems, the value of the `gemCounter` variable should be 5."
]


let solution = "```swift\nvar gemCounter = 0\n\nmoveForward()\ncollectGem()\ngemCounter = 1\nmoveForward()\ncollectGem()\ngemCounter = 2\nmoveForward()\ncollectGem()\ngemCounter = 3\nmoveForward()\ncollectGem()\ngemCounter = 4\nmoveForward()\ncollectGem()\ngemCounter = 5\n```"

public func assessmentPoint() -> AssessmentResults {
    return updateAssessment(successMessage: success, failureHints: hints, solution: solution)
}
