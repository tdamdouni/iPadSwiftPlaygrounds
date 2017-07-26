// 
//  Assessments.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//

import Foundation

let solution = "```swift\nfunc collectOrToggle() {\n   if isOnGem {\n      collectGem()\n   } else if isOnClosedSwitch {\n      toggleSwitch()\n   }\n}\n\nfunc solveRow() {\n   moveForward()\n   moveForward()\n   collectOrToggle()\n   moveForward()\n   moveForward()\n   collectOrToggle()\n}\nsolveRow()\nturnLeft()\nmoveForward()\nmoveForward()\nturnLeft()\nsolveRow()\nturnRight()\nmoveForward()\nturnRight()\nsolveRow()\n```"

import PlaygroundSupport
public func assessmentPoint() -> AssessmentResults {
    let checker = ContentsChecker(contents: PlaygroundPage.current.text)
    
    
    let success = NSLocalizedString("### You're really getting it! \nUsing functions that contain [``if`` statements](glossary://if%20statement) is another way to make code both *reusable* and *adaptable*. You can [call](glossary://call) the same [function](glossary://function) again and again, and have it automatically adapt to do the right thing each time. \n\n[**Next Page**](@next)", comment:"Success message")
    var hints = [
                    NSLocalizedString("There's a [function](glossary://function) already set up for you, so all you need to do is put an `if else` statement inside it.", comment:"Hint"),
                    NSLocalizedString("Use `isOnGem` to check for a gem, and `isOnClosedSwitch` to check for a closed switch.", comment:"Hint"),
                    NSLocalizedString("Use `collectGem()` only if your character is on a gem, and `toggleSwitch()` only if your character is on a closed switch.", comment:"Hint"),
                    NSLocalizedString("After you've filled in the `collectOrToggle()` function, move Byte to each location and call the function.", comment:"Hint"),
                    ]
    
    if checker.functionCallCount(forName: "collectOrToggle") < 1 {
        hints[0] = NSLocalizedString("[Define](glossary://define) your `collectOrToggle()` function using conditional code to toggle a switch if your character is on a closed switch, or collect a gem if your character is on a gem.", comment:"Hint")
    }
    
    
    return updateAssessment(successMessage: success, failureHints: hints, solution: solution)
}
