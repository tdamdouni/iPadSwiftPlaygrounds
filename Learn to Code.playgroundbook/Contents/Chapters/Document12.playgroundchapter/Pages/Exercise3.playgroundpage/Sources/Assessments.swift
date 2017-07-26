// 
//  Assessments.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
let success = "### Nice work! \nYou can now place your character or expert anywhere you want in the puzzle world after you [initialize](glossary://initialization) them. You called the `place` [method](glossary://method) on `world`, which is an [instance](glossary://instance) of the puzzle world itself ([type](glossary://type) GridWorld). Next, you'll practice placing your expert into the puzzle world to solve a puzzle. \n\n[Next Page](@next)"
let hints = [
    "Use the example as a guide to pass your [arguments](glossary://argument) into the `place` [method](glossary://method).",
    "First, pass `expert` into the `item` [parameter](glossary://parameter). Then pass *north*, *south*, *east*, or *west* into the `facing` parameter. Finally, pass in two [Int](glossary://Int) values for `atColumn` and `row` to indicate the coordinates you want your expert to start at.",
    "Place your expert in a location that will allow you to gather all of the gems in the puzzle."
]


let solution = "```swift\nlet expert = Expert()\nworld.place(expert, facing: south, atColumn: 2, row: 6)\n\nfunc turnAround() {\n    expert.turnLeft()\n    expert.turnLeft()\n}\n\nfunc turnLockCollectGem() {\n    expert.turnLeft()\n    expert.turnLockUp()\n    turnAround()\n    expert.moveForward()\n    expert.collectGem()\n    turnAround()\n    expert.moveForward()\n    expert.turnRight()\n}\n\nturnLockCollectGem()\nexpert.move(distance: 4)\nturnLockCollectGem()\nexpert.move(distance: 4)\nexpert.turnRight()\nexpert.moveForward()\nexpert.collectGem()\n```"


public func assessmentPoint() -> AssessmentResults {
    return updateAssessment(successMessage: success, failureHints: hints, solution: solution)
}
