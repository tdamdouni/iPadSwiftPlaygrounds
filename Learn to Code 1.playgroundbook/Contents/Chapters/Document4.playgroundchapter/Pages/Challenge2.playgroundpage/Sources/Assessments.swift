// 
//  Assessments.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//

let solution: String? = nil

import PlaygroundSupport
public func assessmentPoint() -> AssessmentResults {
    let checker = ContentsChecker(contents: PlaygroundPage.current.text)
    pageIdentifier = "Boxed_In"

    var hints = [
        "Any tile in the square could have a gem, an open switch, or a closed switch. First, write a function called `checkTile()` to check for each possibility on a single tile.",
        "You'll need to use your function to check every tile. Is there an easy way to do that?",
        "Try using a loop that repeats a set of commands to complete one corner of the puzzle each time.",
         "This puzzle is a **challenge** and has no provided solution. Strengthen your coding skills by creating your own approach to solving it."
        
        ]
    
    let success: String
    if checker.didUseForLoop == false && checker.numberOfStatements > 12 {
        success = "### Oops! \nYou completed the puzzle, but you forgot to include a [for loop](glossary://for%20loop). You ran \(checker.numberOfStatements) lines of code, but with a for loop, you’d need only 12. \n\nYou can try again or move on. \n\n[**Next Page**](@next)"
    }
    else if checker.didUseForLoop == true && checker.didUseConditionalStatement == false {
        success = "Congrats! \nYou managed to solve the puzzle by using a [for loop](glossary://for%20loop), but you didn’t include [conditional code](glossary://conditional%20code). Using `if` statements makes your code more intelligent and allows it to respond to changes in your environment. \n\nYou can try again or move on. \n\n[**Next Page**](@next)"
    }
    else if checker.didUseForLoop == true && checker.didUseConditionalStatement == true && checker.didCallCustomFunction() {
        success = "### Great work! \nYour solution used both for loops and [conditional code](glossary://conditional%20code), incredible tools that make your code more intelligent and let you avoid repeating the same set of commands many times. However, you can improve your solution by writing your own custom function to check an individual tile for a gem or a closed switch. As an added challenge, try solving the puzzle by writing a custom function. Feel free to move on whenever you are ready.  \n\n[**Next Page**](@next)"
    } else {
        success = "### Fantastic! \nYour solution is incredible. You've come a long way, learning conditional code and combining your new skills with functions and `for` loops! \n\n[**Next Page**](@next)"
    }
    
    return updateAssessment(successMessage: success, failureHints: hints, solution: solution)
}




