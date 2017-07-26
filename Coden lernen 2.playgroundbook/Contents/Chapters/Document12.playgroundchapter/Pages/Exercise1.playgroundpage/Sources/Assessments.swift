// 
//  Assessments.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//

import Foundation

let success = NSLocalizedString("### Incredible! \nYou now have the power to add blocks to the world. How awesome is that? As you move on, you’ll continue to learn new ways to manipulate the puzzle world with code. \n\n[**Next Page**](@next)", comment:"Success message")
let hints = [
    NSLocalizedString("Before you can place a block, you need to create an [instance](glossary://instance) of the `Block` [type](glossary://type). Use the following code: `let newBlock = Block()`.", comment:"Hint"),
    NSLocalizedString("Place a block by calling the `place` method on the `world` instance, and passing in all required [arguments](glossary://argument).", comment:"Hint"),
    NSLocalizedString("Two possible coordinates for the block are `(2,2)` and `(3,3)`.", comment:"Hint")
]

let solution = "```swift\nlet block1 = Block()\nworld.place(block1, atColumn: 3, row: 3)\n\nwhile !isOnClosedSwitch {\n   moveForward()\n   if isBlocked {\n      turnLeft()\n      if isBlocked {\n         turnRight()\n         turnRight()\n      }\n   }\n}\ntoggleSwitch()\n```"


public func assessmentPoint() -> AssessmentResults {
    return updateAssessment(successMessage: success, failureHints: hints, solution: solution)
}
