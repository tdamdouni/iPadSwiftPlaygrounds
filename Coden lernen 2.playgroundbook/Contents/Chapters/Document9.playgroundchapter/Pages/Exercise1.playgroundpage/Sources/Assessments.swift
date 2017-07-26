// 
//  Assessments.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//

import Foundation

let success = NSLocalizedString("### Great work! \nWith [dot notation](glossary://dot%20notation), you can modify the properties of specific [instances](glossary://instance). You first reference the instance name-for example, `greenPortal`-and then place a dot (`.`) followed by the [property](glossary://property) you want to modify. Ready to keep going? \n\n[**Next Page**](@next)", comment:"Success message")
let hints = [
    NSLocalizedString("First, you need to set the `isActive` [property](glossary://property) of `greenPortal` to `false`. Otherwise, every time you try to reach a switch, your character will teleport away.", comment:"Hint"),
    NSLocalizedString("After you disable the portal, solve this problem like you would any other problem.", comment:"Hint")
]


let solution = "```swift\ngreenPortal.isActive = false\n\nfunc moveThree() {\n   moveForward()\n   moveForward()\n   moveForward()\n}\n\nfor i in 1 ... 3 {\n   moveThree()\n   turnRight()\n   moveThree()\n   toggleSwitch()\n   turnLeft()\n   turnLeft()\n}\n```"


public func assessmentPoint() -> AssessmentResults {
    return updateAssessment(successMessage: success, failureHints: hints, solution: solution)
}
