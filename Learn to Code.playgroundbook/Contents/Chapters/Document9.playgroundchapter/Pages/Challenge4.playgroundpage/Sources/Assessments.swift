// 
//  Assessments.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
let success = "### Awesome! \nYou've completed Variables. Give yourself a huge pat on the back. Next up, you’ll discover a new ability-changing elements of the world with the power of code. \n\n[Introduction to Types](Types/Introduction)"
let hints = [
 "`totalGems` represents the total number of gems that will be generated in the puzzle. Use this [constant](glossary://constant), along with a gem-counting [variable](glossary://variable), to determine when to stop Byte from collecting gems.",
 "Write an [algorithm](glossary://algorithm) that continues to move Byte back and forth through the portals as you check for gems."
]


let solution = "```swift\nvar gemCounter = 0\n\nwhile gemCounter < totalGems {\n    if isOnGem {\n        collectGem()\n        gemCounter = gemCounter + 1\n    }\n    if isBlocked  {\n        turnRight()\n        if isBlocked {\n            turnLeft()\n            turnLeft()\n            if isBlocked {\n                turnLeft()\n            }\n        }\n    }\n    moveForward()\n}\n```"


public func assessmentPoint() -> AssessmentResults {
    return updateAssessment(successMessage: success, failureHints: hints, solution: solution)
}
