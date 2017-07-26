// 
//  Assessments.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
let success = "### Fantastic! \nYou used the right commands, in the right order, to make Byte complete the task. You’ve got this! \n\n[**Next Page**](@next)"

let solution = "```swift\nmoveForward()\nmoveForward()\nturnLeft()\nmoveForward()\ncollectGem()\nmoveForward()\nturnLeft()\nmoveForward()\nmoveForward()\ntoggleSwitch()\n```"

import PlaygroundSupport
public func assessmentPoint() -> AssessmentResults {
    let checker = ContentsChecker(contents: PlaygroundPage.current.text)
    
var hints = [
    "Find the switch—it’s the tile at the top of the second stairway.",
    "Use `moveForward()`, `turnLeft()`, and `collectGem()` just like you did before. When you reach the switch, use the `toggleSwitch()` command to tell Byte to toggle it."
]

    
    if world.commandQueue.containsIncorrectCollectGemCommand() {
        hints[0] = "Make sure you move Byte to the tile containing the gem before using `collectGem()`."
    }
    
    if world.commandQueue.containsIncorrectToggleCommand() {
        hints[0] = "Before you toggle the switch, move Byte to the switch tile at the top of the second stairway."
    }

    if checker.functionCallCount(forName: "collectGem") == 0 {
        hints[0] = "Make sure to collect the gem using the `collectGem` command."
    } else if checker.functionCallCount(forName: "toggleSwitch") == 0 && !world.commandQueue.containsIncorrectCollectGemCommand() {
        hints[0] = "After you've collected the gem, move Byte to the switch (the tile at the top of the second stairway). Then use `toggleSwitch()` to toggle it open."
    } else if world.commandQueue.containsIncorrectToggleCommand() && checker.functionCallCount(forName: "collectGem") == 1 && checker.numberOfStatements < 8 {
        hints[0] = "Remember, each `moveForward()` command moves Byte one tile forward. This is true even if you move up or down a stairway!"
    }
    
    

    
    
    
    return updateAssessment(successMessage: success, failureHints: hints, solution: solution)
}



