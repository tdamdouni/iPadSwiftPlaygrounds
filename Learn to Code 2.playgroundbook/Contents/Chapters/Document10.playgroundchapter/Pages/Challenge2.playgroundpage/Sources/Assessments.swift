// 
//  Assessments.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
let success = "### Phenomenal! \nThe more you practice new skills like [initialization](glossary://initialization) and [dot notation](glossary://dot%20notation), the more automatic they become. Once a skill becomes automatic, you have more mental energy to spend learning new things! Now it's time for you to gain a new skill-using parameters in your code. \n\n[**Introduction to Parameters**](Parameters/Introduction)"
var hints = [
    "As you did in the previous puzzles, [initialize](glossary://initialization) your character and expert first. Then call [methods](glossary://method) on those [instances](glossary://instance) to solve the puzzle.",
    "You'll need your expert to turn the locks so your character can move across the center of the puzzle to collect the gem and toggle the switch.",
    "This puzzle is a **challenge** and has no provided solution. Strengthen your coding skills by creating your own approach to solving it."

]

let solution: String? = nil


public func assessmentPoint() -> AssessmentResults {
    return updateAssessment(successMessage: success, failureHints: hints, solution: solution)
}
