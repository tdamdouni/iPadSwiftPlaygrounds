// 
//  Assessments.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//

var solution: String? = nil

import PlaygroundSupport
public func assessmentPoint() -> AssessmentResults {
    let checker = ContentsChecker(contents: PlaygroundPage.current.text)
    
    var success = "### Great work! \n\nYou're writing and using your own functions. That's a major part of what it means to be a coder. With a [function](glossary://function) you can group commands together and [call](glossary://call) the function once to run the whole set of commands. Using functions makes code much more readable and understandable at a glance. \n\n[**Next Page**](@next)"
    
    var hints = [
        "Try to find the repeating patterns in the puzzle. For example, each row contains a three gems in a line.",
        "Once you've identified a pattern of commands that your character will repeat, define your function using that set of commands. Then call your function any time you want to perform that pattern of behavior.",
        "This puzzle is a **Challenge**. Challenges give you an opportunity to test your coding skills. Because challenges may be solved in different ways, a solution is not always provided for you. Instead, your goal is to think of your own approach."
        
        ]
    let customFunction = checker.customFunctions.first ?? ""

    if checker.didUseForLoop || checker.didUseWhileLoop {
        success = "### Wow! \nNice work using a loop to solve this puzzle. You are clearly getting pretty good at this. \n\n[**Next Page**](@next)"
    } else if world.commandQueue.containsIncorrectCollectGemCommand(for: actor) {
        hints[0] = "Oops, you called `collectGem()` when no gem was present. This is a bug in your program—you should collect a gem only if one is present on the tile."
    } else if checker.functionCallCount(forName: customFunction) == 0 {
        success = "### Getting there! \nYou found a solution to the puzzle, but you didn't [define](glossary://define) your own function. You used \(checker.calledFunctions.count) commands, but you can solve the puzzle with fewer lines of code by using a repeatable set of code in a function. Try defining your own [function](glossary://function) using `func name() {}` and giving it a set of commands, then calling it to solve the puzzle. You won't need to use as many commands, and your code will be more readable."
        hints[0] = "Define your function by giving it a name and a set of commands. Then be sure to [call](glossary://call) your function by tapping the function name in the shortcut bar."
    } else if checker.numberOfStatements > 20 {
        hints[0] = "You've used \(checker.calledFunctions.count) commands, but you can solve this puzzle as few as 12. One way to write shorter, more readable code is to define a function that completes a larger set of commands with a single call."
    }
    
    
    
    return updateAssessment(successMessage: success, failureHints: hints, solution: solution)
}

