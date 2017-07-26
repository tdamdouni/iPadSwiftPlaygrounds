// 
//  Assessments.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
let solution = "```swift\nmoveForward()\n\nif isOnClosedSwitch {\n   toggleSwitch()\n} else if isOnGem {\n   collectGem()\n}\n\nmoveForward()\nif isOnClosedSwitch {\n   toggleSwitch()\n} else if isOnGem {\n   collectGem()\n}\n```"


import PlaygroundSupport
public func assessmentPoint() -> AssessmentResults {
    let checker = ContentsChecker(contents: PlaygroundPage.current.text)
    
    let success = "### Impressive! \nYou now know how to write your own `else if` statements.\n\n[**Next Page**](@next)"
    var hints = [
        "Start by moving to the first tile and using an `if` statement to check whether your character is on a closed switch.",
        "Add an `if` statement and use the condition `isOnClosedSwitch` to check whether you should toggle a switch. Then add an `else if` block by tapping the word `if` in your code area and tapping \"Add 'else if' Statement\".",
        "If your character is on a closed switch, toggle it. Otherwise (the “else” part), if your character is on a gem, collect it.",

        ]
    
    if !checker.didUseConditionalStatement("if") {
        hints[0] = "After you've added an `if` statement, tap the word `if` in your code and use the \"Add 'else if' Statement\" option."
        hints.remove(at: 1)
    } else if !checker.didUseConditionalStatement("else if") {
        hints[0] = "To add an `else if` statement, tap the word `if` in your code and then tap \"Add else if statement\"."
    }
    
    
    
    
    return updateAssessment(successMessage: success, failureHints: hints, solution: solution)
}
