// 
//  Assessments.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
let success = "### Well done! \nYou're figuring this out quickly-keep it up! \n\n[Next Page](@next)"
let hints = [
    "[Initialize](glossary://initialization) your expert, but don't change the [constant](glossary://constant) name, `expert`.",
    "Use [dot notation](glossary://dot%20notation) to code a solution for the rest of the puzzle."

]


let solution: String? = "```swift\nlet expert = Expert()\n\nfunc checkSquare() {\n    if expert.isOnGem {\n        expert.collectGem()\n    } else if expert.isOnClosedSwitch {\n        expert.toggleSwitch()\n    }\n}\n\nfunc turnAround() {\n    expert.turnLeft()\n    expert.turnLeft()\n    expert.moveForward()\n    expert.moveForward()\n}\n\nfunc completeSide() {\n    expert.moveForward()\n    checkSquare()\n    expert.moveForward()\n    checkSquare()\n}\n\nfor i in 1...2 {\n    completeSide()\n    turnAround()\n    expert.turnRight()\n}\ncompleteSide()\nexpert.turnLockDown()\nturnAround()\nexpert.turnRight()\nfor i in 1...3{\n    expert.moveForward()\n}\nexpert.turnLeft()\nfor i in 1...2 {\n    completeSide()\n    turnAround()\n}\nexpert.turnRight()\nexpert.moveForward()\nexpert.collectGem()"

public func assessmentPoint() -> AssessmentResults {
    return updateAssessment(successMessage: success, failureHints: hints, solution: solution)
}
