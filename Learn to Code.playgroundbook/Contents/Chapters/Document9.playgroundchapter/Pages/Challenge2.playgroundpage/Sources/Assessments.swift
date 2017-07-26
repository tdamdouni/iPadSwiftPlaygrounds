// 
//  Assessments.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
let success = "### You've got it! \nUsing multiple variables gives you more information that you can to use to make your code specific and adaptable in new situations. Just be sure your variables’ names say exactly what they’re keeping track of (like `gemCounter`). Otherwise, you might not remember what they’re storing! \n\n[Next Page](@next). "

let hints = [
                "You now need to manage two variables: one to track gems and one to track open switches.",
                "If Byte is on a gem, collect it, and then you increment `gemCounter` by one. If Byte is on a switch, activate it, and then you increment `switchCounter` by one. Use conditional code to stop Byte collecting gems when the value of `gemCounter` reaches 3.",
                "You can use the [OR operator](glossary://logical%20OR%20operator) (||) with a `while` loop to tell your code when to stop running. \nExample: `while gemCounter < 3 || switchCounter < 4`"
]


let solution = "```swift\nvar gemCounter = 0\nvar switchCounter = 0\n\nwhile gemCounter != 3 || switchCounter != 4 {\n    if gemCounter != 3 && isOnGem {\n        collectGem()\n        gemCounter = gemCounter +1\n    } else if switchCounter != 4 && isOnClosedSwitch {\n        toggleSwitch()\n        switchCounter = switchCounter + 1\n    }\n    if isBlocked {\n        turnRight()\n        if isBlocked {\n            turnLeft()\n            turnLeft()\n        }\n    }\n    moveForward()\n}\n```"

public func assessmentPoint() -> AssessmentResults {
    return updateAssessment(successMessage: success, failureHints: hints, solution: solution)
}
