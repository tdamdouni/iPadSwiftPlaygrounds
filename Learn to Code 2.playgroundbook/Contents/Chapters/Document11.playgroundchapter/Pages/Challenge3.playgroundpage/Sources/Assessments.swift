// 
//  Assessments.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
let success = "### Amazing! \nJump up and down with joy-you just completed Parameters! You now have enough coding knowledge to change the puzzle world itself. Doesn’t it feel great? It's time to move on to World Building. \n\n[**Introduction to World Building**](World%20Building/Introduction)"
var hints = [
    "Try using [pseudocode](glossary://pseudocode) to map out how you want to solve this puzzle. Think through which skills you can use, and find a starting point. When you’ve figured out a strategy, start writing and testing your code.",
    "You’ll find it can be very helpful to test smaller sections of code before you try to write an entire solution.",
    "If you're stuck, try taking a break and coming back later. You’ll clear your mind, which can help you see new solutions that you might have missed before.",
    "This puzzle is a **challenge** and has no provided solution. Strengthen your coding skills by creating your own approach to solving it."


]

let solution: String? = nil


public func assessmentPoint() -> AssessmentResults {
    
    return updateAssessment(successMessage: success, failureHints: hints, solution: solution)
}
