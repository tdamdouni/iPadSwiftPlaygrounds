// 
//  Assessments.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//

import Foundation

var hints = [
    NSLocalizedString("Just like in the previous exercise, you need to update the value of the `gemCounter` variable each time you collect a gem.", comment:"Hint"),
    NSLocalizedString("Collect a gem, and then use the assignment operator to set a new `gemCounter` value. \nExample: `gemCounter = 3`", comment:"Hint"),
    NSLocalizedString("After you collect all the gems, the value of the `gemCounter` variable should be 5.", comment:"Hint"),
    NSLocalizedString("This puzzle is a **challenge** and has no provided solution. Strengthen your coding skills by creating your own approach to solving it.", comment:"Hint")

]


let solution: String? = nil

public func assessmentPoint() -> AssessmentResults {
    
    
    let success = NSLocalizedString("### Excellent work! \nBy continuously updating the `gemCounter` value, you can track that value as it changes over time. Next, you'll learn a more efficient way to do this.\n\n[**Next Page**](@next)", comment:"Success message")
    
    if initialGemCount == 5 && world.existingGems(at: world.allPossibleCoordinates).isEmpty {
        hints[0] = NSLocalizedString("You collected all the gems, but instead of assigning a new value to `gemCounter` after collecting the gems, you set the initial value to `5`. To accurately track the gems you've collected, you must set the initial value of `gemCounter` to `0`, then assign a new value after collecting additional gems.", comment:"Hint")
    } else if world.existingGems(at: world.allPossibleCoordinates).isEmpty {
        let format = NSLocalizedString("You collected all the gems, but didn't track them correctly. Your `gemCounter` variable has a value of `%lu`, but it should have a value of `5`. Try adjusting the code to accurately track how many gems you've collected.", comment: "Hint {value of gem count variable")
        hints[0] = String.localizedStringWithFormat(format, finalGemCount)
    }
    
    return updateAssessment(successMessage: success, failureHints: hints, solution: solution)
}
