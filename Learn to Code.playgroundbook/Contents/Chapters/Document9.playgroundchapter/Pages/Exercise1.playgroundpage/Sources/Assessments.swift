// 
//  Assessments.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
let success = "### Congratulations! \nYou’ve declared your first variable! Using this variable, you can now track the number of gems Byte picks up. Even though Byte picked up only one gem this time, you’re on your way to creating more intelligent ways to track and store information using code.\n\n[Next Page](@next)"

let hints = [
"Declare a new variable by tapping `var` in the shortcut bar and give the variable a name, then use the [assignment operator](glossary://assignment%20operator) (=) to set the variable's value. Example: `var highScore = 105`.",
"After you declare the `gemCounter` variable, move Byte forward and collect the gem. Then update `gemCounter` to the new value of 1.",
"The only time you need to use `var` is when you declare the `gemCounter` variable. After that, you can just assign a new value. \nExample: `gemCounter = 2`"

]

let solution = "```swift\nvar gemCounter = 0\n\nmoveForward()\nmoveForward()\ncollectGem()\ngemCounter = 1\n"


public func assessmentPoint() -> AssessmentResults {
    return updateAssessment(successMessage: success, failureHints: hints, solution: solution)
}
