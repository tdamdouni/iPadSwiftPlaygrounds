// 
//  Assessments.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//

import Foundation

let success = NSLocalizedString("### Phenomenal! \nThe more you practice new skills like [initialization](glossary://initialization) and [dot notation](glossary://dot%20notation), the more automatic they become. Once a skill becomes automatic, you have more mental energy to spend learning new things! Now it's time for you to gain a new skill-using parameters in your code. \n\n[**Introduction to Parameters**](@next)", comment:"Success message")
var hints = [
    NSLocalizedString("As you did in the previous puzzles, [initialize](glossary://initialization) your character and expert first. Then call [methods](glossary://method) on those [instances](glossary://instance) to solve the puzzle.", comment:"Hint"),
    NSLocalizedString("You'll need your expert to turn the locks so your character can move across the center of the puzzle to collect the gem and toggle the switch.", comment:"Hint"),
    NSLocalizedString("This puzzle is a **challenge** and has no provided solution. Strengthen your coding skills by creating your own approach to solving it.", comment:"Hint")

]

let solution: String? = nil


public func assessmentPoint() -> AssessmentResults {
    return updateAssessment(successMessage: success, failureHints: hints, solution: solution)
}
