// 
//  Assessments.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//

import Foundation

let success = NSLocalizedString("### Masterful! \nNow it's time to start modifying every part of the puzzle world. Are you ready? \n\n[**Next Page**](@next)", comment:"Success message")
let hints = [
    NSLocalizedString("First, you’ll need to build out part of the puzzle world so that you can reach the locations where the gems are generated.", comment:"Hint"),
    NSLocalizedString("Create and place an [instance](glossary://instance) of your character to move around the puzzle and collect gems.", comment:"Hint"),
    NSLocalizedString("Remember, there are many ways to solve this puzzle, but you should first think through a solution that might work, and then code and test that solution.", comment:"Hint"),
    NSLocalizedString("This puzzle is a **challenge** and has no provided solution. Strengthen your coding skills by creating your own approach to solving it.", comment:"Hint")

]

let solution: String? = nil


public func assessmentPoint() -> AssessmentResults {
    return updateAssessment(successMessage: success, failureHints: hints, solution: solution)
}
