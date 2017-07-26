// 
//  Assessments.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//

import Foundation



let solution = "```swift\nmoveForward()\nmoveForward()\n\nif isOnClosedSwitch {\n   toggleSwitch()\n}\nmoveForward()\nif isOnClosedSwitch {\n   toggleSwitch()\n}\nmoveForward()\nif isOnClosedSwitch {\n   toggleSwitch()\n}\n```"

import PlaygroundSupport
public func assessmentPoint() -> AssessmentResults {
    let checker = ContentsChecker(contents: PlaygroundPage.current.text)
    
    let success = NSLocalizedString("### Fantastic! \nYou've just written code that works even when you don't know how each switch is toggled. \n\nThis is one of the most useful powers in coding; apps use it all the time! Messages plays a sound *if* you get a text from a friend. Safari has to see *if* your iPhone can connect to the Internet before going to a website. Keep going to see more ways to use [`if` statements](glossary://if%20statement)! \n\n[**Next Page**](@next)", comment:"Success message")

    
    var hints = [
        NSLocalizedString("Remember, you need to move to each switch location and check to see how the switch is toggled. If it's closed, toggle it open.", comment:"Hint"),
        NSLocalizedString("To check whether you should toggle the switch, use `isOnClosedSwitch` after `if` and before the `{ }` braces.", comment:"Hint"),
        NSLocalizedString("To toggle a switch only when your character is on a closed one, use `toggleSwitch()` between the `{ }` braces of the `if` statement.", comment:"Hint"),
        ]
    
    if !checker.didUseConditionalStatement("if") {
        hints[0] = NSLocalizedString("You need to use an `if` statement to determine whether to toggle the switch. Tap `if` in the shortcut bar to insert an if statement into your code. Then use the condition `isOnClosedSwitch` to determine whether to toggle the switch.", comment:"Hint")
    } else if checker.functionCallCount(forName: "moveForward") < 3 {
        hints[0] = NSLocalizedString("Remember that you need to move forward to each of the tiles before checking whether the switch is on or off.", comment:"Hint")
    }
    
    
    return updateAssessment(successMessage: success, failureHints: hints, solution: solution)
}

