// 
//  Assessments.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
let success = "### Amazing! \nYou’ve started combining all of your coding skills in new and useful ways. Next, you'll see how to place a different type of item-a portal. \n\n[**Next Page**](@next)"
let hints = [
    "You'll need to make multiple [instances](glossary://instance) of the `Block` [type](glossary://type), and place them in locations that will enable you to solve the puzzle.",
    "By stacking one block on top of another, you may be able to cross bridges of higher elevations.",
    "Use the same `world.place` [method](glossary://method) as you used in the previous exercise.",
    "The placement code for one block might look something like this: `world.place(block1, atColumn: 2, row: 2)`.",
    "This puzzle is a **challenge** and has no provided solution. Strengthen your coding skills by creating your own approach to solving it."

]

let solution: String? = nil

public func assessmentPoint() -> AssessmentResults {
    return updateAssessment(successMessage: success, failureHints: hints, solution: solution)
}
