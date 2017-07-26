// 
//  Assessments.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//


let solution = "```swift\nfor i in 1 ... 4 {\n   moveForward()\n   collectGem()\n   moveForward()\n   moveForward()\n   moveForward()\n   turnRight()\n}\n```"

import PlaygroundSupport
public func assessmentPoint() -> AssessmentResults {
    let checker = ContentsChecker(contents: PlaygroundPage.current.text)
    
    var success = "### Excellent! \nNow you know how to add a loop structure to your code. You'll need this skill in the next puzzle! \n\n[**Next Page**](@next)"
    var hints = [
        "Open the code library by tapping the + button at the top of the screen, then drag out a `for` loop.",
        "The basic sequence for each side of the square is to collect the gem, move forward three times, then turn right."
    ]
    
    if checker.didUseWhileLoop {
        success = "### Wow! While loops already? Excellent work. \n\n[**Next Page**](@next)"
        
    } else if checker.didUseForLoop {
        success = "### Excellent! \nNow you know how to add loop structures into your code. You'll need this skill in the next puzzle! \n\n[**Next Page**](@next)"
        hints[0] = "Try dragging the bottom curly brace of your `for` loop down to bring the existing commands up into the loop."
    } else if !checker.didUseForLoop {
        success = "### Don't forget to use a loop! \nYour solution will be much simpler if you use a for loop. Give it a shot."
        hints[0] = "Open the code library by tapping the + button at the top of the screen, then drag out a `for` loop. Drag the bottom curly brace down to bring the existing commands up into the loop."
    }
    
    
    
    return updateAssessment(successMessage: success, failureHints: hints, solution: solution)
}
