// 
//  Assessments.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//

let solution = " ```swift\nfunc completeRow() {\n    collectGem()\n    moveForward()\n    toggleSwitch()\n    moveForward()\n    collectGem()\n    moveForward()\n    toggleSwitch()\n}\nmoveForward()\ncompleteRow()\nturnRight()\nmoveForward()\nturnRight()\ncompleteRow()\nturnLeft()\nmoveForward()\nturnLeft()\ncompleteRow()\nturnRight()\nmoveForward()\nturnRight()\ncompleteRow()\n```"

import PlaygroundSupport
public func assessmentPoint() -> AssessmentResults {
    let checker = ContentsChecker(contents: PlaygroundPage.current.text)
    
    var success = "Great work! You're writing and using your own functions. That's a major part of what it means to be a coder. With a [function](glossary://function) you can group commands together and [call](glossary://call) the function once to run the whole set of commands. Using functions makes code much easier to read and to understand at a glance. \n\n[Next Page](@next)"
    
    var hints = [
        "Try to find the repeating patterns in the puzzle. For example, each row contains a gem, a switch, another gem, and another switch in a line.",
        "Once you've identified a pattern of commands that Byte will repeat, define your function using that set of commands. Then call your function any time you want Byte to perform that pattern of behavior.",
        
        ]
    let customFunction = checker.customFunctions.first ?? ""

    if checker.didUseForLoop || checker.didUseWhileLoop {
        success = "### Wow! \nNice work using a loop to solve this puzzle. You are clearly getting pretty good at this. \n\n[Next Page](@next)"
    } else if world.commandQueue.containsIncorrectCollectGemCommand(for: actor) {
        hints[0] = "Oops, you called `collectGem()` when no gem was present. This is a bug in your program—you should collect a gem only if one is present on the tile."
    } else if checker.functionCallCount(forName: customFunction) == 0 {
        success = "### Getting there! \nYou found a solution to the puzzle, but you didn't [define](glossary://define) your own function. You used \(checker.calledFunctions.count) commands, but you can solve it with fewer than 24. Try defining your own [function](glossary://function) using `func name() {}` and giving it a set of commands, then calling it to solve the puzzle. You won't need to use as many commands, and your code will be easier to read."
        hints[0] = "Define your function by giving it a name and a set of commands. Then be sure to [call](glossary://call) your function by tapping the function name in the shortcut bar."
    } else if checker.numberOfStatements > 32 {
        hints[0] = "You've used \(checker.calledFunctions.count) commands, but you can solve this puzzle with fewer than 24. One way to write shorter, more readable code is to define a function that completes a larger set of commands with a single call."
    } else {
        
    }

    
    
    return updateAssessment(successMessage: success, failureHints: hints, solution: solution)
}

