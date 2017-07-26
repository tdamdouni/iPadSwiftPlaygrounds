// 
//  Assessments.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//

import Foundation

let success = NSLocalizedString("### Very impressive! \nYou've solved some difficult puzzles involving variables. Nice work! Ready for the last challenge? \n\n[**Next Page**](@next)", comment:"Success message")
var hints = [
    NSLocalizedString("On the first platform, a random number of gems will appear. Check each tile and increment a gem-counting variable to count the number gems collected.", comment:"Hint"),
    NSLocalizedString("On the second platform, use a second variable to track the number of switches toggled. Compare this variable with the gem-counting variable to create a condition that says when to stop toggling switches.", comment:"Hint"),
    NSLocalizedString("This puzzle is a **challenge** and has no provided solution. Strengthen your coding skills by creating your own approach to solving it.", comment:"Hint")

]


let solution: String? = nil


public func assessmentPoint() -> AssessmentResults {
    
    return updateAssessment(successMessage: success, failureHints: hints, solution: solution)
}
