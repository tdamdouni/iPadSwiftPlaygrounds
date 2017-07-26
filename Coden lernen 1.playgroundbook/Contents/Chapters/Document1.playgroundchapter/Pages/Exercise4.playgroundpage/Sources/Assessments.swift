// 
//  Assessments.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//

import Foundation

let success = NSLocalizedString("### Congratulations! \nYou found a bug in the code. All the right commands were written down, but they were in the wrong order. You “debugged” this code by rearranging the commands until you solved the puzzle. \n\n[**Next Page**](@next) ", comment:"Success message")


let solution = "```swift\nmoveForward()\nmoveForward()\nturnLeft()\nmoveForward()\ncollectGem()\nmoveForward()\ntoggleSwitch()\n```"

import PlaygroundSupport
public func assessmentPoint() -> AssessmentResults {
    let checker = ContentsChecker(contents: PlaygroundPage.current.text)
    
    var hints = [
        NSLocalizedString("Take a minute to think through what the correct sequence of commands would be, and rearrange the existing code to match that sequence.", comment:"Hint"),
        NSLocalizedString("Fix the bug by changing the order of commands so that Byte collects the gem and toggles open the switch.", comment:"Hint"),
        ]
    
    let defaultContents = [
        "moveForward",
        "turnLeft",
        "moveForward",
        "moveForward",
        "collectGem",
        "moveForward",
        "toggleSwitch"
    ]

    if checker.numberOfStatements > 7 {
        hints[0] = NSLocalizedString("You've added more commands than you need. To rearrange existing code, tap once on a command to select it, then tap and drag it to a new location.", comment:"Hint")
    } else if world.commandQueue.containsIncorrectCollectGemCommand() {
        hints[0] = NSLocalizedString("Did you notice that bug? Byte tried to collect a gem that wasn't there! Rearrange the commands so that Byte is standing on a tile with a gem before using `collectGem()`.", comment:"Hint")
    } else if world.commandQueue.containsIncorrectCollectGemCommand() && world.commandQueue.containsIncorrectToggleCommand() {
        hints[0] = NSLocalizedString("Oops, you tried to collect a gem and toggle a switch, but Byte wasn't on the right tiles! Can you get Byte to the correct tiles before using these commands?", comment:"Hint")
    } else if checker.calledFunctions == defaultContents {
        hints[0] = NSLocalizedString("Did you notice when the bug occurred? To rearrange your code, tap once on a command to select it, then tap and drag it to a new location.", comment:"Hint")
        
    }
    

    return updateAssessment(successMessage: success, failureHints: hints, solution: solution)
}




