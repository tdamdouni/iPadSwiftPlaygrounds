// 
//  Assessments.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
let success = "### Unbelievable! \nLook how fast you're becoming a coder! You've learned the secret: break these tough-looking problems into little pieces, then group your simple solutions into a [function](glossary://function) that you can [call](glossary://call) over and over again. \n\n[Next Page](@next)"

let solution = "```swift\nfunc moveAndCollectGems() {\n    moveForward()\n    collectGem()\n    moveForward()\n    collectGem()\n}\n\nfunc moveAndToggleSwitches() {\n    moveForward()\n    toggleSwitch()\n    moveForward()\n    toggleSwitch()\n}\n\nfunc turnAround() {\n    turnLeft()\n    turnLeft()\n    moveForward()\n    moveForward()\n    turnRight()\n    moveForward()\n    turnRight()\n}\n\nturnRight()\n\nfor i in 1 ... 5 {\n    moveAndCollectGems()\n    turnAround()\n}\n\nturnRight()\nmoveForward()\nmoveForward()\nmoveForward()\nturnRight()\n\nfor i in 1 ... 3 {\n    moveAndToggleSwitches()\n    turnAround()\n}\n"

import PlaygroundSupport
public func assessmentPoint() -> AssessmentResults {
    let checker = ContentsChecker(contents: PlaygroundPage.current.text)
    
    var hints = [
        "First, think of all of the tasks you can include in a function.",
        "How can you use `for` loops to repeat a set of functions that you've written?",
        ]
    
//    switch currentPageRunCount {
//        
//    case 3..<6:
//        hints[0] = "### Remember, this is a challenge! \nYou can skip it and come back later."
//    case 6..<12:
//        hints[0] = "Here's one way to solve the challenge:\n\n```swift\n func movePickUp() {\n    moveForward()\n    collectGem()\n    moveForward()\n    collectGem()\n }\n \n func movePlace() {\n    moveForward()\n    toggleSwitch()\n    moveForward()\n    toggleSwitch()\n }\n \n func turnAround() {\n    turnLeft()\n    turnLeft()\n    moveForward()\n    moveForward()\n    turnRight()\n    moveForward()\n    turnRight()\n }\n \n turnRight()\n \n for i in 1 ... 5 {\n    movePickUp()\n    turnAround()\n }\n \n turnRight()\n moveForward()\n moveForward()\n moveForward()\n turnRight()\n \n for i in 1 ... 3 {\n    movePickUp()\n    turnAround()\n }\n ```"
//    default:
//        break
//        
//    }
    
    
    
    return updateAssessment(successMessage: success, failureHints: hints, solution: solution)
}
