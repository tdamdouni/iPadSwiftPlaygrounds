// 
//  Assessments.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//

import Foundation


var solution: String? = nil

import PlaygroundSupport
public func assessmentPoint() -> AssessmentResults {
    let checker = ContentsChecker(contents: PlaygroundPage.current.text)
    
    var success = NSLocalizedString("### Great work! \n\nYou're writing and using your own functions. That's a major part of what it means to be a coder. With a [function](glossary://function) you can group commands together and [call](glossary://call) the function once to run the whole set of commands. Using functions makes code much more readable and understandable at a glance. \n\n[**Next Page**](@next)", comment:"Success message")
    
    var hints = [
        NSLocalizedString("Try to find the repeating patterns in the puzzle. For example, each row contains a three gems in a line.", comment:"Hint"),
        NSLocalizedString("Once you've identified a pattern of commands that your character will repeat, define your function using that set of commands. Then call your function any time you want to perform that pattern of behavior.", comment:"Hint"),
        NSLocalizedString("This puzzle is a **Challenge**. Challenges give you an opportunity to test your coding skills. Because challenges may be solved in different ways, a solution is not always provided for you. Instead, your goal is to think of your own approach.", comment:"Hint")
        
        ]
    let customFunction = checker.customFunctions.first ?? ""

    if checker.didUseForLoop || checker.didUseWhileLoop {
        success = NSLocalizedString("### Wow! \nNice work using a loop to solve this puzzle. You are clearly getting pretty good at this. \n\n[**Next Page**](@next)", comment:"Success message")
    } else if world.commandQueue.containsIncorrectCollectGemCommand(for: actor) {
        hints[0] = NSLocalizedString("Oops, you called `collectGem()` when no gem was present. This is a bug in your program—you should collect a gem only if one is present on the tile.", comment:"Hint")
    } else if checker.functionCallCount(forName: customFunction) == 0 {
        let format = NSLocalizedString("sd:chapter2.challenge2.noCustomFunctionSuccessMessage", comment: "Success message {number of commands used}")
        success = String.localizedStringWithFormat(format, checker.calledFunctions.count)
        hints[0] = NSLocalizedString("Define your function by giving it a name and a set of commands. Then be sure to [call](glossary://call) your function by tapping the function name in the shortcut bar.", comment:"Hint")
    } else if checker.numberOfStatements > 20 {  
        let format = NSLocalizedString("sd:chapter2.challenge2.inefficientSolutionSuccessMessage", comment: "Hint - {number of commands used}")
        hints[0] = String.localizedStringWithFormat(format, checker.calledFunctions.count)
    }
    
    
    
    return updateAssessment(successMessage: success, failureHints: hints, solution: solution)
}

