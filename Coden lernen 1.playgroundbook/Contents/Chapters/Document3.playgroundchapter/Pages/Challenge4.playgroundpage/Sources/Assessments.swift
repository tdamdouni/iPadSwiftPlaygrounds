// 
//  Assessments.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//

import Foundation

let success = NSLocalizedString("### Unbelievable! \nLook how fast you're becoming a coder! You've learned the secret: break these tough-looking problems into little pieces, then group your simple solutions into a [function](glossary://function) that you can [call](glossary://call) over and over again. \n\n[**Next Page**](@next)", comment:"Success message")

let solution: String? = nil

import PlaygroundSupport
public func assessmentPoint() -> AssessmentResults {
    let checker = ContentsChecker(contents: PlaygroundPage.current.text)
    pageIdentifier = "Gem_Farm"

    var hints = [
        NSLocalizedString("First, think of all of the tasks you can include in a function.", comment:"Hint"),
        NSLocalizedString("How can you use `for` loops to repeat a set of functions that you've written?", comment:"Hint"),
        NSLocalizedString("This puzzle is a **challenge** and has no provided solution. Strengthen your coding skills by creating your own approach to solving it.", comment:"Hint")
        ]
    
    switch currentPageRunCount {
    
    case 0..<4:
        break
    case 4:
        hints[0] = NSLocalizedString("Remember, this puzzle is a **Challenge**. It might take you a few more tries to get to the solution.", comment:"Hint")
    case 5...7:
        hints[0] = NSLocalizedString("**Tip**: If you’re struggling with a challenge, it may help to take your mind off of it and come back to it later. In the meantime, feel free to move on.", comment:"Hint")
    default:
       break

    }
    
    
    
    return updateAssessment(successMessage: success, failureHints: hints, solution: solution)
}
