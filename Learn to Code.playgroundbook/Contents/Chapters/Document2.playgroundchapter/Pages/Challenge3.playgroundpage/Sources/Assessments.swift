// 
//  Assessments.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
let success = "### You're really getting this! \nBy using [decomposition](glossary://decomposition) to break down a larger problem into smaller, more manageable parts, you're making your code more readable and reusable. \n\n[Next Page](@next)"
let hints = [
    "Use the function `collectGemTurnAround()`, possibly along with other commands, to [define](glossary://define) `solveRow()`.",
    "There are many ways to approach solving this puzzle. Figure out which one you'd like to try, and go for it!",
    "One way to [define](glossary://define) `solveRow()` is to [call](glossary://call) `collectGemTurnAround()` twice."
]

let solution = "```swift\nfunc collectGemTurnAround() {\n    moveForward()\n    moveForward()\n    collectGem()\n    turnLeft()\n    turnLeft()\n    moveForward()\n    moveForward()\n\n}\n\nfunc solveRow() {\n    collectGemTurnAround()\n    collectGemTurnAround()\n}\n\n\nsolveRow()\nturnRight()\nmoveForward()\nturnLeft()\nsolveRow()\nturnRight()\nmoveForward()\nturnLeft()\nsolveRow()\n```"

public func assessmentPoint() -> AssessmentResults {
    return updateAssessment(successMessage: success, failureHints: hints, solution: solution)
}
