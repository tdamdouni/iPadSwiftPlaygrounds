// 
//  Assessments.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
let hints = [
    "Collect all the gems in the puzzle world, keeping track of how many are collected. For every gem collected, increment `gemCounter` by one.",
    "One way to increment a variable is to use code like this: `myAge = myAge + 1`.",
     "Check each tile to see if a gem is present. If so, collect it and increment `gemCounter` by 1, using `gemCounter = gemCounter + 1`.",
     "Remember, you can use a `while` loop to continue to move forward until blocked. Consider writing a loop to move to and check for a gem on all tiles of the puzzle world."
]

let solution = "```swift\nvar gemCounter = 0\nwhile !isBlocked {\n   while !isBlocked {\n   if isOnGem {\n      collectGem()\n      gemCounter = gemCounter + 1\n   }\n   moveForward()\n   }\n   turnRight()\n}"


public func assessmentPoint() -> AssessmentResults {
    
    let success: String
    if finalGemCount == randomGemCount {
        success = "### You’re becoming a variable master! \nWhen you combine conditional code, loops, and variables, you create the foundation for some incredibly complex apps. Up next, you’ll use a variable to collect an exact number of gems. \n\n[**Next Page**](@next)"
    }
    else {
        success = "Nice work collecting those gems, but it seems like you didn't increment your `gemCounter` variable properly. You collected `\(randomGemCount)` gems, but your `gemCounter` variable has a value of `\(finalGemCount)`. \n\nMake sure that each time you call `collectGem()`, that you add `1` to the value stored by `gemCounter`."
    }
    
    return updateAssessment(successMessage: success, failureHints: hints, solution: solution)
}
