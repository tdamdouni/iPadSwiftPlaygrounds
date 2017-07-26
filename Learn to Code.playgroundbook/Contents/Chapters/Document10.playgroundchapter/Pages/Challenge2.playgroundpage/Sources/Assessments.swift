// 
//  Assessments.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
let success = "### Great work! \nYou just solved a tough challenge! By examining a problem and choosing which skills to use, you’re teaching your brain to recognize how to solve a range of problems. As you gain experience, you’ll be able to solve new problems more quickly and effectively. \n\n[Next Page](@next)"
let hints = [
    "Take a minute to examine the puzzle and see which of the skills you've learned so far will be most useful in solving it. There are many different solutions, so give one of your ideas a try!",
    "Just like in the previous puzzle, you’ll need to use [dot notation](glossary://dot%20notation) to modify the [state](glossary://state) of each portal [instance](glossary://instance) separately. \nExample: `greenPortal.isActive = true`"
]

let solution: String? = "```swift\nfunc turnAround() {\nturnLeft()\nturnLeft()\n}\n\nfunc checkSquare() {\n    if isOnGem {\n        collectGem()\n    } else if isOnClosedSwitch {\n        toggleSwitch()\n    }\n}\n\nfunc collectOrToggle() {\n    moveForward()\n    checkSquare()\n    turnAround()\n}\n\nfunc collectOrToggleThenTurnRight() {\n    collectOrToggle()\n    moveForward()\n    turnRight()\n}\n\nfunc collectOrToggleThenTurnLeft() {\n    collectOrToggle()\n    moveForward()\n    turnLeft()\n}\n\nturnLeft()\nmoveForward()\nmoveForward()\ngreenPortal.isActive = false\nfor i in 1...3 {\n    collectOrToggleThenTurnRight()\n}\ncollectOrToggle()\ngreenPortal.isActive = true\nmoveForward()\ngreenPortal.isActive = false\ncollectOrToggleThenTurnLeft()\ncollectOrToggleThenTurnLeft()\nmoveForward()\nmoveForward()\norangePortal.isActive = false\nmoveForward()\nfor i in 1...3 {\n    collectOrToggleThenTurnRight()\n}\ncollectOrToggle()\norangePortal.isActive = true\nmoveForward()\norangePortal.isActive = false\nturnLeft()\ncollectOrToggleThenTurnRight()\ncollectOrToggle()"



public func assessmentPoint() -> AssessmentResults {
    return updateAssessment(successMessage: success, failureHints: hints, solution: solution)
}
