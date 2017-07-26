// 
//  Assessments.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//

import Foundation

let solution = "```swift\nmoveForward()\nmoveForward()\nmoveForward()\ncollectGem()\n```"


var success = NSLocalizedString("### Congratulations! \nYou’ve written your first lines of [Swift](glossary://Swift) code. \n\nByte performed the commands you wrote and did exactly what you asked, in exactly the order that you specified. \n\n[**Next Page**](@next)", comment:"Success message")


import PlaygroundSupport
public func assessmentPoint() -> AssessmentResults {
let checker = ContentsChecker(contents: PlaygroundPage.current.text)

    var hints = [
        NSLocalizedString("Remember, you need to make Byte move forward and collect the gem, using commands in the shortcut bar.", comment:"Hint"),
        NSLocalizedString("First tap `moveForward()` three times, and then tap `collectGem()`. If you have problems with your code, you can start over by tapping the three-dot icon at the top of the page and then tapping Reset.", comment:"Hint")
    ]


    
    
    if checker.numberOfStatements == 0 {
        hints[0] = NSLocalizedString("You need to enter some commands. First tap the area that says \"Tap to enter code\" then use `moveForward()` and `collectGem()` to solve the puzzle.", comment:"Hint")
    } else if checker.numberOfStatements < 3 {
        hints[0] = NSLocalizedString("Oops! Every `moveForward()` command moves Byte forward only one tile. To move forward three tiles, you need **three** `moveForward()` commands.", comment:"Hint")
    } else if checker.functionCallCount(forName: "collectGem") == 0 {
        hints[0] = NSLocalizedString("You forgot to collect the gem. When you're on the tile with the gem, use `collectGem()`.", comment:"Hint")
    }
    
    if world.commandQueue.containsIncorrectCollectGemCommand() {
        hints[0] = NSLocalizedString("For the `collectGem()` command to work, Byte needs to be on the tile with the gem.", comment:"Hint")
    }
    
    if world.commandQueue.containsIncorrectMoveForwardCommand() {
        success = NSLocalizedString("### Great work! \nYou’ve written your first lines of [Swift](glossary://Swift) code. \n\nDid you notice how Byte performed all the commands you wrote, even though the `moveForward()` command almost made Byte fall off the world? \n\nEven though you had extra commands in your solution, Byte still solved the puzzle correctly. Next time, try using only the commands you need.  \n\n[**Next Page**](@next)", comment:"Success message")
    }
    
    return updateAssessment(successMessage: success, failureHints: hints, solution: solution)
}
