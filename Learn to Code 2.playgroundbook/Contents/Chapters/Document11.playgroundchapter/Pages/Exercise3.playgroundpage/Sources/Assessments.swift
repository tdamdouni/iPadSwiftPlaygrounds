// 
//  Assessments.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
let success = "### Nice work! \nYou can now place your character or expert anywhere you want in the puzzle world after you [initialize](glossary://initialization) them. You called the `place` [method](glossary://method) on `world`, which is an [instance](glossary://instance) of the puzzle world itself ([type](glossary://type) GridWorld). Next, you'll practice placing your expert into the puzzle world to solve a puzzle. \n\n[**Next Page**](@next)"
let hints = [
    "You can tap on a tile to see its coordinate value. Find the location you'd like your expert to start at, then tap the tile to figure out which column and row value to pass into your `place` method.",
    "Use the example as a guide to pass your [arguments](glossary://argument) into the `place` [method](glossary://method).",
    "First, pass `expert` into the `item` [parameter](glossary://parameter). Then pass in two [Int](glossary://Int) values for `atColumn` and `row` to indicate the coordinate you want your expert to start at.",
    "Place your expert in a location that will allow you to collect all of the gems in the puzzle."
]


let solution = "```swift\nlet expert = Expert()\nworld.place(expert, facing: south, atColumn: 2, row: 6)\n\nfunc turnAround() {\n   expert.turnLeft()\n   expert.turnLeft()\n}\n\nfunc turnLockCollectGem() {\n   expert.turnLeft()\n   expert.turnLockUp()\n   turnAround()\n   expert.moveForward()\n   expert.collectGem()\n   turnAround()\n   expert.moveForward()\n   expert.turnRight()\n}\n\nturnLockCollectGem()\nexpert.move(distance: 5)\nturnLockCollectGem()\nexpert.move(distance: 6)\nexpert.collectGem()"


public func assessmentPoint() -> AssessmentResults {
    return updateAssessment(successMessage: success, failureHints: hints, solution: solution)
}
