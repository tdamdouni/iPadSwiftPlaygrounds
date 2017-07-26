// 
//  Assessments.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//

import Foundation

let solution = "```swift\nfor i in 1 ... 12 {\n   if isBlocked || isBlockedLeft {\n      turnRight()\n      moveForward()\n   } else {\n      moveForward()\n   }\n}\ncollectGem()"



import PlaygroundSupport
public func assessmentPoint() -> AssessmentResults {
    let checker = ContentsChecker(contents: PlaygroundPage.current.text)
    pageIdentifier = "Checking_this_OR_that"

    
    var success = NSLocalizedString("### Great logic! \nYou know how to use all of the logical operators, including [`!`](glossary://logical%20NOT%20operator), [`&&`](glossary://logical%20AND%20operator), and [`||`](glossary://logical%20OR%20operator). You can now be highly specific with how you run your conditional code. This will come in handy as you make your code increasingly more adaptable. \n\n[**Next Page**](@next)", comment:"Success message")
    var hints = [
        NSLocalizedString("Add an `if` statement inside the `for` loop, then add your first condition. In the shortcut bar, tap the `||` operator and add your second condition. Also create an `else` block to move forward if both conditions are false.", comment:"Hint"),
        NSLocalizedString("Your `if` statement should check whether your character is blocked in front or on the left.", comment:"Hint"),
        NSLocalizedString("Your `if` statement might look something like this:\n\n```swift\nif isBlocked || isBlockedLeft {\n    Run this code if the condition is true\n} else {\n    Run this code if the condition is false\n}", comment:"Hint")
    ]

    
    let runCount = currentPageRunCount
    
    if checker.didUseConditionalStatement && runCount > 3 {
        hints[0] = NSLocalizedString("Your `if` statement might look something like this:\n\n```swift\nif isBlocked || isBlockedLeft {\n    Run this code if the condition is true\n} else {\n    Run this code if the condition is false\n}", comment:"Hint")
    } else if !checker.didUseConditionalStatement {
        success = NSLocalizedString("### Oops \nYou didn't use conditional code. You got the right result, but if you invest a little time in learning these skills now, the code you write later will be much more effective. Give it a try using an `if` statement and the `||` operator.", comment:"Success message")
    }
    
    let contents = checker.conditionalNodes.map { $0.condition }
    let usesOrOperator = contents.contains {
        return $0.contains("||")
    }
    
    
    if !usesOrOperator && checker.didUseConditionalStatement {
        hints[0] = NSLocalizedString("Use the `||` operator to check whether either of two conditions is true. Notice that if your character is blocked either in front *or* on the left, the path calls for `turnRight()` and `moveForward()` commands.", comment:"Hint")
        success = NSLocalizedString("### Nice! \nYou solved the puzzle using conditional code. Try improving your coding skills by solving the puzzle with the `||` operator, as well.", comment:"Success message")
    } else if usesOrOperator && checker.didUseConditionalStatement {
        hints[0] = NSLocalizedString("If your character is blocked in front or on the left, turn right and move forward. Otherwise, just move forward.", comment:"Hint")
        success = NSLocalizedString("### Great logic! \nYou know how to use all of the logical operators, including [`!`](glossary://logical%20NOT%20operator), [`&&`](glossary://logical%20AND%20operator), and [`||`](glossary://logical%20OR%20operator). You can now be highly specific with how you run your conditional code. This will come in handy as you make your code increasingly more adaptable. \n\n[**Next Page**](@next)", comment:"Success message")
    }
    
    
    
    return updateAssessment(successMessage: success, failureHints: hints, solution: solution)
}
