// 
//  Assessments.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
let solution: String? = nil

import PlaygroundSupport
public func assessmentPoint() -> AssessmentResults {
    let checker = ContentsChecker(contents: PlaygroundPage.current.text)
    
    var success = "### Boolean master! \nA condition like `isOnGem` is a [Boolean](glossary://Boolean): It’s always either true or false. In an **`if else`** statement, your `if` statement runs if your Boolean is true, and your [`else` block](glossary://else%20block) runs if your Boolean is false. \n\n[**Next Page**](@next)"
    var hints = [
        "Try keeping your `else` block just as it is, without changing the `moveForward()` command. Instead, modify the commands inside your `if` block.",
        "Each time you reach a gem, the path turns to the left.",
        "Each time you move forward, check for a gem. If a gem is present, turn left.",
        "This puzzle is a **challenge** and has no provided solution. Strengthen your coding skills by creating your own approach to solving it."

        ]
    
    
    if !checker.didUseConditionalStatement("if") {
        success = "### You can improve your code. \nUsing conditional code with an `if` statement will help us solve this problem more efficiently. Add an `if` statement and give it another shot."
    } else if checker.numberOfStatements > 12 {
        hints[0] = "Inside your `if` statement, check whether your character is on a gem. If so, turn left."
    }
    
    
    return updateAssessment(successMessage: success, failureHints: hints, solution: solution)
}
