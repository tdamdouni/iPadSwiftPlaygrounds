// 
//  Assessments.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
let solution = "```swift\nwhile isOnClosedSwitch {\n    toggleSwitch()\n    moveForward()\n}\n```"

import PlaygroundSupport
public func assessmentPoint() -> AssessmentResults {
    
    
    let success = "### Impressive! \nDidn't take you long to figure out how to use a `while` loop. Now you can see how useful it is to run a block of code **while** a certain condition is true. Soon you'll be using `while` loops all the time! \n\n[Next Page](@next)"
    let hints = [
        "Add a condition to your `while` loop to run a block of code as long as that condition is true.",
        "Here's one approach: while Byte is on a closed switch, toggle that switch and move on to the next one."
    ]
    
    
    return updateAssessment(successMessage: success, failureHints: hints, solution: solution)
}
