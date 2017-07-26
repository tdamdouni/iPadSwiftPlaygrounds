// 
//  Assessments.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
let success = "### Way to go! \nIsn't it handy using [variables](glossary://variable) with [comparison operators](glossary://comparison%20operator) to create a [Boolean](glossary://Boolean) condition? You can store information in a variable, and use that information to make decisions about how your code will run. Now try using this skill in some more puzzles! \n\n[Next Page](@next)"
let hints = [
                "You need to run your code while the value of `gemCounter` is less than 7. You’ll need to use the `<` [comparison operator](glossary://comparison%20operator) to write the condition in your `while` loop.",
                "If Byte is on a gem, collect it, then increment `gemCounter`. If blocked, turn Byte around and go in the opposite direction.",
                
]


let solution = "```swift\nvar gemCounter = 0\n\nwhile gemCounter < 7 {\n    if isOnGem {\n        collectGem()\n        gemCounter = gemCounter + 1\n    }\n    if isBlocked {\n        turnRight()\n        turnRight()\n    }\n    moveForward()\n}"


public func assessmentPoint() -> AssessmentResults {
    return updateAssessment(successMessage: success, failureHints: hints, solution: solution)
}


