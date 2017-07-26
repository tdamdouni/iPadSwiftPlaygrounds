// 
//  Assessments.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
let success = "### Wow! \nYour coding skills have come a long way. It’s time to learn a new set of skills. Ready to begin? \n\n[Introduction to Initialization](Initialization/Introduction)"
let hints = [
    "[Declare](glossary://declaration) a [variable](glossary://variable) to track how many gems Byte picks up, and compare it to the `totalGems` [constant](glossary://constant) to determine when to stop.",
    "Create an [algorithm](glossary://algorithm) that moves Byte across all parts of the puzzle to collect all the gems. You will need to activate and deactivate the portals in order to do this."
]

let solution = "```swift\nlet totalGems = randomNumberOfGems\nvar gemCounter = 0\n\nbluePortal.isActive = false\npinkPortal.isActive = false\nwhile gemCounter < totalGems {\n    if isOnGem {\n        collectGem()\n        gemCounter = gemCounter + 1\n    }\n    moveForward()\n    if isBlocked {\n        turnLeft()\n        turnLeft()\n        if bluePortal.isActive == true {\n            bluePortal.isActive = false\n            pinkPortal.isActive = false\n        } else if bluePortal.isActive == false {\n            bluePortal.isActive = true\n            pinkPortal.isActive = true\n        }\n    }\n}\n```"


public func assessmentPoint() -> AssessmentResults {
    return updateAssessment(successMessage: success, failureHints: hints, solution: solution)
}
