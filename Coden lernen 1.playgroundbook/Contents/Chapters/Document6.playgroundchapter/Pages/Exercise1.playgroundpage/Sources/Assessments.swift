// 
//  Assessments.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//

import Foundation

let solution = "```swift\nwhile isOnClosedSwitch {\n   toggleSwitch()\n   moveForward()\n}\n```"

import PlaygroundSupport
public func assessmentPoint() -> AssessmentResults {
    
    
    let success = NSLocalizedString("### Impressive! \nDidn't take you long to figure out how to use a [`while` loop](glossary://while%20loop). Now you can see how useful it is to run a block of code **while** a certain condition is true. Soon you'll be using `while` loops all the time! \n\n[**Next Page**](@next)", comment:"Success message")
    let hints = [
        NSLocalizedString("Add a condition to your [`while` loop](glossary://while%20loop) to run a block of code as long as that condition is true.", comment:"Hint"),
        NSLocalizedString("Here's one approach: while your character is on a closed switch, toggle that switch and move on to the next one.", comment:"Hint")
    ]
    
    
    return updateAssessment(successMessage: success, failureHints: hints, solution: solution)
}
