// 
//  Assessments.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//

let solution = "```swift\nfunc turnRight() {\n   turnLeft()\n   turnLeft()\n   turnLeft()\n}\n\nmoveForward()\nturnLeft()\nmoveForward()\nmoveForward()\nturnRight()\nmoveForward()\nmoveForward()\nturnRight()\nmoveForward()\nmoveForward()\nturnRight()\nmoveForward()\nmoveForward()\nmoveForward()\nturnLeft()\nmoveForward()\ntoggleSwitch()\n"

import PlaygroundSupport
func evaluateContents(_ contents: String) -> (success: String, hints: [String]) {
    let checker = ContentsChecker(contents: contents)
    
    var hints = [
        "Remember, `turnRight()` is a combination of three left turns.",
        "Use `turnRight()` any time you want to make a right turn.",
        
        ]
    
    var success = "### You just wrote your first [function](glossary://function)! \nYou can now use functions to create new abilities. To create a new [function](glossary://function), give it a name, [define](glossary://define) it by giving it a set of commands. Then [call](glossary://call) the function to make it run. \n\n[**Next Page**](@next)"
    
    let expectedContents = [
        "turnLeft",
        "turnLeft",
        "turnLeft"
    ]
    
    
    let turnRightMoveForward = [
        "turnLeft",
        "turnLeft",
        "turnLeft",
        "moveForward"
    ]
    
    if !checker.function("turnRight", matchesCalls: expectedContents) {
        hints[0] = "First you need to [define](glossary://define) `turnRight()` correctly. To do this, tap within the curly braces of `turnRight()` and add three `turnLeft()` commands. Then use `turnRight()` to complete the puzzle."
        success = "### You're on your way! \nYou were able to solve the puzzle, but you didn't correctly [define](glossary://define) `turnRight()`! To improve your coding skills, go back and define `turnRight()` using three `turnLeft()` commands, then solve the puzzle again."
    } else if checker.functionCallCount(forName: "turnLeft") >= 4 {
        hints[0] = "After you define `turnRight()`you no longer have to call `turnLeft()` three times for each right turn. Instead, call `turnRight()` and three `turnLeft()` commands will run."
    } else if world.commandQueue.closedAnOpenSwitch() {
        hints[0] = "Remember, you want all the switches toggled open! If a switch is already open, just leave it as it is."
    }
    
    if checker.function("turnRight", matchesCalls: expectedContents) && checker.functionCallCount(forName: "turnRight") < 1 {
        success = "You [defined](glossary://define) your `turnRight()` function correctly, but you never used it to solve the puzzle! Once you have defined `turnRight()`, use it each time you need your character to turn right."
    }
    
    if checker.function("turnRight", matchesCalls: turnRightMoveForward) {
        success = "### You just wrote your first [function](glossary://function)! \nIn addition to turning right, however, your function also moves your character forward one tile. While this might work fine for this puzzle, you might not always want to move forward when you call `turnRight()`. Try going back and changing the `turnRight()` function so that the only thing it does is turn your character to the right."
    }
    if checker.didUseForLoop {
        success = "### You just wrote your first [function](glossary://function)! \nNice work using a [`for` loop](glossary://for%20loop) to write `turnRight`, you must really know your stuff! You can now use functions to create new abilities. To create a new [function](glossary://function), give it a name, [define](glossary://define) it by giving it a set of commands. Then [call](glossary://call) the function to make it run. \n\n[**Next Page**](@next)"
    }
    return (success, hints)
}
public func assessmentPoint() -> AssessmentResults {

    let (success, hints) = evaluateContents(PlaygroundPage.current.text)
    
    return updateAssessment(successMessage: success, failureHints: hints, solution: solution)
}
