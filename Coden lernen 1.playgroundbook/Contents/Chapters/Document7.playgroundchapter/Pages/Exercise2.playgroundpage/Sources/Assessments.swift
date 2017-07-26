// 
//  Assessments.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//

import Foundation

var solution = "```swift\nfunc navigateAroundWall() {\n    if isBlockedRight && isBlocked {\n        turnLeft()\n    } else if isBlockedRight {\n        moveForward()\n    }  else {\n        turnRight()\n        moveForward()\n    }\n}\n\nwhile !isOnClosedSwitch {\n    navigateAroundWall()\n    if isOnGem {\n        collectGem()\n    }\n}\ntoggleSwitch()"

import PlaygroundSupport
public func assessmentPoint() -> AssessmentResults {
    pageIdentifier = "Tweaking_Your_Algorithm"
    
    
    let success = NSLocalizedString("### Super impressive! \nYou've tweaked an existing [algorithm](glossary://algorithm) to make it work in different circumstances. This is the power of code—creating programs that solve a problem in many different situations. For example, search engine algorithms can filter over a billion websites to give you the results that you'll be most interested in, no matter what you search for. \n\n[**Next Page**](@next)", comment:"Success message")
    var hints = [
            NSLocalizedString("Take the existing code from the previous exercise, and see if you can make it work to solve this slightly different puzzle. Notice that you now have to take a different action when blocked both in front and on the right, instead of just being blocked on the right.", comment:"Hint"),
            NSLocalizedString("The first step is to tweak the `navigateAroundWall()` function so that it always follows the [right-hand rule](glossary://right-hand%20rule), keeping your character's right side against the wall at all times. To do this, add a condition to check for when your character `isBlockedRight && isBlocked`. In that situation, turn left to move around the obstacle.", comment:"Hint"),
    ]
    
    
    switch currentPageRunCount {
        
    case 2..<4:
        hints[0] = NSLocalizedString("To navigate around each wall, you need to figure out what to do in several situations.\n\nIf your character is blocked on the right and in front...\nIf your character is blocked on the right...\nIf your character is not blocked on the right...", comment:"Hint")
    case 4..<6:
        hints[0] = NSLocalizedString("Again, you'll need to run your code while your character is not on the switch at the furthest corner of the puzzle world. You can use a [`while` loop](glossary://while%20loop) or [nested](glossary://nest) `while` loops to accomplish this.", comment:"Hint")
    case 5..<9:
        hints[0] = NSLocalizedString("When your code doesn't work, try to figure out where it's failing. Learning from failed attempts is the best way to get better at something.", comment:"Hint")
        
    default:
        break
        
    }
    
    
    
    
    return updateAssessment(successMessage: success, failureHints: hints, solution: solution)
}
