// 
//  Assessments.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//


let solution = "```swift\nfunc turnAround() {\n    turnLeft()\n    turnLeft()\n}\n\nfunc solveStair() {\n    moveForward()\n    collectGem()\n    turnAround()\n    moveForward()\n    turnLeft()\n}\n\nsolveStair()\nsolveStair()\nsolveStair()\nsolveStair()\n```"

import PlaygroundSupport
public func assessmentPoint() -> AssessmentResults {
    let checker = ContentsChecker(contents: PlaygroundPage.current.text)
    
    var success = "### Incredible job! \nYou’ve broken a large problem into smaller, more manageable pieces. This process is called **[decomposition](glossary://decomposition)**. Combining functions to solve a big problem is called **[composition](glossary://composition)**. \nCongratulations, you're becoming a great problem solver! \n\n[Next Page](@next)"
    var hints = [
        "First, [define](glossary://define) your `solveStair()` function to walk up a staircase, collect a gem, turn around, and move back to the center.",
        "Make sure to use `turnAround()` in your `solveStair()` function.",
        "After you [define](glossary://define) `solveStair()`, [call](glossary://call) the function to collect all four gems."
    ]

    
    if checker.functionCallCount(forName: "solveStair") == 0 && checker.functionCallCount(forName: "turnAround") > 0 {
        success = "### Almost! \nYou used the `turnAround()` function, but you didn't [call](glossary://call) `solveStair()`! The process of decomposition allows you to break a bigger problem down into smaller pieces. In this case, you can use `turnAround()` to [define](glossary://define) `solveStair()`, for a solution that's understandable and reusable. Try again, or move on to the [Next Page](@next)."
        hints[0] = "You called `turnAround()`, but you didn't [call](glossary://call) `solveStair()`. Use `turnAround()` to [define](glossary://define) `solveStair()`; then you can [call](glossary://call) `solveStair()` four times to collect the gem on each staircase."
    } else if checker.functionCallCount(forName: "solveStair") > 2 && checker.functionCallCount(forName: "turnAround") > 1 {
        success = "### Incredible job! \nYou’ve broken a large problem into smaller, more manageable pieces. This process is called **[decomposition](glossary://decomposition)**. Combining functions to solve a big problem is called **[composition](glossary://composition)**. \nCongratulations, you're becoming a great problem solver! \n\n[Next Page](@next)"
        hints[0] = "You're on the right path! Figure out which commands to use to [define](glossary://define) `solveStair()`, then [call](glossary://call) that function multiple times for each staircase and collect all four gems."
    } else if checker.numberOfStatements > 16 && checker.functionCallCount(forName: "solveStair") < 1 {
        success = "You're getting there \nRemember, the reason to use functions is to break a bigger problem into smaller, more manageable pieces. Try solving the puzzle again, but this time [define](glossary://define) the `solveStair()` function and use it to gather a gem from a staircase. You'll need to move forward, collect a gem, turn around, then move back to the center."
        hints[0] = "Try defining and calling the `solveStair()` function to decrease the number of commands you need."
    } else if checker.didUseForLoop || checker.didUseWhileLoop {
        success = "### Incredible! \nUsing a loop to solve this puzzle is a great approach! You must know a thing or two about code! \n\n[Next Page](@next)"
    }
    
    
    
    return updateAssessment(successMessage: success, failureHints: hints, solution: solution)
}
