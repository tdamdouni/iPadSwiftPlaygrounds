// 
//  Assessments.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//

import Foundation


let solution =  "```swift\nfor i in 1 ... 12 {\n   moveForward()\n   if isOnClosedSwitch {\n      toggleSwitch()\n   } else if isOnGem {\n      collectGem()\n   }\n}"


import PlaygroundSupport
public func assessmentPoint() -> AssessmentResults {
    let checker = ContentsChecker(contents: PlaygroundPage.current.text)
    
    
    let success = NSLocalizedString("### Great work! \nUsing a loop is one way to make code **reusable**. Using `if` statements makes your code **adaptable**, too. Even though the body of the [loop](glossary://loop) runs again and again, the conditions can change each time. \n\n[**Next Page**](@next) ", comment:"Success message")
    var hints = [
        NSLocalizedString("Remember to use `collectGem()` if your character is on a gem, and `toggleSwitch()` if your character is on a closed switch.", comment:"Hint"),
        NSLocalizedString("There are 12 tiles to check, so you'll need to run your loop 12 times.", comment:"Hint"),
        ]
    
    if !checker.didUseConditionalStatement("if") {
        hints[0] = NSLocalizedString("Start by placing an `if` statement under the `moveForward()` command so that each time your loop runs, you check for either a gem or a switch.", comment:"Hint")
    } else if !checker.didUseConditionalStatement("else if") {
        hints[0] = NSLocalizedString("To add an `else if` statement, tap the word `if` in your code and then tap \"Add else if Statement\".", comment:"Hint")
    }
    
    
    return updateAssessment(successMessage: success, failureHints: hints, solution: solution)
}
