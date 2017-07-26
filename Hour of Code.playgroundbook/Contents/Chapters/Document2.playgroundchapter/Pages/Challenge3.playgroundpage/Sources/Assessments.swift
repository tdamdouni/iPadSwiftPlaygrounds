// 
//  Assessments.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//

import Foundation

let success = NSLocalizedString("### You're really getting this! \nBy using [decomposition](glossary://decomposition) to break down a larger problem into smaller, more manageable parts, you're making your code more readable and reusable. \n\n[**Next Page**](@next)", comment:"Success message")
let hints = [
    NSLocalizedString("Use the function `collectGemTurnAround()`, possibly along with other commands, to [define](glossary://define) `solveRow()`.", comment:"Hint"),
    NSLocalizedString("There are many ways to approach solving this puzzle. Figure out which one you'd like to try, and go for it!", comment:"Hint"),
    NSLocalizedString("One way to [define](glossary://define) `solveRow()` is to [call](glossary://call) `collectGemTurnAround()` twice.", comment:"Hint"),
    NSLocalizedString("This puzzle is a **challenge** and has no provided solution. Strengthen your coding skills by creating your own approach to solving it.", comment:"Hint")
]

let solution: String? = nil
public func assessmentPoint() -> AssessmentResults {
    return updateAssessment(successMessage: success, failureHints: hints, solution: solution)
}
