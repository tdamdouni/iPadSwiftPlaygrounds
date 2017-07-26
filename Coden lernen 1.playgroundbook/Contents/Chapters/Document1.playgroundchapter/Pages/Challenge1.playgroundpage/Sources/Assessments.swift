// 
//  Assessments.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//

import Foundation

var success = NSLocalizedString("### Great job \nYou've solved your first challenge! \n\n[**Next Page**](@next)", comment:"Success message")

let solution: String? = nil



import PlaygroundSupport
public func assessmentPoint() -> AssessmentResults {
    let checker = ContentsChecker(contents: PlaygroundPage.current.text)
    
    var hints = [
        NSLocalizedString("Start by making Byte move up the ramp. Then have Byte turn left, toggle open the switch, and walk down to the portal.", comment: "Hint"),
        NSLocalizedString("While moving through a portal, Byte maintains the same direction on arrival at the destination portal.", comment: "Hint"),
        NSLocalizedString("This puzzle is a **Challenge**. Challenges improve your coding skills by allowing you to figure out your own solutions.", comment: "Hint")

        ]
    
    if world.commandQueue.containsIncorrectToggleCommand(for: actor) {
        hints[0] = NSLocalizedString("Move Byte onto the tile with the switch before you use the `toggleSwitch()` command.", comment: "Hint")
    }
    
    if checker.functionCallCount(forName: "toggleSwitch") == 0 && checker.functionCallCount(forName: "collectGem") == 0 {
        hints[0] = NSLocalizedString("First, move Byte to the switch and toggle it using `toggleSwitch()`.", comment: "Hint")
    } else if !world.commandQueue.containsIncorrectToggleCommand(for: actor) && checker.functionCallCount(forName: "collectGem") == 0 {
        hints[0] = NSLocalizedString("After toggling the switch, you need to move Byte through the portal. Whichever direction Byte faces when entering the portal, Byte will face the same direction after exiting the destination portal.", comment: "Hint")
    } else if !world.commandQueue.containsIncorrectToggleCommand(for: actor) && checker.numberOfStatements < 13 {
        hints[0] = NSLocalizedString("In this puzzle, you might have to move forward multiple times to get to where you want to go. For example, to move three tiles forward, you need to use three `moveForward()` commands.", comment: "Hint")
    }
    
    
    let queue = world.commandQueue
    if let openSwitchIndex = queue.indexOfFirstCorrectToggle(), let collectGemIndex = queue.indexOfFirstCollectedGem() {
        if openSwitchIndex > collectGemIndex {
            success = NSLocalizedString("You solved the puzzle, but you used your commands in the wrong order! First you should toggle the switch, then move through the portal and collect the gem.", comment: "Success message")
        }
    }
    
    return updateAssessment(successMessage: success, failureHints: hints, solution: solution)
}





