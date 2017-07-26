// 
//  Assessments.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//

import Foundation

let success = NSLocalizedString("### Keep going! \n\nYou can continue to build your puzzle until you’re satisfied with it. When you’re done, you can even have someone else try to solve it! \n\nCongratulations on completing World Building. You now have the skills to begin constructing more complex landscapes! To do this, you’ll learn how to store multiple pieces of information in a certain order using [arrays](glossary://array). \n\n[Introduction to Arrays](@next)", comment:"Success message")
let hints = [
    NSLocalizedString("Add a gem or a switch to your puzzle a method like this: `world.place(Gem(), atColumn: 3, row: 3)`.", comment:"Hint"),
    NSLocalizedString("See if you can figure out how to add an instance of `PlatformLock` and  `Platform` by experimenting with the code.", comment:"Hint"),
    NSLocalizedString("You can build your world however you’d like. The sky is the limit!", comment:"Hint")
]

let solution: String? = nil


public func assessmentPoint() -> AssessmentResults {
    return updateAssessment(successMessage: success, failureHints: hints, solution: solution)
}
