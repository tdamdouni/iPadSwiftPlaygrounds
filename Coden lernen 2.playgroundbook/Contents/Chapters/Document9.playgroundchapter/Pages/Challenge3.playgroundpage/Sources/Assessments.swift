// 
//  Assessments.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//

import Foundation

let success = NSLocalizedString("### Wow! \nYour coding skills have come a long way. It’s time to learn a new set of skills. Ready to begin? \n\n[**Introduction to Initialization**](@next)", comment:"Success message")
var hints = [
    NSLocalizedString("[Declare](glossary://declaration) a [variable](glossary://variable) to track how many gems your character picks up, and compare it to the `totalGems` [constant](glossary://constant) to determine when to stop.", comment:"Hint"),
    NSLocalizedString("Create an [algorithm](glossary://algorithm) that moves your character across all parts of the puzzle to collect all the gems. You'll need to activate and deactivate the portals.", comment:"Hint"),
    NSLocalizedString("This puzzle is a **challenge** and has no provided solution. Strengthen your coding skills by creating your own approach to solving it.", comment:"Hint")

]

let solution: String? = nil


public func assessmentPoint() -> AssessmentResults {
    return updateAssessment(successMessage: success, failureHints: hints, solution: solution)
}
