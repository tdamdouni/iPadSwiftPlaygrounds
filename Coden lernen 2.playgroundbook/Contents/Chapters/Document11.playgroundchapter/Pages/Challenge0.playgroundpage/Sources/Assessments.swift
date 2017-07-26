// 
//  Assessments.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//

import Foundation

let success = NSLocalizedString("### Great Job! \nNow that you’ve learned how to create functions with [parameters](glossary://parameter), find out how to use parameters to place a character in a specific location in the puzzle world. \n\n[**Next Page**](@next)", comment:"Success message")
let hints = [
NSLocalizedString("Remember, you can use both the `move(distance: Int)` and `turnLock(up: Bool, numberOfTimes: Int)` methods to solve this puzzle.", comment:"Hint"),
NSLocalizedString("This puzzle is a **challenge** and has no provided solution. Strengthen your coding skills by creating your own approach to solving it.", comment:"Hint")

]

let solution: String? = nil


public func assessmentPoint() -> AssessmentResults {
    return updateAssessment(successMessage: success, failureHints: hints, solution: solution)
}
