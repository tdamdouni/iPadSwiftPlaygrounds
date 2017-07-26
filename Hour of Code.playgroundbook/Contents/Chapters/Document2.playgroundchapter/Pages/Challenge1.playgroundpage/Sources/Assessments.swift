// 
//  Assessments.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//

import Foundation

let solution: String? = nil

import PlaygroundSupport
public func assessmentPoint() -> AssessmentResults {
    
    let checker = ContentsChecker(contents: PlaygroundPage.current.text)
    
    var success = NSLocalizedString("### Your function skills are growing! \nYou're actually writing your own functions! Functions let you simplify complicated actions. \n\n[**Next Page**](@next)", comment:"Success message")

    var hints = [
        NSLocalizedString("Your [function](glossary://function) should first collect a gem, then move forward, then toggle a switch.", comment:"Hint"),
        NSLocalizedString("In this challenge, you'll need to use your function in several different places around the puzzle world.", comment:"Hint"),
        NSLocalizedString("This puzzle is a **challenge** and has no provided solution. Strengthen your coding skills by creating your own approach to solving it.", comment:"Hint")

        ]

    
    if checker.didUseForLoop || checker.didUseWhileLoop {
        success = NSLocalizedString("### Amazing! \nWhat a surprise! You used a loop to solve this puzzle. You've become a coding wizard! \n[**Next Page**](@next)", comment:"Success message")
    } else if !checker.didCallCustomFunction() {
        let format = NSLocalizedString("sd:chapter2.challenge1.noCustomFunctionSuccessMessage", comment: "Success message - {number of functions used}")
        success = String.localizedStringWithFormat(format, checker.calledFunctions.count)
        hints[0] = NSLocalizedString("Try writing your own function to solve the puzzle. First give your function a name, then [define](glossary://define) it with commands to collect a gem, move forward, and toggle open a switch.", comment:"Hint")
        
    } else if world.commandQueue.containsIncorrectCollectGemCommand() {
        hints[0] = NSLocalizedString("Oops, you called `collectGem()` when no gem was present! This is actually a bug in your program - you should only collect a gem if one is present on that tile.", comment:"Hint")
    } else if checker.numberOfStatements > 18 {
        let format = NSLocalizedString("sd:chapter2.challenge1.inefficientSuccessMessage", comment: "Hint - {number of commands used}")
        hints[0] = String.localizedStringWithFormat(format, checker.calledFunctions.count)
    } else if checker.didCallCustomFunction() {
        hints[0] = NSLocalizedString("To get the most our of your function, be sure to call it in all four locations that have a gem and a switch.", comment:"Hint")
    }
 



    return updateAssessment(successMessage: success, failureHints: hints, solution: solution)
}



