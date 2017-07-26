// 
//  Assessments.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
let hints = [
    "Just like in the previous exercise, you need to update the value of the `gemCounter` variable each time you collect a gem.",
    "Collect a gem, and then use the assignment operator to set a new `gemCounter` value. \nExample: `gemCounter = 3`",
    "After you collect all the gems, the value of the `gemCounter` variable should be 5.",
    "This puzzle is a **challenge** and has no provided solution. Strengthen your coding skills by creating your own approach to solving it."

]


let solution: String? = nil

public func assessmentPoint() -> AssessmentResults {
    
    
    let success: String
    if finalGemCount == 5 && initialGemCount == 0 {
        success = "### Excellent work! \nBy continuously updating the `gemCounter` value, you can track that value as it changes over time. Next, you'll learn a more efficient way to do this.\n\n[**Next Page**](@next)"
    } else if initialGemCount == 5 {
        success = "You collected all the gems, but instead of assigning a new value to `gemCounter` after collecting the gems, you set the initial value to `5`. To accurately track the gems you've collected, you must set the initial value of `gemCounter` to `0`, then assign a new value after collecting additional gems."
    } else {
        success = "You collected all the gems, but didn't track them correctly. Your `gemCounter` variable has a value of `\(finalGemCount)`, but it should have a value of `5`. Try adjusting the code to accurately track how many gems you've collected."
    }
    
    return updateAssessment(successMessage: success, failureHints: hints, solution: solution)
}
