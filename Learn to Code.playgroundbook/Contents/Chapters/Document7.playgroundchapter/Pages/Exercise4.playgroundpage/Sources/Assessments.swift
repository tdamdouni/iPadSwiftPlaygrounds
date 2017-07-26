// 
//  Assessments.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
let solution = "```swift\nwhile !isBlocked {\n    while !isOnGem {\n        moveForward()\n    }\n    collectGem()\n    turnLeft()\n}\n```"

import PlaygroundSupport
public func assessmentPoint() -> AssessmentResults {
    let checker = ContentsChecker(contents: PlaygroundPage.current.text)
    
    var hints = [
        "You need to write two loops. Make the first—the [outer loop](glossary://outer%20loop)—run while Byte is not blocked. Make the second—the [inner loop](glossary://inner%20loop)—move Byte forward while not on a gem. \n\nThe outer loop will continue to run the inner loop until the outer loop stops. In this way, the inner `while` loop runs continuously until the end condition is met.",
        "Your [outer `while` loop](glossary://outer%20loop) should look like this:\n```swift\n        while !isBlocked {\n        }\n"
        
    ]
    
    var  success = "### Now you're nesting! \nGreat work nesting loops. You can use nested loops in many different situations, running complex conditional code over and over until a condition is met. \n\nBe careful, however. If a `while` loop [Boolean](glossary://Boolean) condition is never false, your program will run forever in an *infinite loop*, which can make your computer freeze. \n\n[Next Page](@next)"
    
    if !checker.didUseWhileLoop {
        hints[0] = "First, tap `while` in the shortcut bar to add your **outer** loop. Then add a condition so that the loop will run while Byte is not blocked."
        success = "### Keep trying! \nYou managed to collect all the gems, but you did it without using `while` loops! To improve your coding skills, try going back and finding a solution that uses nested `while` loops."
    }
    
    
    loop: for node in checker.loopNodes {
        if !node.condition.contains("!isBlocked") && checker.didUseWhileLoop {
            hints[0] = "For your **outer** `while` loop, use `!isBlocked` as a condition so that your program continues running the **inner** loop for as long as Byte is not blocked."
            break loop
        } else if node.condition.contains("!isBlocked") && node.body.contains({ $0 is LoopNode }) {
            hints[0] = "In your inner loop, move forward until Byte is on a gem. Then use your outer loop to collect the gem and turn left.\n\n```swift\n            while !isBlocked {\n                while !isOnGem {\n                    CODE\n                }\n                CODE\n            }\n            ```"
            break loop
        } else if node.condition.contains("!isBlocked") {
            hints[0] = "After you've added the **outer** loop that runs while Byte is not blocked, add an **inner** loop that moves Byte forward while Byte is not on a gem.\n\nMake sure to collect the gem and then turn left. This code will go below the inner loop."
            
        }
    }
    
    
    
    
    return updateAssessment(successMessage: success, failureHints: hints, solution: solution)
}
