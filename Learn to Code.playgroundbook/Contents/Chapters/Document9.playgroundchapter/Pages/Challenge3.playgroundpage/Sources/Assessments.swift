// 
//  Assessments.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
let success = "### Very impressive! \nYou've solved some difficult puzzles involving variables. Nice work! Ready for the last challenge? \n\n[Next Page](@next)"
let hints = [
    "On the first platform, a random number of gems will appear. Check each tile and increment a gem-counting variable to count the number Byte collects.",
    "On the second platform, use a second variable to track the number of switches Byte toggles. Compare this variable with the gem-counting variable to create a condition that says when to stop Byte from toggling switches."
]


let solution = "```swift\nvar gemCounter = 0\nvar switchCounter = 0\n\nwhile !isOnClosedSwitch {\n    while !isBlocked {\n        if isOnGem {\n            collectGem()\n            gemCounter = gemCounter + 1\n        }\n        moveForward()\n    }\n    turnRight()\n}\n\nwhile switchCounter < gemCounter {\n    while !isBlocked {\n        if isOnClosedSwitch && switchCounter < gemCounter {\n            toggleSwitch()\n            switchCounter = switchCounter + 1\n        }\n        moveForward()\n    }\n    turnRight()\n}"


public func assessmentPoint() -> AssessmentResults {
    return updateAssessment(successMessage: success, failureHints: hints, solution: solution)
}
