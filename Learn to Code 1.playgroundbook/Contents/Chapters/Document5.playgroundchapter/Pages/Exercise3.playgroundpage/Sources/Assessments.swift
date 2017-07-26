// 
//  Assessments.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
let solution = "```swift\nfor i in 1 ... 12 {\n   if isBlocked || isBlockedLeft {\n      turnRight()\n      moveForward()\n   } else {\n      moveForward()\n   }\n}\ncollectGem()"



import PlaygroundSupport
public func assessmentPoint() -> AssessmentResults {
    let checker = ContentsChecker(contents: PlaygroundPage.current.text)
    pageIdentifier = "Checking_this_OR_that"

    
    var success = "### Great logic! \nYou know how to use all of the logical operators, including [`!`](glossary://logical%20NOT%20operator), [`&&`](glossary://logical%20AND%20operator), and [`||`](glossary://logical%20OR%20operator). You can now be highly specific with how you run your conditional code. This will come in handy as you make your code increasingly more adaptable. \n\n[**Next Page**](@next)"
    var hints = [
        "Add an `if` statement inside the `for` loop, then add your first condition. In the shortcut bar, tap the `||` operator and add your second condition. Also create an `else` block to move forward if both conditions are false.",
        "Your `if` statement should check whether your character is blocked in front or on the left.",
        "Your `if` statement might look something like this:\n\n```swift\nif isBlocked || isBlockedLeft {\n    Run this code if the condition is true\n} else {\n    Run this code if the condition is false\n}"
    ]

    
    let runCount = currentPageRunCount
    
    if checker.didUseConditionalStatement && runCount > 3 {
        hints[0] = "Your `if` statement might look something like this:\n\n```swift\nif isBlocked || isBlockedLeft {\n    Run this code if the condition is true\n} else {\n    Run this code if the condition is false\n}"
    } else if !checker.didUseConditionalStatement {
        success = "### Oops \nYou didn't use conditional code. You got the right result, but if you invest a little time in learning these skills now, the code you write later will be much more effective. Give it a try using an `if` statement and the `||` operator."
    }
    
    let contents = checker.conditionalNodes.map { $0.condition }
    let usesOrOperator = contents.contains {
        return $0.contains("||")
    }
    
    
    if !usesOrOperator && checker.didUseConditionalStatement {
        hints[0] = "Use the `||` operator to check whether either of two conditions is true. Notice that if your character is blocked either in front *or* on the left, the path calls for `turnRight()` and `moveForward()` commands."
        success = "### Nice! \nYou solved the puzzle using conditional code. Try improving your coding skills by solving the puzzle with the `||` operator, as well."
    } else if usesOrOperator && checker.didUseConditionalStatement {
        hints[0] = "If your character is blocked in front or on the left, turn right and move forward. Otherwise, just move forward."
        success = "### Great logic! \nYou know how to use all of the logical operators, including [`!`](glossary://logical%20NOT%20operator), [`&&`](glossary://logical%20AND%20operator), and [`||`](glossary://logical%20OR%20operator). You can now be highly specific with how you run your conditional code. This will come in handy as you make your code increasingly more adaptable. \n\n[**Next Page**](@next)"
    }
    
    
    
    return updateAssessment(successMessage: success, failureHints: hints, solution: solution)
}
