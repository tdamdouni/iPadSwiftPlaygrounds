// 
//  Assessments.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
let solution = "```swift\nfor i in 1 ... 7 {\n   moveForward()\n   if isOnGem && isBlockedLeft {\n      collectGem()\n      turnRight()\n      moveForward()\n      moveForward()\n      toggleSwitch()\n      turnLeft()\n      turnLeft()\n      moveForward()\n      moveForward()\n      turnRight()\n      \n   } else if isOnGem {\n      collectGem()\n      \n   }\n}"

import PlaygroundSupport
public func assessmentPoint() -> AssessmentResults {
    let checker = ContentsChecker(contents: PlaygroundPage.current.text)
    pageIdentifier = "Checking_this_AND_out"

    
    var success = "### Awesome work! \n\n Now it's time to learn about the [logical OR operator](glossary://logical%20AND%20operator)!\n\n[**Next Page**](@next)"
    var hints = [
                    "First, add an `if` statement to check whether your character is on a gem. Then tap && in the shortcut bar to add a condition that checks whether your character is blocked on the left.",
                    "Your `if` statement should start like this:\n\n`if isOnGem && isBlockedLeft {`"
        
    ]
    
    let runCount = currentPageRunCount
    
    
    if checker.didUseConditionalStatement && runCount > 4 {
        hints[0] = "Use this code inside your `for` loop:\n\n```swift\nmoveForward()\nif isOnGem && isBlockedLeft {\n    Run this code if the condition is true\n}\nif isOnGem {\n    collectGem()\n}"
        
    } else if !checker.didUseConditionalStatement {
        success = "### Oops! \nYou didn't use conditional code. Although your program worked this time, without conditional code, it will fail in other situations."
    }
    
    let contents = checker.conditionalNodes.map { $0.condition }
    let usesAndOperator = contents.contains {
        return $0.contains("&&")
    }
    
    if usesAndOperator {
        success = "### Awesome work with the [logical AND operator](glossary://logical%20AND%20operator)! \nYou can now combine multiple conditions to check whether both are true before running a block of code. \n\n[**Next Page**](@next)"
        hints[0] = "Nice work using `&&` in your code. Now make sure that when on a gem AND blocked left, you collect the gem, turn right, and toggle the switch on the stairs. If just on a gem but not blocked left, collect the gem."
        
    }
    else {
        success = "You figured out how to solve the puzzle without using the `&&` operator. Great work, this shows that you think outside the box! However, you should also learn to solve the puzzle using the `&&` operator so that you'll know how to use it in future situations."
        hints[0] = "After you've added your `if` statement, select your first condition and then tap `&&` in the shortcut bar to add the AND operator. Then you can add a second condition, such as `isBlockedLeft`."
    }
    
    
    return updateAssessment(successMessage: success, failureHints: hints, solution: solution)
}
