// 
//  Assessments.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
let success = "### Outstanding! \nPassing [arguments](glossary://argument) into functions with [parameters](glossary://parameter) will soon become second nature to you. When you learn something new in coding, it can often seem a little intimidating until you've seen and used it in many different places. The more you code, the more familiar you’ll become with the concepts you’ve learned. \n\n[Next page](@next)"
let hints = [
    "First, [initialize](glossary://initialization) and place both your expert and your character into the puzzle world. \n\n[Need a quick review?](Parameters/Placing%20at%20a%20Specific%20Location)",
    "After you’ve placed your expert and your character, you’ll need both of their special abilities, or [methods](glossary://method), to solve the puzzle. Use `turnLock()` and `jump()`."
]

let solution = "```swift\nlet character = Character()\nlet expert = Expert()\n\nworld.place(character, facing: north, atColumn: 0, row: 0)\nworld.place(expert, facing: north, atColumn: 3, row: 0)\n\nfunc collectAndJump() {\n    while !character.isBlocked {\n        character.collectGem()\n        character.jump()\n        character.Jump\n    }\n}\n\nexpert.toggleSwitch()\nexpert.turnLock(up: false, numberOfTimes: 3)\n\ncollectAndJump()\ncharacter.turnRight()\ncollectAndJump()\ncharacter.turnLeft()\ncharacter.collectGem()\ncharacter.move(distance: 2)\ncharacter.collectGem()\n```"


public func assessmentPoint() -> AssessmentResults {
    return updateAssessment(successMessage: success, failureHints: hints, solution: solution)
}
