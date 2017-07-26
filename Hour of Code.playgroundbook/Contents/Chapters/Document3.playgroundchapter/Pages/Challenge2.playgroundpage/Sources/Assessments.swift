// 
//  Assessments.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//

import Foundation

import PlaygroundSupport
var success = NSLocalizedString("### Very good! \nThink back to the skills you've learned: simple commands, functions, and `for` loops. You'll continue to use all of these skills as you grow as a coder. \n\n[**Next Page**](@next)", comment:"Success message")
var hints = [
    NSLocalizedString("First look at the puzzle. The pattern might be a bit tougher to spot at first. Try solving one part of the puzzle before creating your loop.", comment:"Hint"),
    NSLocalizedString("You'll need to move forward, turn left, move forward twice, then turn right.", comment:"Hint"),
    NSLocalizedString("This puzzle is a **challenge** and has no provided solution. Strengthen your coding skills by creating your own approach to solving it.", comment:"Hint")

]

let solution: String? = nil

public func assessmentPoint() -> AssessmentResults {
    let checker = ContentsChecker(contents: PlaygroundPage.current.text)
    
    if checker.didUseWhileLoop {
        success = NSLocalizedString("### Incredible! \nYour use of a while loop here is very impressive! \n\n[Next Page](@next)", comment:"Success message")
        
        
    } else if checker.didUseForLoop {
        success = NSLocalizedString("### Very good! \nThink back to the skills you've learned: simple commands, functions, and `for` loops. You'll continue to use all of these skills as you grow as a coder. \n\n[**Next Page**](@next)", comment:"Success message")
    } else if !checker.didUseForLoop && !checker.didUseWhileLoop {
        success = NSLocalizedString("### Don't forget to use a loop! \nRemember, using a loop allows you to repeat a set of commands so you don't have to write them out many times. Try using a loop to solve this puzzle.", comment:"Success message")

    }
    
    
    return updateAssessment(successMessage: success, failureHints: hints, solution: solution)
}
