// 
//  Assessments.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
let solution = "```swift\nwhile !isOnGem {\n    moveForward()\n    if isOnClosedSwitch && isBlocked {\n        toggleSwitch()\n        turnLeft()\n    } else if isOnClosedSwitch {\n        toggleSwitch()\n        turnRight()\n    }\n}\ncollectGem()"

import PlaygroundSupport
public func assessmentPoint() -> AssessmentResults {
    pageIdentifier = "Which_Way_To_Turn?"
    
    
    let success = "### Brilliant! \nNow you're creating your own [algorithms](glossary://algorithm) from scratch. How cool is that? \n\n[**Next Page**](@next)"
    var hints = [
        "Each time you reach a switch, you need to decide whether to turn left or right.",
        "Be sure to run your [algorithm](glossary://algorithm) until your character reaches the gem at the end of the puzzle.",
        "Remember to use the [&& operator](glossary://logical%20AND%20operator) to check multiple conditions with a single [`if` statement](glossary://if%20statement)."
    ]
    
    
    switch currentPageRunCount {
        
    case 2..<4:
        hints[0] = "You can use nested `while` loops in this puzzle. Make the *outer* loop run while your character isn’t on a gem. Make the *inner* loop move your character forward until reaching the next switch."
    case 4..<6:
        hints[0] = "Your algorithm should turn your character to the left if on a switch and blocked, and to the right if just on a switch but not blocked."
    case 5..<9:
        hints[0] = "Trying a lot of different approaches is the best way to find one that works. Sometimes the people who fail the most in the beginning are those who end up succeeding in the end."
    default:
        break
        
    }
    
    
    
    
    return updateAssessment(successMessage: success, failureHints: hints, solution: solution)
}
