// 
//  Assessments.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
let success = "### You’re becoming a variable master! \nWhen you combine conditional code, loops, and variables, you create the foundation for some incredibly complex applications. Up next, you’ll use a variable to collect an exact number of gems. \n\n[Next Page](@next)"
let hints = [
                "Byte should collect all the gems in the world, and you need to keep track of how many Byte collects. For every gem Byte collects, increment `gemCounter` by one.",
                "One way to increment a variable is to use code like this: `myAge = myAge + 1`.",
                "Check each tile to see if a gem is present. If so, collect it and increment `gemCounter` by 1, using `gemCounter = gemCounter + 1`."
    
    
]

let solution = "```swift\nvar gemCounter = 0\n\nwhile !isBlocked {\n    while !isBlocked {\n        if isOnGem {\n            collectGem()\n            gemCounter = gemCounter + 1\n        }\n        moveForward()\n    }\n    turnRight()\n}"


public func assessmentPoint() -> AssessmentResults {
    return updateAssessment(successMessage: success, failureHints: hints, solution: solution)
}
