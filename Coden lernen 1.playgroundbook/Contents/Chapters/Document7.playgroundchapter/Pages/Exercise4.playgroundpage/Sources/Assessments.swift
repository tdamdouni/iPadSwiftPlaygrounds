// 
//  Assessments.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//

import Foundation

let solution = "```swift\nwhile !isOnGem {\n    moveForward()\n    if isOnClosedSwitch && isBlocked {\n        toggleSwitch()\n        turnLeft()\n    } else if isOnClosedSwitch {\n        toggleSwitch()\n        turnRight()\n    }\n}\ncollectGem()"

import PlaygroundSupport
public func assessmentPoint() -> AssessmentResults {
    pageIdentifier = "Which_Way_To_Turn?"
    
    
    let success = NSLocalizedString("### Brilliant! \nNow you're creating your own [algorithms](glossary://algorithm) from scratch. How cool is that? \n\n[**Next Page**](@next)", comment:"Success message")
    var hints = [
        NSLocalizedString("Each time you reach a switch, you need to decide whether to turn left or right.", comment:"Hint"),
        NSLocalizedString("Be sure to run your [algorithm](glossary://algorithm) until your character reaches the gem at the end of the puzzle.", comment:"Hint"),
        NSLocalizedString("Remember to use the [&& operator](glossary://logical%20AND%20operator) to check multiple conditions with a single [`if` statement](glossary://if%20statement).", comment:"Hint")
    ]
    
    
    switch currentPageRunCount {
        
    case 1..<6:
        hints[0] = NSLocalizedString("Your algorithm should turn your character to the left if on a switch and blocked, and to the right if just on a switch but not blocked.", comment:"Hint")
    case 6..<9:
        hints[0] = NSLocalizedString("Trying a lot of different approaches is the best way to find one that works. Sometimes the people who fail the most in the beginning are those who end up succeeding in the end.", comment:"Hint")
    default:
        break
        
    }
    
    
    
    
    return updateAssessment(successMessage: success, failureHints: hints, solution: solution)
}
