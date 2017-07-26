// 
//  Assessments.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//

import Foundation

let solution = "```swift\nmoveForward()\n\nif isOnClosedSwitch {\n   toggleSwitch()\n} else if isOnGem {\n   collectGem()\n}\n\nmoveForward()\nif isOnClosedSwitch {\n   toggleSwitch()\n} else if isOnGem {\n   collectGem()\n}\n```"


import PlaygroundSupport
public func assessmentPoint() -> AssessmentResults {
    let checker = ContentsChecker(contents: PlaygroundPage.current.text)
    
    let success = NSLocalizedString("### Impressive! \nYou now know how to write your own `else if` statements.\n\n[**Next Page**](@next)", comment:"Success message")
    var hints = [
        NSLocalizedString("Start by moving to the first tile and using an `if` statement to check whether your character is on a closed switch.", comment:"Hint"),
        NSLocalizedString("Add an `if` statement and use the condition `isOnClosedSwitch` to check whether you should toggle a switch. Then add an `else if` block by tapping the word `if` in your code area and tapping \"Add 'else if' Statement\".", comment:"Hint"),
        NSLocalizedString("If your character is on a closed switch, toggle it. Otherwise (the “else” part), if your character is on a gem, collect it.", comment:"Hint"),

        ]
    
    if !checker.didUseConditionalStatement("if") {
        hints[0] = NSLocalizedString("After you've added an `if` statement, tap the word `if` in your code and use the \"Add 'else if' Statement\" option.", comment:"Hint")
        hints.remove(at: 1)
    } else if !checker.didUseConditionalStatement("else if") {
        hints[0] = NSLocalizedString("To add an `else if` statement, tap the word `if` in your code and then tap \"Add else if Statement\".", comment:"Hint")
    }
    
    
    
    
    return updateAssessment(successMessage: success, failureHints: hints, solution: solution)
}
