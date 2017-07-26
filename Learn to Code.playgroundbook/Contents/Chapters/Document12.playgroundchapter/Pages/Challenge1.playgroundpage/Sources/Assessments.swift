// 
//  Assessments.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
let success = "### Well done! \nYou now know how to access the puzzle world itself through the `world` [instance](glossary://instance). This skill will become extremely valuable, enabling you to modify elements of the puzzle world. \n\n[Next Page](@next)"
let hints = [
    "Before you can solve this puzzle, you’ll need to place your expert into the puzzle world. [Initialize](glossary://initialization) an instance of type `Expert`, and then tell the puzzle world where you want to place that instance.",
    "Here's an example of how to use the `place` [method](glossary://method): `world.place(expert, facing: north, atColumn: 3, row: 4)",
    "Remember, the puzzle world is on a grid, with the (0,0) coordinates at the bottom left."
]

let solution = "```swift\nlet expert = Expert()\nworld.place(expert, facing: south, atColumn: 1, row: 8)\n\nfunc collectGemLine() {\n    while !expert.isBlocked {\n        if expert.isOnGem {\n            expert.collectGem()\n        }\n        expert.moveForward()\n    }\n}\n\ncollectGemLine()\nexpert.turnLockDown()\nexpert.turnLeft()\ncollectGemLine()\nexpert.collectGem()\nexpert.turnLockUp()\nexpert.turnLeft()\nexpert.turnLeft()\nexpert.move(distance: 2)\nexpert.turnLeft()\ncollectGemLine()\nexpert.collectGem()\n```"

public func assessmentPoint() -> AssessmentResults {
    return updateAssessment(successMessage: success, failureHints: hints, solution: solution)
}
