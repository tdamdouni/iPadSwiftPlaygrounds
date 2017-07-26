// 
//  Assessments.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
let success = "### Great job! \nYou’ve written more complex code, and you’ve learned that the order of the commands is important.\n\nIncluding a command for each step is important too; if you accidentally leave one out, Byte won’t be able to finish the task. \n\n[**Next Page**](@next)"

let solution = "```swift\nmoveForward()\nmoveForward()\nturnLeft()\nmoveForward()\nmoveForward()\ncollectGem()\n```"

import PlaygroundSupport
public func assessmentPoint() -> AssessmentResults {
    let checker = ContentsChecker(contents: PlaygroundPage.current.text)

var hints = [
    "To reach the gem, Byte needs to move forward two tiles, then turn left, then move forward two more tiles.",
    "The ``moveForward()`` [command](glossary://command) moves Byte ahead only one tile. You need to use the command twice at the end before Byte can collect the gem."
]
    
    let oneTileMovement = [
        "moveForward",
        "turnLeft",
        "moveForward",
        "collectGem"
    ]
    
    let oneTileMovementNoCollect = [
        "moveForward",
        "turnLeft",
        "moveForward",
    ]
    
    if world.commandQueue.containsIncorrectCollectGemCommand() {
        hints[0] = "For the `collectGem()` command to work, you must move Byte to the tile with the gem."
    }
    
    if checker.functionCallCount(forName: "turnLeft") == 0 {
        hints[0] = "Remember, you need to use the new command, `turnLeft()`, to reach the gem."
    } else if checker.calledFunctions == oneTileMovement {
        hints[0] = "Oops! Every `moveForward()` command moves your character forward only one tile. To move Byte forward two tiles, you need **two** `moveForward()` commands."
    } else if checker.calledFunctions == oneTileMovementNoCollect {
        hints[0] = "Oops! Every `moveForward()` command moves Byte forward only one tile. To move Byte forward two tiles, you need **two** `moveForward()` commands. And don't forget to collect the gem!"
    }

    


    return updateAssessment(successMessage: success, failureHints: hints, solution: solution)
}

