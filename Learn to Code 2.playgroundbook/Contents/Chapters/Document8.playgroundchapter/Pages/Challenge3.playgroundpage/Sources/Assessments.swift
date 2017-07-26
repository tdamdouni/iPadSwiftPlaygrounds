// 
//  Assessments.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
let success = "### Very impressive! \nYou've solved some difficult puzzles involving variables. Nice work! Ready for the last challenge? \n\n[**Next Page**](@next)"
var hints = [
    "On the first platform, a random number of gems will appear. Check each tile and increment a gem-counting variable to count the number gems collected.",
    "On the second platform, use a second variable to track the number of switches toggled. Compare this variable with the gem-counting variable to create a condition that says when to stop toggling switches.",
    "This puzzle is a **challenge** and has no provided solution. Strengthen your coding skills by creating your own approach to solving it."

]


let solution: String? = nil


public func assessmentPoint() -> AssessmentResults {
    
    return updateAssessment(successMessage: success, failureHints: hints, solution: solution)
}
