// 
//  Assessments.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
let success = "### Amazing! \nYou’ve started combining all of your coding skills in new and useful ways. Next, you'll see how to place a different type of item-a portal. \n\n[Next Page](@next)"
let hints = [
    "You'll need to make multiple [instances](glossary://instance) of the `Block` [type](glossary://type), and place them in locations that will enable you to solve the level.",
    "By stacking one block on top of another, you may be able to cross bridges of higher elevations.",
    "Use the same `world.place` [method](glossary://method) as you used in the previous exercise.",
    "The placement code for one block might look something like this: `world.place(block1, atColumn: 2, row: 2)`."
]

let solution = "```swift\nlet block1 = Block()\nlet block2 = Block()\nlet block3 = Block()\nlet block4 = Block()\nlet block5 = Block()\n\nworld.place(block1, atColumn: 2, row: 2)\nworld.place(block2, atColumn: 2, row: 2)\n\nworld.place(block3, atColumn: 4, row: 2)\n\nworld.place(block4, atColumn: 6, row: 2)\nworld.place(block5, atColumn: 6, row: 2)\n\n\nfunc crossBridge() {\n    turnRight()\n    move(distance: 4)\n    collectGem()\n    turnLeft()\n    turnLeft()\n    move(distance: 4)\n    turnRight()\n}\n\n\nfor i in 1..3 {\n    move(distance: 2)\n    toggleSwitch()\n    crossBridge()\n}\n```"

public func assessmentPoint() -> AssessmentResults {
    return updateAssessment(successMessage: success, failureHints: hints, solution: solution)
}
