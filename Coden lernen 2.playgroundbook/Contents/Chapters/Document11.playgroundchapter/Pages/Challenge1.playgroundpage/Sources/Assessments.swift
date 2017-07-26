// 
//  Assessments.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//

import Foundation

let success = NSLocalizedString("### Well done! \nYou now know how to access the puzzle world itself through the `world` [instance](glossary://instance). This skill will become extremely valuable, enabling you to modify elements of the puzzle world. \n\n[**Next Page**](@next)", comment:"Success message")
let hints = [
    NSLocalizedString("Before you can solve this puzzle, you’ll need to place your expert into the puzzle world. [Initialize](glossary://initialization) an instance of type `Expert`, and then specify where you want to place that instance.", comment:"Hint"),
    NSLocalizedString("To place your expert using the `place` method, pass `expert` into the `item` [parameter](glossary://parameter). Then pass **`.north`**, **`.south`**, **`.east`**, or **`.west`** into the `facing` parameter. Finally, pass in two [Int](glossary://Int) values for `atColumn` and `row`.", comment:"Hint"),
    NSLocalizedString("Here's an example of how to use the `place` [method](glossary://method): `world.place(expert, facing: .north, atColumn: 3, row: 4)`.", comment:"Hint"),
    NSLocalizedString("Remember, the puzzle world is on a grid, with the `(0,0)` coordinates at the bottom left.", comment:"Hint"),
    NSLocalizedString("This puzzle is a **challenge** and has no provided solution. Strengthen your coding skills by creating your own approach to solving it.", comment:"Hint")

]

let solution: String? = nil

public func assessmentPoint() -> AssessmentResults {
    return updateAssessment(successMessage: success, failureHints: hints, solution: solution)
}
