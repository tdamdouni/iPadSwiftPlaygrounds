// 
//  Assessments.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
let success = "### Fantastic job \nYou found the solution to the hardest problem yet! And guess what? You're now ready to move on to the next major skill—conditional code. \n\n[**Introduction to Conditional Code**](Conditional%20Code/Introduction)"


let solution: String? = nil

import PlaygroundSupport
public func assessmentPoint() -> AssessmentResults {
    pageIdentifier = "Four_Stash_Sweep"

    
    var hints = [
        "Notice how the placement is exactly the same in each set of four gems. Write the code for one set so that it works for all of the other sets.",
        "Try solving for one set of four, then move your character through the portal and add your loop to repeat that set of actions.",
        "This puzzle is a **challenge** and has no provided solution. Strengthen your coding skills by creating your own approach to solving it."

        ]
    
    switch currentPageRunCount {
        
    case 0..<5:
        break
    case 5:
        hints[0] = "Remember, this puzzle is a **Challenge**. It might take you a few more tries to get to the solution."
    case 6...8:
        hints[0] = "**Tip**: If you’re struggling with a challenge, it may help to take your mind off of it and come back to it later."
    default:
        break
        
    }
    
    
    return updateAssessment(successMessage: success, failureHints: hints, solution: solution)
}
