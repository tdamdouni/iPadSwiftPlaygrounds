// 
//  Assessments.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//

import Foundation

let success = NSLocalizedString("### Well done! \nYou're figuring this out quickly-keep it up! \n\n[**Next Page**](@next)", comment:"Success message")
var hints = [
    NSLocalizedString("[Initialize](glossary://initialization) your expert, but don't change the [constant](glossary://constant) name, `expert`.", comment:"Hint"),
    NSLocalizedString("Use [dot notation](glossary://dot%20notation) to code a solution for the rest of the puzzle.", comment:"Hint"),
    NSLocalizedString("This puzzle is a **challenge** and has no provided solution. Strengthen your coding skills by creating your own approach to solving it.", comment:"Hint")


]


let solution: String? = nil

public func assessmentPoint() -> AssessmentResults {
    return updateAssessment(successMessage: success, failureHints: hints, solution: solution)
}
