// 
//  Assessments.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//

let solution =  "```swift\nfor i in 1 ... 12 {\n   moveForward()\n   if isOnClosedSwitch {\n      toggleSwitch()\n   } else if isOnGem {\n      collectGem()\n   }\n}"


import PlaygroundSupport
public func assessmentPoint() -> AssessmentResults {
    let checker = ContentsChecker(contents: PlaygroundPage.current.text)
    
    
    let success = "### Great work! \nUsing a loop is one way to make code **reusable**. Using `if` statements makes your code **adaptable**, too. Even though the body of the [loop](glossary://loop) runs again and again, the conditions can change each time. \n\n[**Next Page**](@next) "
    var hints = [
        "Remember to use `collectGem()` if your character is on a gem, and `toggleSwitch()` if your character is on a closed switch.",
        "There are 12 tiles to check, so you'll need to run your loop 12 times.",
        ]
    
    if !checker.didUseConditionalStatement("if") {
        hints[0] = "Start by placing an `if` statement under the `moveForward()` command so that each time your loop runs, you check for either a gem or a switch."
    } else if !checker.didUseConditionalStatement("else if") {
        hints[0] = "To add an `else if` statement, tap the word `if` in your code and then tap \"Add else if Statement\"."
    }
    
    
    return updateAssessment(successMessage: success, failureHints: hints, solution: solution)
}
