// 
//  Assessments.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//

import Foundation

let solution = "```swift\nfor i in 1 ... 5 {\n   moveForward()\n   moveForward()\n   collectGem()\n   moveForward()\n}\n```"

import PlaygroundSupport
public func assessmentPoint() -> AssessmentResults {
    let checker = ContentsChecker(contents: PlaygroundPage.current.text)
    
    var success = NSLocalizedString("### Nice work! Loops  simplify the repetition of set of commands. In this exercise, a loop was provided for you, but in the next exercise, you'll learn how to add a `for` loop to your code any time you want. \n\n[**Next Page**](@next)", comment:"Success message")
    
    var hints = [
        NSLocalizedString("Can you figure out the set of commands you need to repeat?", comment:"Hint"),
        NSLocalizedString("The basic sequence is to move forward, collect the gem, then move to the portal.", comment:"Hint"),
        NSLocalizedString("There are five rows, so you'll need your loop to run five times.", comment:"Hint")
        ]

    
    
    if checker.didUseWhileLoop {
        success = NSLocalizedString("### Incredible! \nYour use of a while loop here is very impressive! \n\n[Next Page](@next)", comment:"Success message")

        
    } else if checker.didUseForLoop {
        success = NSLocalizedString("### Nice work!  \nLoops simplify the repetition of a set of commands. In this exercise, a loop was provided for you, but in the next exercise you'll learn how to add a `for` loop to your code any time you want. \n\n[**Next Page**](@next)", comment:"Success message")
        hints[0] = NSLocalizedString("The basic sequence is to move forward, collect the gem, then move to the portal.", comment:"Hint")
        hints[1] = NSLocalizedString("Move forward twice, collect the gem, then move forward again.", comment:"Hint")
    } else if !checker.didUseForLoop {
        success = NSLocalizedString("### Don't forget to use a loop! \nYour solution will be much simpler if you use a loop. Give it a shot.", comment:"Success message")
        hints[0] = NSLocalizedString("First tap `number` and specify the number of times you want your loop to run. Then add the commands you want to repeat inside the `for` loop.", comment:"Hint")
    }
    
    
    
    
    
    return updateAssessment(successMessage: success, failureHints: hints, solution: solution)
}
