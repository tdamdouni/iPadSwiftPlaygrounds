// 
//  Assessments.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//

import Foundation

var hints = [
    NSLocalizedString("Collect all the gems in the puzzle world, keeping track of how many are collected. For every gem collected, increment `gemCounter` by one.", comment:"Hint"),
    NSLocalizedString("One way to increment a variable is to use code like this: `myAge = myAge + 1`.", comment:"Hint"),
     NSLocalizedString("Check each tile to see if a gem is present. If so, collect it and increment `gemCounter` by 1, using `gemCounter = gemCounter + 1`.", comment:"Hint"),
     NSLocalizedString("Remember, you can use a `while` loop to continue to move forward until blocked. Consider writing a loop to move to and check for a gem on all tiles of the puzzle world.", comment:"Hint")
]

let solution = "```swift\nvar gemCounter = 0\nwhile !isBlocked {\n   while !isBlocked {\n   if isOnGem {\n      collectGem()\n      gemCounter = gemCounter + 1\n   }\n   moveForward()\n   }\n   turnRight()\n}"


public func assessmentPoint() -> AssessmentResults {
    
    
    let success = NSLocalizedString("### You’re becoming a variable master! \nWhen you combine conditional code, loops, and variables, you create the foundation for some incredibly complex apps. Up next, you’ll use a variable to collect an exact number of gems. \n\n[**Next Page**](@next)", comment:"Success message")

    if world.existingGems(at: world.allPossibleCoordinates).isEmpty {
    let format = NSLocalizedString("sd:chapter8.exercise2.partialSuccess", comment: "Hint {number of gems} {user's gem count in their variable}")
        hints[0] = String.localizedStringWithFormat(format, randomGemCount, finalGemCount)
    }
    
    return updateAssessment(successMessage: success, failureHints: hints, solution: solution)
}
