// 
//  Assessments.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
var solution = "```swift\nfunc navigateAroundWall() {\nif isBlockedRight && isBlocked {\n    turnLeft()\n} else if isBlockedRight {\n    moveForward()\n} else {\n    turnRight()\n    moveForward()\n}\nif isOnGem {\n    collectGem()\n}\n}\n\nwhile !isOnClosedSwitch {\n    navigateAroundWall()\n}\ntoggleSwitch()\n"

import PlaygroundSupport
public func assessmentPoint() -> AssessmentResults {
    pageIdentifier = "Tweaking_Your_Algorithm"
    
    
    let success = "### Super impressive! \nYou've tweaked an existing algorithm to make it work in different circumstances. This is the power of code—creating programs that solve a problem in many different situations. For example, search engine algorithms can filter over a billion websites to give you the results that you'll be most interested in, no matter what you search for. \n\n[Next Page](@next)"
    var hints = [
            "Take the existing code from the previous exercise, and see if you can make it work to solve this slightly different puzzle. Notice that the walls now twist and turn a little more, so you'll need to account for that change in your algorithm.",
            "Combining `while` loops, `if` statements, and logical operators is a powerful way to guide Byte around the walls. Think through the rules that you want Byte to follow, and then write those rules in code.",
            "You may want to take a different action when Byte is blocked in the front and on the right, compared with when Byte is blocked only on the right."
    ]
    
    
//    switch currentPageRunCount {
//        
//    case 2..<4:
//        hints[0] = "To get Byte to navigate around each wall, you need to figure out what to do in several situations.\n\nIf Byte is blocked on the right and in front...\nIf Byte is blocked on the right...\nIf Byte is not blocked on the right..."
//    case 4..<6:
//        hints[0] = "Again, you'll need to run your code while Byte is not on the switch at the furthest corner of the puzzle world. You can use a `while` loop or nested `while` loops to accomplish this."
//    case 5..<9:
//        hints[0] = "When your code doesn't work, try to figure out where it's failing. Learning from failed attempts is the best way to get better at something."
//        
//    default:
//        break
//        
//    }
    
    
    
    
    return updateAssessment(successMessage: success, failureHints: hints, solution: solution)
}
