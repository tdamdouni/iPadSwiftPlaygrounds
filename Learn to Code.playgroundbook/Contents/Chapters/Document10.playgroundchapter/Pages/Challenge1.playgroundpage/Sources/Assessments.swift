// 
//  Assessments.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
let success = "### Way to go! \nSometimes you need to modify the [properties](glossary://property) of an [instance](glossary://instance) multiple times while your code runs. Great work! \n\n[Next Page](@next)"
let hints = [
    "First, use [pseudocode](glossary://pseudocode) to map out how you’ll activate and deactivate the portal to solve the puzzle. Then write out that code and test it.",
    "Use [dot notation](glossary://dot%20notation) to deactivate and activate the portal. \nExample: `purplePortal.isActive = false`"
]


let solution = "```swift\nfunc moveAndCollect() {\n    while !isBlocked {\n        moveForward()\n        if isOnGem {\n            collectGem()\n        }\n    }\n}\n\nfunc turnAround() {\n    turnLeft()\n    turnLeft()\n}\n\nmoveAndCollect()\nturnAround()\npurplePortal.isActive = false\nwhile !isBlocked {\n    moveForward()\n}\ntoggleSwitch()\nturnAround()\npurplePortal.isActive = true\nmoveAndCollect()"

public func assessmentPoint() -> AssessmentResults {
    return updateAssessment(successMessage: success, failureHints: hints, solution: solution)
}
