// 
//  Assessments.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
let success = "### Way to go! \nBy combining three left turns, you enabled your character to turn right, even though there's no [command](glossary://command) for that. This is called [composition](glossary://composition), where you combine existing code to complete a new task.  \n\n[**Next Page**](@next)"


let solution = "```swift\nmoveForward()\nmoveForward()\nmoveForward()\nturnLeft()\nturnLeft()\nturnLeft()\nmoveForward()\nmoveForward()\nmoveForward()\ncollectGem()\n```"


import PlaygroundSupport
public func assessmentPoint() -> AssessmentResults {
    let checker = ContentsChecker(contents: PlaygroundPage.current.text)
    
    
    var hints = [
        "First, move to the tile where you need your character to turn right. Then use a combination of existing commands to turn in that direction.",
        "Think about how you might use the `turnLeft()` command to turn and face the opposite direction. This might give you a clue for how to turn right.",
        "If you turn left enough times, you'll eventually turn around.",
        ]
    
    if checker.functionCallCount(forName: "turnLeft") == 1 {
        hints[0] = "Remember, you need your character to turn right, even though there's no `turnRight()` command. You need to use an existing command to do this, and you may need to use it more than once."
    } else if checker.functionCallCount(forName: "turnLeft") == 2 {
        hints[0] = "Notice how turning left twice turns you around to face the opposite direction? What would happen if you turned left one more time?"
    } else if checker.functionCallCount(forName: "turnLeft") == 4 {
        hints[0] = "Oops! Turning left four times turned your character all the way around. If you stopped at three `turnLeft()` commands, what direction would your character be facing?"
    }
    
    return updateAssessment(successMessage: success, failureHints: hints, solution: solution)
}






