// 
//  Assessments.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
let solution: String? = nil

import PlaygroundSupport
public func assessmentPoint() -> AssessmentResults {
    
    let checker = ContentsChecker(contents: PlaygroundPage.current.text)
    
    var success = "### Your function skills are growing! \nYou're actually writing your own functions! Functions let you simplify complicated actions. \n\n[**Next Page**](@next)"

    var hints = [
        "Your [function](glossary://function) should first collect a gem, then move forward, then toggle a switch.",
        "In this challenge, you'll need to use your function in several different places around the puzzle world.",
        "This puzzle is a **challenge** and has no provided solution. Strengthen your coding skills by creating your own approach to solving it."

        ]

    
    let customFunction = checker.customFunctions.first ?? ""
    if checker.didUseForLoop || checker.didUseWhileLoop {
        success = "### Amazing! \nWhat a surprise! You used a loop to solve this puzzle. You've become a coding wizard! \n[**Next Page**](@next)"
    } else if checker.functionCallCount(forName: customFunction) == 0 {
        success = " ### Congrats! \nYou solved the puzzle, but you used \(checker.calledFunctions.count) commands! Try defining your own [function](glossary://function) using `func name() {}`, and call it to solve the puzzle. You won't need to use as many commands, and your code will be more readable. You can also go to the [**Next Page**](@next), if you like."
        hints[0] = "Try writing your own function to solve the puzzle. First give your function a name, then [define](glossary://define) it with commands to collect a gem, move forward, and toggle open a switch."
        
    } else if world.commandQueue.containsIncorrectCollectGemCommand() {
        hints[0] = "Oops, you called `collectGem()` when no gem was present! This is actually a bug in your program - you should only collect a gem if one is present on that tile."
    } else if checker.numberOfStatements > 18 {
        hints[0] = "You're making good progress toward solving the puzzle, but you can be even more efficient with your code! You've used \(checker.calledFunctions.count) commands, but you can solve this puzzle with 16 or fewer commands. To make your code more efficient, [define](glossary://define) a function that you can reuse, then [call](glossary://call) it in your code. You can also move on to the [**Next Page**](@next), if you like."
    } else if checker.functionCallCount(forName: customFunction) < 4 {
        hints[0] = "To get the most our of your function, be sure to call it in all four locations that have a gem and a switch."
    }
 



    return updateAssessment(successMessage: success, failureHints: hints, solution: solution)
}



