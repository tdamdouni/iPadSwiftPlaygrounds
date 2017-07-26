// 
//  Assessments.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//

import Foundation

let success = NSLocalizedString("### Awesome! \nYou've completed Variables. Give yourself a huge pat on the back. Next up, you’ll discover a new ability-changing elements of the puzzle world with the power of code. \n\n[**Introduction to Types**](@next)", comment:"Success message")
var hints = [
 NSLocalizedString("`totalGems` represents the total number of gems that will be generated in the puzzle. Use this [constant](glossary://constant), along with a gem-counting [variable](glossary://variable), to determine when to stop collecting gems.", comment:"Hint"),
 NSLocalizedString("Write an [algorithm](glossary://algorithm) that continues to move your character back and forth through the portals as you check for gems.", comment:"Hint"),
 NSLocalizedString("This puzzle is a **challenge** and has no provided solution. Strengthen your coding skills by creating your own approach to solving it.", comment:"Hint")

]


let solution: String? = nil

public func assessmentPoint() -> AssessmentResults {
    return updateAssessment(successMessage: success, failureHints: hints, solution: solution)
}
