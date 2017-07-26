// 
//  Assessments.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//

import Foundation

let solution = "```swift\nfor i in 1 ... 4 {\n   moveForward()\n   if !isOnGem {\n      turnLeft()\n      moveForward()\n      moveForward()\n      collectGem()\n      turnLeft()\n      turnLeft()\n      moveForward()\n      moveForward()\n      turnLeft()\n   } else {\n      collectGem()\n   }\n}\n```"


import PlaygroundSupport
public func assessmentPoint() -> AssessmentResults {
    let checker = ContentsChecker(contents: PlaygroundPage.current.text)
    pageIdentifier = "Using_the_NOT_operator"

    
    var success: String = NSLocalizedString("### Nice work! \nYou were able to solve this problem without using the [logical NOT operator](glossary://logical%20NOT%20operator); congratulations on finding a creative solution! \n\nAs an added challenge, can you figure out a solution using the `!` operator? Learning to use `!` will improve your ability to write conditional code and solve problems creatively in the future.\n\n[**Next Page**](@next)", comment:"Success message")
    var hints = [
        NSLocalizedString("When there is **not** a gem on the top platform, a stairway extends from that tile. Use the condition \"if your character is NOT on a gem\" to determine what to do in that situation.", comment:"Hint"),
        NSLocalizedString("Use a condition that looks like this: `!isOnGem`", comment:"Hint"),
        
        ]
    
    let runCount = currentPageRunCount
    
    if checker.didUseConditionalStatement && runCount > 3 {
        hints[0] = NSLocalizedString("Add an `if` statement that looks like this:\n\n```swift\n        if !isOnGem {\n            CODE\n        } else {\n            collectGem()\n        }```", comment:"Hint")
    } else if !checker.didUseConditionalStatement {
        hints[0] = NSLocalizedString("First, add an `if` statement inside your `for` loop that checks whether your character is NOT on a gem.", comment:"Hint")
        success = NSLocalizedString("### Use conditional code. \nAlthough you solved the puzzle this time, if you rerun your code, it probably won't work again! /nTry using conditional code that will work in many different situations.", comment:"Success message")
    }
    
    let contents = checker.conditionalNodes.map { $0.condition }
    
    for element in contents {
        if !element.contains("!") && checker.didUseConditionalStatement {
            hints[0] = NSLocalizedString("Make sure your condition looks like this, with no spaces between the ! and `isOnGem`: \n\n`!isOnGem`.", comment:"Hint")
            break
        } else if element.contains("!") && checker.didUseConditionalStatement {
            success = NSLocalizedString("### You're amazing! \nUsing the [logical NOT operator](glossary://logical%20NOT%20operator), you reversed a [Boolean](glossary://Boolean) value, allowing you to check the opposite of a condition like `isOnGem` or `isOnClosedSwitch`. What you're saying is that \"if NOT on a gem, do this.\" \n\n[**Next Page**](@next)", comment:"Success message")
            break
            
        }
        
    }
    
    return updateAssessment(successMessage: success, failureHints: hints, solution: solution)
}
