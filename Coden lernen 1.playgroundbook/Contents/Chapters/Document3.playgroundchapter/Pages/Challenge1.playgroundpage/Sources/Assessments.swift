// 
//  Assessments.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//

import Foundation

let success = NSLocalizedString("### Nice work! \nYou're getting the hang of this. \n\n[**Next Page**](@next)", comment:"Success message")
let hints = [
    NSLocalizedString("First add a `for` loop to your code.", comment:"Hint"),
    NSLocalizedString("There are two possible approaches to solving this puzzle. In one, each time the loop runs, your character moves out from the center, then back to the center. In the other, your character moves to the outside of the square, then uses loops to walk around each corner.", comment:"Hint"),
    NSLocalizedString("This puzzle is a **challenge** and has no provided solution. Strengthen your coding skills by creating your own approach to solving it.", comment:"Hint")

]

let solution: String? = nil

public func assessmentPoint() -> AssessmentResults {
    return updateAssessment(successMessage: success, failureHints: hints, solution: solution)
}
