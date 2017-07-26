// 
//  Assessments.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
let success = "### Stellar work! \nThe way you’re solving problems here is exactly what coders do. Building an app is really just a matter of finding solutions to tons of small problems. After solving the small problems, coders combine those solutions to solve a bigger problem. \n\nCongratulations on completing Functions—now it's time to learn about [**For Loops**](For%20Loops/Introduction)."
let hints = [
    "Think about the patterns in the placement of switches. How can you take advantage of the patterns to write functions to solve small problems, and combine them to solve the larger problem?",
    "First, try defining a function that moves forward twice and toggles a switch. From there, define another function that toggles a switch, then returns to the center.",
    "This puzzle is a **challenge** and has no provided solution. Strengthen your coding skills by creating your own approach to solving it."

]

let solution: String? = nil

public func assessmentPoint() -> AssessmentResults {
    return updateAssessment(successMessage: success, failureHints: hints, solution: solution)
}
