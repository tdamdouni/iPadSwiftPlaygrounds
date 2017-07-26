// 
//  Assessments.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
let success = "### Great job \nYou've solved your first challenge! \n\n[Next Page](@next)"

let solution = "```swift\nmoveForward()\nmoveForward()\nmoveForward()\nturnLeft()\nmoveForward()\nmoveForward()\ntoggleSwitch()\nmoveForward()\nmoveForward()\nturnLeft()\nmoveForward()\nmoveForward()\ncollectGem()\n```"



import PlaygroundSupport
public func assessmentPoint() -> AssessmentResults {
    let checker = ContentsChecker(contents: PlaygroundPage.current.text)
    
    var hints = [
        "Start by making Byte move up the ramp, then turn left, toggle open the switch, and walk down to the portal.",
        "While moving through a portal, Byte maintains direction and faces the same way on arrival at the destination portal.",
        ]
    
    if world.commandQueue.containsIncorrectToggleCommand() {
        hints[0] = "Move Byte onto the tile with the switch before you use the `toggleSwitch()` command."
    }
    
    if checker.functionCallCount(forName: "toggleSwitch") == 0 && checker.functionCallCount(forName: "collectGem") == 0 {
        hints[0] = "First, move Byte to the switch and toggle it using `toggleSwitch()`."
    } else if !world.commandQueue.containsIncorrectToggleCommand() && checker.functionCallCount(forName: "collectGem") == 0 {
        hints[0] = "After toggling the switch, you need to move Byte through the portal. Whichever direction Byte faces when entering the portal, Byte will face the same direction after exiting the destination portal."
    } else if !world.commandQueue.containsIncorrectToggleCommand() && world.commandQueue.containsIncorrectToggleCommand() && checker.numberOfStatements < 13 {
        hints[0] = "In this puzzle, you might have to move forward multiple times to get to where you want to go. For example, to move three tiles forward, you will need three `moveForward()` commands."
    }

    
    
    return updateAssessment(successMessage: success, failureHints: hints, solution: solution)
}





