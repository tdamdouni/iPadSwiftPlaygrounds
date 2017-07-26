// 
//  Assessments.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//

import Foundation

let solution = "```swift\nwhile !isBlocked {\n   if isOnClosedSwitch {\n      toggleSwitch()\n   }\n   moveForward()\n}\n```"


import PlaygroundSupport
public func assessmentPoint() -> AssessmentResults {
    let checker = ContentsChecker(contents: PlaygroundPage.current.text)
    pageIdentifier = "Creating_Smarter_While_Loops"

    
    
    var hints = [
        NSLocalizedString("Just like the previous puzzle, you need to carry out a set of actions while a certain condition is true.", comment:"Hint"),
        NSLocalizedString("One approach is to move forward while your character is not blocked.", comment:"Hint"),
        NSLocalizedString("On each tile, use an [`if` statement](glossary://if%20statement) to determine whether or not your character is on a closed switch.", comment:"Hint"),
        ]
    
    var  success = NSLocalizedString("### Incredible work! \nUsing [`while` loops](glossary://while%20loop) is already making your code simpler. By pairing a while loop and [conditional code](glossary://conditional%20code), you can write programs that are much more adaptable. \n\n[**Next Page**](@next)", comment:"Success message")
    
    if !checker.didUseWhileLoop {
        let format = NSLocalizedString("sd:chapter6.exercise2.partialSuccessMessage", comment: "Success message - {number of lines of code}")
        success = String.localizedStringWithFormat(format, checker.numberOfStatements)
        hints[0] = NSLocalizedString("Add a `while` loop by tapping `while` in the shortcut bar. Then add a condition that moves forward until reaching the end of the third platform.", comment:"Hint")

    }
    
    let contents = checker.loopNodes.map { $0.condition }
    
    for element in contents {
        if !element.contains("!isBlocked") && checker.didUseWhileLoop {
            hints[0] = NSLocalizedString("While your character is *not* blocked, check for a closed switch and move forward.", comment:"Hint")
        } else if element.contains("!isBlocked") && checker.didUseWhileLoop && !checker.didUseConditionalStatement {
            hints[0] = NSLocalizedString("Each time your loop runs, you need to check if your character is on a closed switch. If so, toggle the switch. Be careful not to toggle any open switches.", comment:"Hint")
            
        } else if element.contains("!isBlocked") && checker.didUseWhileLoop && checker.didUseConditionalStatement {
            success = NSLocalizedString("### Incredible work! \nUsing `while` loops is already making your code simpler. By pairing a `while` loop and [conditional code](glossary://conditional%20code), you can write code that is much more adaptable. \n\n[**Next Page**](@next)", comment:"Success message")
            hints[0] = NSLocalizedString("Inside your `while` loop, write an `if` statement that begins like this: `if isOnClosedSwitch {`", comment:"Hint")

        
    }
        if world.commandQueue.containsIncorrectToggleCommand(for: actor) {
            hints[0] = NSLocalizedString("For each move forward, use an `if` statement to make sure there’s a closed switch on the tile before toggling the switch.", comment:"Hint")
        }
    
    
    }

    
    
    
    return updateAssessment(successMessage: success, failureHints: hints, solution: solution)
}
