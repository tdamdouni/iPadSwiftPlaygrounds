// 
//  Assessments.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//

import Foundation

let success = NSLocalizedString("### Outstanding! \nPassing [arguments](glossary://argument) into functions with [parameters](glossary://parameter) will soon become second nature to you. When you learn something new in coding, it can often seem a little intimidating until you've seen and used it in many different places. The more you code, the more familiar you’ll become with the concepts you’ve learned. \n\n[**Next Page**](@next)", comment:"Success message")
let hints = [
    NSLocalizedString("First, [initialize](glossary://initialization) and place both your expert and your character into the puzzle world. \n\n[Need a quick review?](Document11.playgroundchapter/Exercise3.playgroundpage)", comment:"Hint"),
    NSLocalizedString("After you’ve placed your expert and your character, you’ll need both of their special abilities, or [methods](glossary://method), to solve the puzzle. Use `turnLock()` and `jump()`.", comment:"Hint")
]

let solution = "```swift\nlet character = Character()\nlet expert = Expert()\n\nworld.place(character, facing: north, atColumn: 0, row: 0)\nworld.place(expert, facing: north, atColumn: 3, row: 0)\n\nfunc collectAndJump() {\n   for i in 1 ... 2 {\n      character.collectGem()\n      character.jump()\n      character.jump()\n   }\n}\n\nexpert.toggleSwitch()\nexpert.turnLockUp()\n\ncollectAndJump()\ncharacter.turnRight()\ncollectAndJump()\ncharacter.turnLeft()\ncharacter.collectGem()\ncharacter.move(distance: 2)\ncharacter.collectGem()"


public func assessmentPoint() -> AssessmentResults {
    return updateAssessment(successMessage: success, failureHints: hints, solution: solution)
}
