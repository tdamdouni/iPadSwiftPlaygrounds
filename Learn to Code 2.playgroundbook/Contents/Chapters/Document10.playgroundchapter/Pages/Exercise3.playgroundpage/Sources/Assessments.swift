// 
//  Assessments.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
let success = "### Brilliant! \nWhen you [initialize](glossary://initialization) multiple [instances](glossary://instance), you need to refer to each one by its name when calling a [method](glossary://method). You'll often have multiple instances when coding, so this is great practice! \n\n[**Next Page**](@next)"
let hints = [
    "First, [initialize](glossary://initialization) an [instance](glossary://instance) of your expert and an instance of your character. Don't change the constant names, `character` and `expert`, that are provided for you.",
    "Give your expert and character separate instructions using [dot notation](glossary://dot%20notation).",
    "Have your expert raise the first platform and then, after your character has crossed over, lower the second platform."
]

let solution = "```swift\nlet expert = Expert()\nlet character = Character()\n\nexpert.moveForward()\nexpert.turnLockUp()\ncharacter.moveForward()\ncharacter.collectGem()\ncharacter.moveForward()\ncharacter.turnRight()\ncharacter.moveForward()\ncharacter.moveForward()\nexpert.turnLockDown()\nexpert.turnLockDown()\ncharacter.moveForward()\ncharacter.collectGem()\n```"

public func assessmentPoint() -> AssessmentResults {
    return updateAssessment(successMessage: success, failureHints: hints, solution: solution)
}
