// 
//  Assessments.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
let success = "### Well done! \nYou now know how to access the puzzle world itself through the `world` [instance](glossary://instance). This skill will become extremely valuable, enabling you to modify elements of the puzzle world. \n\n[**Next Page**](@next)"
let hints = [
    "Before you can solve this puzzle, you’ll need to place your expert into the puzzle world. [Initialize](glossary://initialization) an instance of type `Expert`, and then specify where you want to place that instance.",
    "To place your expert using the `place` method, pass `expert` into the `item` [parameter](glossary://parameter). Then pass **`.north`**, **`.south`**, **`.east`**, or **`.west`** into the `facing` parameter. Finally, pass in two [Int](glossary://Int) values for `atColumn` and `row`.",
    "Here's an example of how to use the `place` [method](glossary://method): `world.place(expert, facing: .north, atColumn: 3, row: 4)`.",
    "Remember, the puzzle world is on a grid, with the `(0,0)` coordinates at the bottom left.",
    "This puzzle is a **challenge** and has no provided solution. Strengthen your coding skills by creating your own approach to solving it."

]

let solution: String? = nil

public func assessmentPoint() -> AssessmentResults {
    return updateAssessment(successMessage: success, failureHints: hints, solution: solution)
}
