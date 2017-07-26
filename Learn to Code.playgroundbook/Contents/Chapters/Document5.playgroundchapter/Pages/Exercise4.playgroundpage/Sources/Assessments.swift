// 
//  Assessments.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
let solution = "```swift\nfunc collectOrToggle() {\n    moveForward()\n    moveForward()\n    if isOnGem {\n        collectGem()\n    } else if isOnClosedSwitch {\n        toggleSwitch()\n    }\n}\ncollectOrToggle()\ncollectOrToggle()\nturnLeft()\nmoveForward()\nmoveForward()\nturnLeft()\ncollectOrToggle()\ncollectOrToggle()\nturnRight()\nmoveForward()\nturnRight()\ncollectOrToggle()\ncollectOrToggle()\n```"

import PlaygroundSupport
public func assessmentPoint() -> AssessmentResults {
    let checker = ContentsChecker(contents: PlaygroundPage.current.text)
    
    
    let success = "### You're pretty smart! \nUsing functions that contain [``if`` statements](glossary://if%20statement) is another way to make code both *reusable* and *adaptable*. You can [call](glossary://call) the same [function](glossary://function) again and again, and have it automatically adapt to do the right thing each time. \n\n[Next Page](@next)"
    var hints = [
                    "There's a [function](glossary://function) already set up for you, so all you need to do is put an `if else` statement inside it.",
                    "Use `isOnGem` to check for a gem, and `isOnClosedSwitch` to check for a closed switch.",
                    "Use `collectGem()` only if Byte is on a gem, and `toggleSwitch()` only if Byte is on a closed switch.",
                    "After you've filled in the `collectOrToggle()` function, move Byte to each location and call the function.",
                    ]
    
    if checker.functionCallCount(forName: "collectOrToggle") < 1 {
        hints[0] = "[Define](glossary://define) your `collectOrToggle()` function using conditional code to toggle a switch if Byte is on a closed switch, or collect a gem if Byte is on a gem."
    }
    
    
    return updateAssessment(successMessage: success, failureHints: hints, solution: solution)
}
