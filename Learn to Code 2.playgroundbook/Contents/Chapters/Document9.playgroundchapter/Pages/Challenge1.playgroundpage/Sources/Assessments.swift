// 
//  Assessments.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
let success = "### Way to go! \nSometimes you need to modify the [properties](glossary://property) of an [instance](glossary://instance) multiple times while your code runs. Great work! \n\n[**Next Page**](@next)"
let hints = [
    "First, use [pseudocode](glossary://pseudocode) to map out how you’ll activate and deactivate the portal to solve the puzzle. Then write out that code and test it.",
    "Use [dot notation](glossary://dot%20notation) to deactivate and activate the portal. \nExample: `purplePortal.isActive = false`",
    "This puzzle is a **challenge** and has no provided solution. Strengthen your coding skills by creating your own approach to solving it."

]


let solution: String? = nil

public func assessmentPoint() -> AssessmentResults {
    return updateAssessment(successMessage: success, failureHints: hints, solution: solution)
}
