// 
//  Assessments.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//

import Foundation

let success = NSLocalizedString("### Phenomenal! \nNotice how even small bits of code can be extremely powerful and can work in many different situations. You’re starting to write code that is adaptable and reusable, which is what professional coders strive for! \n\n[**Next Page**](@next)", comment:"Success message")

let solution: String? = nil

public func assessmentPoint() -> AssessmentResults {
    pageIdentifier = "Random Rectangles"

    var hints = [
        NSLocalizedString("The size of this puzzle world will change every time you run your code, but it will always be shaped like a rectangle.", comment:"Hint"),
        NSLocalizedString("Use [nested loops](glossary://nest) to run one [`while` loop](glossary://while%20loop) as long as another `while` loop condition is true.", comment:"Hint"),
        NSLocalizedString("Run the [outer loop](glossary://outer%20loop) until you reach the switch, and run the [inner loop](glossary://inner%20loop) until you reach the end of one side of the rectangle.", comment:"Hint"),
        NSLocalizedString("This puzzle is a **challenge** and has no provided solution. Strengthen your coding skills by creating your own approach to solving it.", comment:"Hint")

    ]
    
    switch currentPageRunCount {
    
    case 0..<5:
        break
    case 5...7:
        hints[0] = NSLocalizedString("You're doing great! Some of the best programmers in the world try and fail often. Every time you correct a mistake, your brain gets a little better at what you're doing, even if it doesn't feel that way!", comment:"Hint")
    default:
        break
   
        
    }
    
    
    return updateAssessment(successMessage: success, failureHints: hints, solution: solution)
}




