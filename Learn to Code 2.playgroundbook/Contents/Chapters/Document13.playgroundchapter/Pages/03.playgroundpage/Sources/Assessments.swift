// 
//  Assessments.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
let success = "### You're picking this up quickly! \n\nKnowing how to access and modify items using an array [index](glossary://index) is very useful. You can also modify an array using other [methods](glossary://method) provided for you:\n\n    removeFirst()\n    removeLast()\n    removeAll()\n\nTry experimenting with some of these methods to see how they work!\n\n[**Next Page**](@next)"
let hints = [
    "To remove an item from an array, call the `remove(at: Int)` [method](glossary://method) using [dot notation](glossary://dot%20notation): `characters.remove(at: 3)`.",
    "First, remove the portal from the array. It’s the second item, so its [index](glossary://index) is `1`.",
    "After you remove the portal from the array, the [index](glossary://index) of the gem will change.",
    "To insert the expert into the array, call `insert(element: Element, at: Int)` on the `characters` array: `insert(Expert(), at: 3)`."
]

let solution: String? = "```swift\ncharacters = [\n   Character(name: .blu),\n   Portal(color: .pink),\n   Character(name: .byte),\n   Gem(),\n   Character(name: .hopper)\n]\n\ncharacters.remove(at: 1)\ncharacters.remove(at:2)\ncharacters.insert(Expert(), at: 1)\n\nvar rowPlacement = 0\nfor character in characters {\n      world.place(character, at: Coordinate(column: 1, row: rowPlacement))\n   rowPlacement += 1\n}"


public func assessmentPoint() -> AssessmentResults {
    return updateAssessment(successMessage: success, failureHints: hints, solution: solution)
}
