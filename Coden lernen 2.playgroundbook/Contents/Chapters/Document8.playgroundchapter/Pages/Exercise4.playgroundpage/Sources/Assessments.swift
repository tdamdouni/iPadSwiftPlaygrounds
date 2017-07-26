// 
//  Assessments.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//

import Foundation

let success = NSLocalizedString("### Fantastic! \nComparing a [variable](glossary://variable) to a [constant](glossary://constant) is done frequently in code. As you continue practicing this skill, it will start to seem as commonplace as writing a command. \n\n[**Next Page**](@next)", comment:"Success message")
let hints = [
    NSLocalizedString("Continue to collect gems until your `gemCounter` value matches your `switchCounter` value.", comment:"Hint"),
    NSLocalizedString("Use a [comparison operator](glossary://comparison%20operator) to write a [Boolean](glossary://Boolean) condition comparing your `gemCounter` value with your `switchCounter` value. \nExample: `while a != b`", comment:"Hint")
]

let solution = "```swift\nlet switchCounter = numberOfSwitches\nvar gemCounter = 0\n\nwhile gemCounter < switchCounter {\n   if isOnGem {\n      collectGem()\n     gemCounter = gemCounter + 1\n   }\n   if isBlocked {\n      turnRight()\n   }\n   moveForward()\n}\n```"



public func assessmentPoint() -> AssessmentResults {
    return updateAssessment(successMessage: success, failureHints: hints, solution: solution)
}
