// 
//  Assessments.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
let solution = "```swift\nwhile !isBlocked {\n   if isOnClosedSwitch {\n      toggleSwitch()\n   }\n   moveForward()\n}\n```"


import PlaygroundSupport
public func assessmentPoint() -> AssessmentResults {
    let checker = ContentsChecker(contents: PlaygroundPage.current.text)
    pageIdentifier = "Creating_Smarter_While_Loops"

    
    
    var hints = [
        "Just like the previous puzzle, you need to carry out a set of actions while a certain condition is true.",
        "One approach is to move forward while your character is not blocked.",
        "On each tile, use an [`if` statement](glossary://if%20statement) to determine whether or not your character is on a closed switch.",
        ]
    
    var  success = "### Incredible work! \nUsing [`while` loops](glossary://while%20loop) is already making your code simpler. By pairing a while loop and [conditional code](glossary://conditional%20code), you can write programs that are much more adaptable. \n\n[**Next Page**](@next)"
    
    if !checker.didUseWhileLoop {
        success = "### Almost! \nYou completed the puzzle, but you didn’t use a `while` loop. It took \(checker.numberOfStatements) lines of code to complete this puzzle, but if you’d used a `while` loop, you could have solved it in as few as 4!"
        hints[0] = "Add a `while` loop by tapping `while` in the shortcut bar. Then add a condition that moves forward until reaching the end of the third platform."

    }
    
    let contents = checker.loopNodes.map { $0.condition }
    
    for element in contents {
        if !element.contains("!isBlocked") && checker.didUseWhileLoop {
            hints[0] = "While your character is *not* blocked, check for a closed switch and move forward."
        } else if element.contains("!isBlocked") && checker.didUseWhileLoop && !checker.didUseConditionalStatement {
            hints[0] = "Each time your loop runs, you need to check if your character is on a closed switch. If so, toggle the switch. Be careful not to toggle any open switches."
            
        } else if element.contains("!isBlocked") && checker.didUseWhileLoop && checker.didUseConditionalStatement {
            success = "### Incredible work! \nUsing `while` loops is already making your code simpler. By pairing a `while` loop and [conditional code](glossary://conditional%20code), you can write code that is much more adaptable. \n\n[**Next Page**](@next)"
            hints[0] = "Inside your `while` loop, write an `if` statement that begins like this: `if isOnClosedSwitch {`"

        
    }
        if world.commandQueue.containsIncorrectToggleCommand(for: actor) {
            hints[0] = "For each move forward, use an `if` statement to make sure there’s a closed switch on the tile before toggling the switch."
        }
    
    
    }

    
    
    
    return updateAssessment(successMessage: success, failureHints: hints, solution: solution)
}
