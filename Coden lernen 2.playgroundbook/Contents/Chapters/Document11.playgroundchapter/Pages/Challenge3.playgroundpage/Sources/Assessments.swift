// 
//  Assessments.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//

import Foundation

let success = NSLocalizedString("### Amazing! \nJump up and down with joy-you just completed Parameters! You now have enough coding knowledge to change the puzzle world itself. Doesn’t it feel great? It's time to move on to World Building. \n\n[**Introduction to World Building**](@next)", comment:"Success message")
var hints = [
    NSLocalizedString("Try using [pseudocode](glossary://pseudocode) to map out how you want to solve this puzzle. Think through which skills you can use, and find a starting point. When you’ve figured out a strategy, start writing and testing your code.", comment:"Hint"),
    NSLocalizedString("You’ll find it can be very helpful to test smaller sections of code before you try to write an entire solution.", comment:"Hint"),
    NSLocalizedString("If you're stuck, try taking a break and coming back later. You’ll clear your mind, which can help you see new solutions that you might have missed before.", comment:"Hint"),
    NSLocalizedString("This puzzle is a **challenge** and has no provided solution. Strengthen your coding skills by creating your own approach to solving it.", comment:"Hint")


]

let solution: String? = nil


public func assessmentPoint() -> AssessmentResults {
    
    return updateAssessment(successMessage: success, failureHints: hints, solution: solution)
}
