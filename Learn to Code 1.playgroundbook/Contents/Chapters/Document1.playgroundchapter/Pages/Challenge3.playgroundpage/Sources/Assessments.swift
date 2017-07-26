// 
//  Assessments.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//

let solution: String? = nil


import PlaygroundSupport
public func assessmentPoint() -> AssessmentResults {
    let checker = ContentsChecker(contents: PlaygroundPage.current.text)
    
    var success = "### Amazing job! \nYou just completed Simple Commands. Now it's time to learn about Functions. \n\n[Introduction to Functions](Functions/Introduction)"
    
    
    var hints = [
        "Look at the puzzle world and find the route to the gem that requires the fewest commands.",
        "Use the portals to shorten your route.",
        "This puzzle is a **challenge** and has no provided solution. Strengthen your coding skills by creating your own approach to solving it."

        ]
    
    if checker.numberOfStatements < 9 {
        success = "### Incredible Work! \nYou found a solution that almost no one else discovers! \nNow it's time to learn about Functions. \n\n[**Introduction to Functions**](Functions/Introduction)"
    } else if checker.numberOfStatements == 9 {
        success = "### You found the shortest route! \nCongratulations on finding one of the most efficient solutions to this level!\n\nNow that you've completed Simple Commands, it's time to learn about Functions. \n\n[**Introduction to Functions**](Functions/Introduction)"
    } else if checker.numberOfStatements > 9 && checker.numberOfStatements <= 13 {
        success = "### Nice job! \nYou found the second shortest solution. You can move on to learn about Functions, but as an added challenge, can you find an even shorter way to solve this puzzle? \n\n[**Introduction to Functions**](Functions/Introduction)"
        hints[0] = "You're on the right track, but there might be a shorter way to solve the puzzle. The portals are color-coded: blue goes to blue and green goes to green. Try again using the green portals for your solution."
    } else if checker.numberOfStatements > 13 {
        success = "### Good work! \nYou've used your new skills to solve the puzzle. You may move on to learn about Functions, but as an added challenge, can you find an even shorter solution? \n\n[**Introduction to Functions**](Functions/Introduction)"
        hints[0] = "There might be an even shorter route available. Think about how you could use the portals to reduce the number of commands you use."
        
    }

    
    
    return updateAssessment(successMessage: success, failureHints: hints, solution: solution)
}

