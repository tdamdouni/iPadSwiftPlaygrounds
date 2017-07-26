// 
//  Assessments.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
let success = "### You're becoming a world-building master! \nNow that you know how to place portals, you’re one step closer to building an entire world with code. Next up, you’ll place some stairs. \n\n[Next Page](@next)"
let hints = [
    "Create an [instance](glossary://instance) of [type](glossary://type) `Portal`, and then call the `place` method to create a portal between the two islands.",
    "Remember, you can always deactivate a portal using [dot notation](glossary://dot%20notation) if it helps you solve the puzzle.",
]

let solution = "```swift\nlet greenPortal = Portal(color: .green)\nworld.place(greenPortal, atStartColumn: 1, startRow: 5, atEndColumn: 5, endRow: 1)\n\nvar gemCounter = 0\nwhile gemCounter < 8 {\n    moveForward()\n    if gemCounter == 4 {\n        turnLeft()\n        turnLeft()\n    } else {\n        turnLeft()\n    }\n    moveForward()\n    collectGem()\n    gemCounter = gemCounter + 1\n    turnLeft()\n    turnLeft()\n}\n```"


public func assessmentPoint() -> AssessmentResults {
    return updateAssessment(successMessage: success, failureHints: hints, solution: solution)
}
