// 
//  Assessments.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//

import Foundation

let solution: String? = nil


import PlaygroundSupport
public func assessmentPoint() -> AssessmentResults {
    let checker = ContentsChecker(contents: PlaygroundPage.current.text)
    pageIdentifier = "Spiral_of_NOT"

    
    var success = NSLocalizedString("### Congratulations!  \n\nYou're now ready to learn about the [logical AND operator](glossary://logical%20AND%20operator).\n\n[**Next Page**](@next)", comment:"Success message")
    
    var hints = [
        NSLocalizedString("Try using the `!` operator with the new condition, `isBlocked`.", comment:"Hint"),
        NSLocalizedString("If not blocked, then your character is free to move forward.", comment:"Hint"),
        NSLocalizedString("This puzzle is a **challenge** and has no provided solution. Strengthen your coding skills by creating your own approach to solving it.", comment:"Hint")

        
        ]
    
    let runCount = currentPageRunCount
    
    let contents = checker.conditionalNodes.map { $0.condition }
    let usesNotOperator = contents.contains {
        return $0.contains("!")
    }
    
    if checker.didUseConditionalStatement && runCount > 3 {
        hints[0] = NSLocalizedString("Add an `if` statement that looks like this:\n\n```swift\n        if !isBlocked {\n            moveForward()\n        } else {\n            turnLeft()\n        }", comment:"Hint")
    } else if !checker.didUseConditionalStatement {
        hints[0] = NSLocalizedString("First, add an `if` statement inside your `for` loop and use the ! operator with the `isBlocked` condition.", comment:"Hint")
        success = NSLocalizedString("### Use conditional code. \nAlthough you solved the puzzle this time, if you rerun your code, it probably won't work again! /nTry using conditional code that will work in many different situations.", comment:"Success message")
    }
    
    if usesNotOperator && checker.didUseConditionalStatement {
        success = NSLocalizedString("### Excellent! \nUsing the [logical NOT operator](glossary://logical%20NOT%20operator) with the condition `isBlocked`, you’ll always know when your character is NOT blocked and can move forward. This is an extremely handy trick to use in other places in your code. \n\n[**Next Page**](@next)", comment:"Success message")
    } else if !usesNotOperator && checker.didUseConditionalStatement {
        success = NSLocalizedString("You figured out how to solve the puzzle without using the `!` operator. Great work, finding a creative solution for a problem is the sign of a great coder! However, you should also figure out how to solve the puzzle using the `!` operator so that you'll know how to use it in future situations.", comment:"Success message")

    }
    
    
    
    return updateAssessment(successMessage: success, failureHints: hints, solution: solution)
}
