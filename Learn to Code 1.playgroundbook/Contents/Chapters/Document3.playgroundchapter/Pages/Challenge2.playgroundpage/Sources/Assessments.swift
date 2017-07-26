// 
//  Assessments.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
let success = "### Very good! \nThink back to the skills you've learned: simple commands, functions, and `for` loops. You'll continue to use all of these skills as you grow as a coder. \n\n[**Next Page**](@next)"
let hints = [
    "First look at the puzzle. The pattern might be a bit tougher to spot at first. Try solving one part of the puzzle before creating your loop.",
    "You'll need to move forward, turn left, move forward twice, then turn right.",
    "This puzzle is a **challenge** and has no provided solution. Strengthen your coding skills by creating your own approach to solving it."

]

let solution: String? = nil

public func assessmentPoint() -> AssessmentResults {
    return updateAssessment(successMessage: success, failureHints: hints, solution: solution)
}
