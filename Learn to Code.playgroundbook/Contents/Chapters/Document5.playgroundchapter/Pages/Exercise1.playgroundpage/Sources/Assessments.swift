// 
//  Assessments.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//


let solution = "```swift\nmoveForward()\nmoveForward()\n\nif isOnClosedSwitch {\n    toggleSwitch()\n}\nmoveForward()\nif isOnClosedSwitch {\n    toggleSwitch()\n}\nmoveForward()\nif isOnClosedSwitch {\n    toggleSwitch()\n}\n```"

import PlaygroundSupport
public func assessmentPoint() -> AssessmentResults {
    let checker = ContentsChecker(contents: PlaygroundPage.current.text)
    
    let success = "### Fantastic! \nYou've just written code that works even when you don't know how each switch is toggled. \n\nThis is one of the most useful powers in coding; apps use it all the time! Messages plays a sound *if* you get a text from a friend. Safari has to see *if* your iPhone can connect to the Internet before going to a website. Keep going to see more ways to use **`if` statements**! \n\n[Next Page](@next)"

    
    var hints = [
        "Remember, you need to move Byte to each switch location and check to see how the switch is toggled. If it's closed, toggle it open.",
        "To check whether Byte should toggle the switch, use `isOnClosedSwitch` after `if` and before the `{ }` braces.",
        "To toggle a switch only when Byte is on a closed one, use `toggleSwitch()` between the `{ }` braces of the `if` statement.",
        ]
    
    if !checker.didUseConditionalStatement("if") {
        hints[0] = "You need to use an `if` statement to determine whether to toggle the switch. Tap `if` in the shortcut bar to insert an if statement into your code. Then use the condition `isOnClosedSwitch` to determine whether to toggle the switch."
    } else if checker.functionCallCount(forName: "moveForward") < 3 {
        hints[0] = "Remember that you need to move forward to each of the tiles before checking whether the switch is on or off."
    }
    
    
    return updateAssessment(successMessage: success, failureHints: hints, solution: solution)
}

