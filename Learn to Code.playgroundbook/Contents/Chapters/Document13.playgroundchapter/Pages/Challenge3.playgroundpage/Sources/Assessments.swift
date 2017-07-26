// 
//  Assessments.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
let success = "### Masterful! \nYou’re now ready to start modifying every part of the puzzle world. Are you ready? \n\n[Next Page](@next)"
let hints = [
    "First, you’ll need to build out part of the puzzle world so that you can reach the locations where the gems are generated.",
    "Create and place an [instance](glossary://instance) of your character so that you can move around the level and collect gems.",
    "Remember, there are many ways to solve this puzzle, but you should first think through a solution that might work, and then code and test that solution."
]

let solution: String? = "```swift\nlet totalGems = randomNumberOfGems\nvar gemCounter = 0\n\nworld.place(Block(), atColumn: 0, row: 2)\nworld.place(Block(), atColumn: 3, row: 3)\n\nlet expert = Expert()\nworld.place(expert, facing: east, atColumn: 2, row: 3)\n\nwhile gemCounter < totalGems {\n    if expert.isOnGem {\n        expert.collectGem()\n        gemCounter = gemCounter + 1\n    }\n    if expert.isBlocked {\n        expert.turnRight()\n        if expert.isBlocked {\n            expert.turnRight()\n            if expert.isBlocked {\n                expert.turnRight()\n            }\n        }\n    }\n    expert.moveForward()\n}"


public func assessmentPoint() -> AssessmentResults {
    return updateAssessment(successMessage: success, failureHints: hints, solution: solution)
}
