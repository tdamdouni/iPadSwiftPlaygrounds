//
//  Assessments.swift
//
//  Copyright (c) 2017 Apple Inc. All Rights Reserved.
//
import PlaygroundSupport
import UIKit

/* Completed Code
 
 for i in 1...25 {
    shift(ciphertext, by: i)
 }
 
 */

private let successString = NSLocalizedString("Wow, congratulations! You've decrypted the message! And you did it in no time at all. Bravo! The message is clearly leading you somewhere else—quick, on to the [next page](@next)!", comment: "Success string for-loop for solving puzzle")
private let missingForLoopNotExhaustiveSuccessString = NSLocalizedString("Wow, you did it! You’re pretty lucky to have guessed the shift value. What would you have done if there had been a thousand possible shift values? In that case, a `for` loop would be pretty handy!\n\nBut that's okay—you’ve decrypted the puzzle. Quick, on to the [next page](@next)!", comment: "Success string guessing for solving puzzle.")
private let exhaustiveSuccessString = NSLocalizedString("Great job! You truly \"brute forced\" your way to the solution. To get there a bit faster next time, try using a `for` loop to make the computer do the hard work of calling the shift function so many times.\n\nBut in any case, you've decrypted the puzzle—quick, on to the [next page](@next)!", comment: "Success string brute-force for solving puzzle.")
private let solutionString = NSLocalizedString("`for i in 1...25 {\n    shift(ciphertext, by: i)\n}\n`", comment: "Solution for full puzzle.")

private let scrollHint = NSLocalizedString("To see the different decryptions, either swipe across the text, or tap the \"Previous\" or \"Next\" buttons to rotate through the decryptions.", comment: "Scroll hint for full puzzle.")
private let missingForLoopHint = NSLocalizedString("Checking every possible shift value, from 1 to 25, would go much more quickly if you used a `for` loop.", comment:"Hint for missing for loop.")

public func assessmentPoint(success: Bool) -> PlaygroundPage.AssessmentStatus {
    let checker = ContentsChecker(contents: PlaygroundPage.current.text)
    
    var hints = [scrollHint]
    var finalSuccessMessage = ""
    let shiftCalls = checker.functionCallCount(forName: "shift")
    
    
    //Hint for not using for loop
    if !checker.didUseForLoop {
        if shiftCalls > 4 {
            if success {
                finalSuccessMessage = exhaustiveSuccessString
            } else {
                hints.insert(missingForLoopHint, at: 0)
            }
        } else {
            if success {
                finalSuccessMessage = missingForLoopNotExhaustiveSuccessString
            } else {
                hints.insert(missingForLoopHint, at: 0)
            }
        }
    } else {
        if success {
            finalSuccessMessage = successString
        }
    }
    
    if !success {
        // Show hints
        return .fail(hints: hints, solution: solutionString)
    } else {
        return .pass(message: finalSuccessMessage)
    }
}
