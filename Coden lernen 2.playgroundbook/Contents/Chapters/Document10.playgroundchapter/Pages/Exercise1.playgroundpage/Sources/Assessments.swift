// 
//  Assessments.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//

import Foundation

let success = NSLocalizedString("### Nice coding! \nYour skills continue to grow-you can now create an instance using [intitialization](glossary://initialization). This allows you to bring in an expert with additional abilities (methods) such as `turnLockUp()`. \n\n[**Next Page**](@next)", comment:"Success message")
let hints = [
    NSLocalizedString("First, you’ll need to [initialize](glossary://initialization) the expert [instance](glossary://instance) by [assigning](glossary://assignment) `expert` to an instance of type `Expert`.", comment:"Hint"),
    NSLocalizedString("After you initialize the expert, use [dot notation](glossary://dot%20notation) to call methods on the `expert` instance. \nExample: `expert.moveForward()`", comment:"Hint"),
    NSLocalizedString("You'll need to use the `turnLockUp()` [method](glossary://method) to raise the platform that’s blocking one of the gems.", comment:"Hint")
]

let solution = "```swift\nlet expert = Expert()\n\nfunc solveSide() {\n   expert.moveForward()\n   expert.moveForward()\n   expert.moveForward()\n   if expert.isOnGem {\n     expert.collectGem()\n   } else {\n      expert.turnLockUp()\n   }\n}\n\n\nfunc returnToCenter() {\n   expert.turnLeft()\n   expert.turnLeft()\n   expert.moveForward()\n   expert.moveForward()\n   expert.moveForward()\n   expert.turnRight()\n}\n\nfor i in 1 ... 3 {\n   solveSide()\n   returnToCenter()\n}\nsolveSide()\n```"


public func assessmentPoint() -> AssessmentResults {
    return updateAssessment(successMessage: success, failureHints: hints, solution: solution)
}
