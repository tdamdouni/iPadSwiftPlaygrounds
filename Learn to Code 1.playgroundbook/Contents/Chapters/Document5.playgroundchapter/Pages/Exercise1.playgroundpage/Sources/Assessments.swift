// 
//  Assessments.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
let solution = "```swift\nfor i in 1 ... 4 {\n   moveForward()\n   if !isOnGem {\n      turnLeft()\n      moveForward()\n      moveForward()\n      collectGem()\n      turnLeft()\n      turnLeft()\n      moveForward()\n      moveForward()\n      turnLeft()\n   } else {\n      collectGem()\n   }\n}\n```"


import PlaygroundSupport
public func assessmentPoint() -> AssessmentResults {
    let checker = ContentsChecker(contents: PlaygroundPage.current.text)
    pageIdentifier = "Using_the_NOT_operator"

    
    var success = "### You're amazing! \nUsing the [logical NOT operator](glossary://logical%20NOT%20operator), you reversed a [Boolean](glossary://Boolean) value, allowing you to check the opposite of a condition like `isOnGem` or `isOnClosedSwitch`. What you're saying is that \"if NOT on a gem, do this.\" \n\n[**Next Page**](@next)"
    var hints = [
        "When there is **not** a gem on the top platform, a stairway extends from that tile. Use the condition \"if your character is NOT on a gem\" to determine what to do in that situation.",
        "Use a condition that looks like this: `!isOnGem`",
        
        ]
    
    let runCount = currentPageRunCount
    
    if checker.didUseConditionalStatement && runCount > 3 {
        hints[0] = "Add an `if` statement that looks like this:\n\n```swift\n        if !isOnGem {\n            CODE\n        } else {\n            collectGem()\n        }```"
    } else if !checker.didUseConditionalStatement {
        hints[0] = "First, add an `if` statement inside your `for` loop that checks whether your character is NOT on a gem."
        success = "### Use conditional code. \nAlthough you solved the puzzle this time, if you rerun your code, it probably won't work again! /nTry using conditional code that will work in many different situations."
    }
    
    let contents = checker.conditionalNodes.map { $0.condition }
    
    for element in contents {
        if !element.contains("!") && checker.didUseConditionalStatement {
            hints[0] = "Make sure your condition looks like this, with no spaces between the ! and `isOnGem`: \n\n`!isOnGem`."
        }
        
    }
    
    return updateAssessment(successMessage: success, failureHints: hints, solution: solution)
}
