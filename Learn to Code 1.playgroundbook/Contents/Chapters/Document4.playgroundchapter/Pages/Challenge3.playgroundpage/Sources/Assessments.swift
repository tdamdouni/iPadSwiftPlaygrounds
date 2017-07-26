// 
//  Assessments.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
let solution: String? = nil


import PlaygroundSupport
public func assessmentPoint() -> AssessmentResults {
    let checker = ContentsChecker(contents: PlaygroundPage.current.text)
    pageIdentifier = "Decision_Tree"

    
    
    var success = "### Congrats on finishing Conditional Code! \nYour coding powers are growing. You can now use `if` statements to run certain blocks of code in specific situations. Next, you’ll learn about **logical operators**, symbols that can affect the way your conditional code runs. \n\n[**Introduction to Logical Operators**](Logical%20Operators/Introduction)"
    var hints = [
        "Along the central path, whenevever you reach a gem, a stairway leads down to the right. Whenever you reach a closed switch, there's another gem to the left.",
        "One approach is to use a `for` loop that moves your character along the central path and checks for a gem or a closed switch. If your character is on a closed switch, use a left turn; if your character is on a gem, use a right turn.",
         "This puzzle is a **challenge** and has no provided solution. Strengthen your coding skills by creating your own approach to solving it."
    ]
    
    
    if !checker.didUseConditionalStatement && checker.didUseForLoop {
        hints[0] = "For loops work well with conditional code to determine **if** a certain condition, like `isOnGem`, is true, and then take the same series of actions, such as walking down the stairs and collecting another gem."
        success = "### Nice work! \nYou've solved the puzzle using a `for` loop. But can you go back and solve it using an `if` statement as well?"
    } else if !checker.didUseConditionalStatement && !checker.didUseForLoop {
        hints[0] = "Use the tools you've learned so far: [`if` statements](glossary://if%20statement), [`for` loops](glossary://for%20loop), and [functions](glossary://function). One approach is to use a `for` loop that moves your character down the central path and checks for a gem or a closed switch. If your character is on a closed switch, use a left turn; if your character is on a gem, use a right turn."
        success = "### Almost there! \nYou solved the puzzle, but can you improve your solution by using loops or conditional code? Give it another try now, or come back later. \n\n[**Introduction to Logical Operators**](Logical%20Operators/Introduction)"
    } else if checker.numberOfStatements < 30 {
        success = "### Congrats on finishing Conditional Code! \nYour coding powers are growing. You can now use `if` statements to run certain blocks of code in specific situations. Next, you’ll learn about **logical operators**, symbols that can affect the way your conditional code runs. \n\n[**Introduction to Logical Operators**](Logical%20Operators/Introduction)"
    }
    
    switch currentPageRunCount {
    
    case 0..<5:
        break
    case 5..<7:
        hints[0] =  "**Tip**: If you’re struggling with a challenge, it may help to take your mind off of it and come back to it later. In the meantime, feel free to move on."
    default:
        break
        
    }
    
    
    
    
    return updateAssessment(successMessage: success, failureHints: hints, solution: solution)
}
