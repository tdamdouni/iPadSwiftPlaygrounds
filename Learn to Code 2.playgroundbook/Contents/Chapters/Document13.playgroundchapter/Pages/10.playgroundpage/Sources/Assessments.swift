// 
//  Assessments.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
let success = "### Now, that was a performance! \n\nAs you've discovered throughout this chapter, there are many different ways to create, use, and modify an [array](glossary://array). Now that you've built up your skills, it's time for you to put all of your knowledge together to create unique worlds and experiences. \n\n[**Next Page**](@next)"
let hints = [
"Change the value for `height` so that it’s equal to the value for `coordinate.column + coordinate.row`.",
"To [initialize](glossary://initialization) an array of characters that already exist in the puzzle world, use `world.existingCharacters(at: allCoordinates)`.",
"After you initialize your array of existing characters, use a [`for` loop](glossary://for%20loop) to iterate over each of them, making them perform some actions!"
]

let solution: String? = "```swift\nlet allCoordinates = world.allPossibleCoordinates\n\nfor coordinate in allCoordinates {\n  let height = coordinate.column + coordinate.row\n      \n   for i   in 0...height {\n      world.place(Block(), at: coordinate)\n   }\n   if height >= 8 && height < 10 {\n      world.place(Character(name: .blu), at: coordinate)\n   } else if height > 9 {\n      world.place(Character(name: .byte), at: coordinate)\n   }\n}\n\nlet characters = world.existingCharacters(at: allCoordinates)\nfor character in characters {\n   character.jump()\n}"


public func assessmentPoint() -> AssessmentResults {
    return updateAssessment(successMessage: success, failureHints: hints, solution: solution)
}
