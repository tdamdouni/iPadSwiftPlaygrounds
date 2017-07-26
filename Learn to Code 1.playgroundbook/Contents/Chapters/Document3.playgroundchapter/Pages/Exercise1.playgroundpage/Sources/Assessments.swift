// 
//  Assessments.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
let solution = "```swift\nfor i in 1 ... 5 {\n   moveForward()\n   moveForward()\n   collectGem()\n   moveForward()\n}\n```"

import PlaygroundSupport
public func assessmentPoint() -> AssessmentResults {
    let checker = ContentsChecker(contents: PlaygroundPage.current.text)
    
    var success = "### Nice work! Loops  simplify the repetition of set of commands. In this exercise, a loop was provided for you, but in the next exercise, you'll learn how to add a `for` loop to your code any time you want. \n\n[**Next Page**](@next)"
    
    var hints = [
        "Can you figure out the set of commands you need to repeat?",
        "The basic sequence is to move forward, collect the gem, then move to the portal.",
        "There are five rows, so you'll need your loop to run five times."
        ]

    
    
    if checker.didUseWhileLoop {
        success = "### Incredible! \nYour use of a while loop here is very impressive! \n\n[Next Page](@next)"

        
    } else if checker.didUseForLoop {
        success = "### Nice work!  \nLoops simplify the repetition of a set of commands. In this exercise, a loop was provided for you, but in the next exercise you'll learn how to add a `for` loop to your code any time you want. \n\n[**Next Page**](@next)"
        hints[0] = "The basic sequence is to move forward, collect the gem, then move to the portal."
        hints[1] = "Move forward twice, collect the gem, then move forward again."
    } else if !checker.didUseForLoop {
        success = "### Don't forget to use a loop! \nYour solution will be much simpler if you use a loop. Give it a shot."
        hints[0] = "First tap `number` and specify the number of times you want your loop to run. Then add the commands you want to repeat inside the `for` loop."
    }
    
    
    
    
    
    return updateAssessment(successMessage: success, failureHints: hints, solution: solution)
}
