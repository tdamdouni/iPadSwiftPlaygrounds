// 
//  Assessments.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//

import Foundation

let success = NSLocalizedString("### Fantastic job \nYou found the solution to the hardest problem yet! And guess what? You're now ready to move on to the next major skill—conditional code. \n\n[**Introduction to Conditional Code**](@next)", comment:"Success message")


let solution: String? = nil

import PlaygroundSupport
public func assessmentPoint() -> AssessmentResults {
    pageIdentifier = "Four_Stash_Sweep"

    
    var hints = [
        NSLocalizedString("Notice how the placement is exactly the same in each set of four gems. Write the code for one set so that it works for all of the other sets.", comment:"Hint"),
        NSLocalizedString("Try solving for one set of four, then move your character through the portal and add your loop to repeat that set of actions.", comment:"Hint"),
        NSLocalizedString("This puzzle is a **challenge** and has no provided solution. Strengthen your coding skills by creating your own approach to solving it.", comment:"Hint")

        ]
    
    switch currentPageRunCount {
        
    case 0..<5:
        break
    case 5:
        hints[0] = NSLocalizedString("Remember, this puzzle is a **Challenge**. It might take you a few more tries to get to the solution.", comment:"Hint")
    case 6...8:
        hints[0] = NSLocalizedString("**Tip**: If you’re struggling with a challenge, it may help to take your mind off of it and come back to it later.", comment:"Hint")
    default:
        break
        
    }
    
    
    return updateAssessment(successMessage: success, failureHints: hints, solution: solution)
}
