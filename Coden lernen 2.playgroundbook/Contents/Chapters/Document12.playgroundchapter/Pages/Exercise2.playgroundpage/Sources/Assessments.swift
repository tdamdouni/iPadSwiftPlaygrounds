// 
//  Assessments.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//

import Foundation

let success = NSLocalizedString("### You're becoming a world-building master! \nNow that you know how to place portals, you’re one step closer to building an entire puzzle world with code. Next up, you’ll place some stairs. \n\n[**Next Page**](@next)", comment:"Success message")
let hints = [
    NSLocalizedString("Pass in the `greenPortal` [instance](glossary://instance) into the `place` method to create a portal between the two islands.", comment:"Hint"),
    NSLocalizedString("Remember, you can always deactivate a portal using [dot notation](glossary://dot%20notation) if it helps you solve the puzzle.", comment:"Hint"),
]

let solution = "```swift\nlet greenPortal = Portal(color: .green)\nworld.place(greenPortal, atStartColumn: 1, startRow: 5, atEndColumn: 5, endRow: 1)\n\nvar gemCounter = 0\nwhile gemCounter < 8 {\n   moveForward()\n   if gemCounter == 4 {\n      turnLeft()\n      turnLeft()\n   } else {\n      turnLeft()\n   }\n   moveForward()\n   collectGem()\n   gemCounter = gemCounter + 1\n   turnLeft()\n   turnLeft()\n}\n```"


public func assessmentPoint() -> AssessmentResults {
    return updateAssessment(successMessage: success, failureHints: hints, solution: solution)
}
