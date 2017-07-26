// 
//  Assessments.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//

import Foundation



var hints = [
NSLocalizedString("First, set the initial value of `gemCounter`. Example: `var highScore = 105`.", comment:"Hint"),
NSLocalizedString("After you set the initial value of the `gemCounter` variable, move your character forward and collect the gem. Then update `gemCounter` to the new value of 1.", comment:"Hint"),
NSLocalizedString("To assign a new value to a variable, use the following code: \nExample: `gemCounter = 2`", comment:"Hint")

]

let solution = "```swift\nvar gemCounter = 0\n\nmoveForward()\nmoveForward()\ncollectGem()\ngemCounter = 1\n"


public func assessmentPoint() -> AssessmentResults {
    

   let success = NSLocalizedString("### Congratulations! \nYou’ve declared your first variable! Using this variable, you can now track the number of gems your character picks up. Even though you only picked up one gem this time, you’re on your way to creating more intelligent ways to track and store information using code.\n\n[**Next Page**](@next)", comment:"Success message")
    if initialGemCount == 1 && world.existingGems(at: world.allPossibleCoordinates).isEmpty {
        hints[0] = NSLocalizedString("You managed to collect the gem, but instead of assigning `gemCounter` to `1` after collecting it, you set it as the initial value. Adjust your code to initially assign `gemCounter` a value of `0`, then assign it a value of `1` after collecting the gem.", comment:"Hint")
    } else if world.existingGems(at: world.allPossibleCoordinates).isEmpty {
        hints[0] = NSLocalizedString("You managed to collect the gem, but you never set the value of `gemCounter` to `1` to track the gem you collected. Adjust your code to assign `gemCounter` a value of `1` after collecting the gem, then run your code again.", comment:"Hint")
    }
    
    return updateAssessment(successMessage: success, failureHints: hints, solution: solution)
}
