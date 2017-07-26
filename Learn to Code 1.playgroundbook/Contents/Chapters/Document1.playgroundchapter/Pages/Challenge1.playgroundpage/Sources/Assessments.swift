// 
//  Assessments.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
var success = "### Great job \nYou've solved your first challenge! \n\n[**Next Page**](@next)"

let solution: String? = nil



import PlaygroundSupport
public func assessmentPoint() -> AssessmentResults {
    let checker = ContentsChecker(contents: PlaygroundPage.current.text)
    
    var hints = [
        "Start by making Byte move up the ramp. Then have Byte turn left, toggle open the switch, and walk down to the portal.",
        "While moving through a portal, Byte maintains the same direction on arrival at the destination portal.",
        "This puzzle is a **Challenge**. Challenges improve your coding skills by allowing you to figure out your own solutions."

        ]
    
    if world.commandQueue.containsIncorrectToggleCommand(for: actor) {
        hints[0] = "Move Byte onto the tile with the switch before you use the `toggleSwitch()` command."
    }
    
    if checker.functionCallCount(forName: "toggleSwitch") == 0 && checker.functionCallCount(forName: "collectGem") == 0 {
        hints[0] = "First, move Byte to the switch and toggle it using `toggleSwitch()`."
    } else if !world.commandQueue.containsIncorrectToggleCommand(for: actor) && checker.functionCallCount(forName: "collectGem") == 0 {
        hints[0] = "After toggling the switch, you need to move Byte through the portal. Whichever direction Byte faces when entering the portal, Byte will face the same direction after exiting the destination portal."
    } else if !world.commandQueue.containsIncorrectToggleCommand(for: actor) && checker.numberOfStatements < 13 {
        hints[0] = "In this puzzle, you might have to move forward multiple times to get to where you want to go. For example, to move three tiles forward, you need to use three `moveForward()` commands."
    }
    
    
    let queue = world.commandQueue
    if let openSwitchIndex = queue.indexOfFirstCorrectToggle(), let collectGemIndex = queue.indexOfFirstCollectedGem() {
        if openSwitchIndex > collectGemIndex {
            success = "You solved the puzzle, but you used your commands in the wrong order! First you should toggle the switch, then move through the portal and collect the gem."
        }
    }
    
    return updateAssessment(successMessage: success, failureHints: hints, solution: solution)
}





