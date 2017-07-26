// 
//  Assessments.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
let success = "### You're getting quite good at this! \nNow that you’ve experimented with placing blocks, portals, switches, and stairs, you know the fundamentals for building worlds. Next, it's time to give some of those skills a try in solving some advanced world-building puzzles. \n\n[Next Page](@next)"
let hints = [
    "You can use the the following code to create an [instance](glossary://instance) of type `Stair` and place it at the same time: `world.place(Stair(), facing: east, atColumn: 3, row: 3)`.",
    "Place stairs in the puzzle world so that you can guide your character to toggle all the switches open. You can take any of several different approaches."
]

let solution = "```swift\nworld.place(Stair(), facing: south, atColumn: 3, row: 1)\nworld.place(Stair(), facing: south, atColumn: 3, row: 3)\nworld.place(Stair(), facing: west, atColumn: 1, row: 4)\nworld.place(Stair(), facing: west, atColumn: 1, row: 6)\nworld.place(Stair(), facing: east, atColumn: 5, row: 6)\nworld.place(Stair(), facing: north, atColumn: 2, row: 7)\nworld.place(Stair(), facing: north, atColumn: 4, row: 7)\n\nfunc toggleSide() {\n    toggleSwitch()\n    while !isBlocked {\n        moveForward()\n        toggleSwitch()\n    }\n}\n\nfunc turnCorner() {\n    turnRight()\n    move(distance: 2)\n    turnLeft()\n    move(distance: 2)\n    turnRight()\n}\n\nmove(distance: 4)\nturnLeft()\nmove(distance: 3)\nturnRight()\nfor i in 1 ... 2 {\n    toggleSide()\n    turnCorner()\n}\ntoggleSide()"


public func assessmentPoint() -> AssessmentResults {
    return updateAssessment(successMessage: success, failureHints: hints, solution: solution)
}
