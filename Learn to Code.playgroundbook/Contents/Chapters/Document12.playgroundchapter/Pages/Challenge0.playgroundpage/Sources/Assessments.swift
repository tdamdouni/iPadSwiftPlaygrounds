// 
//  Assessments.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
let success = "### Great Job! \nNow that you’ve learned how to create functions with [parameters](glossary://parameter), find out how to use parameters to place a character in a specific location in the puzzle world. \n\n[Next Page](@next)"
let hints = [
"Remember, you can use both the `move(distance: Int)` and `turnLock(up: Bool, numberOfTimes: Int)` methods to solve this puzzle.",
]

let solution: String? = "```swift\nlet expert = Expert()\nlet character = Character()\n\nfunc turnAround() {\n    character.turnLeft()\n    character.turnLeft()\n}\n\nfunc collectGemTurnAround() {\n    character.moveForward()\n    character.moveForward()\n    character.collectGem()\n    turnAround()\n    character.moveForward()\n    character.moveForward()\n    character.turnRight()\n}\n\n\nfor i in 1...4 {\n    expert.turnLock(up: true, numberOfTimes: 4)\n    expert.turnRight()\n}\nfor i in 1...3 {\n    while !character.isOnGem {\n        character.moveForward()\n    }\n    character.collectGem()\n    character.turnRight()\n}\ncharacter.moveForward()\nfor i in 1...4 {\n    expert.turnLock(up: false, numberOfTimes: 3)\n    expert.turnRight()\n}\ncharacter.turnLeft()\ncharacter.moveForward()\ncharacter.collectGem()\nturnAround()\nfor i in 1...3 {\n    character.moveForward()\n    character.moveForward()\n    if !character.isOnGem {\n        character.turnRight()\n        collectGemTurnAround()\n    } else {\n        character.collectGem()\n    }\n}"


public func assessmentPoint() -> AssessmentResults {
    return updateAssessment(successMessage: success, failureHints: hints, solution: solution)
}
