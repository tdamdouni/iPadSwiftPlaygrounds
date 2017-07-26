// 
//  Assessments.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
let success = "### Great work! \nIn coding, it's important to study a problem and choose from one of several available solutions. Sometimes, one approach can work just as well as another. Other times, an approach might end up being more efficient, [reusable](glossary://reusability), or adaptable than others. \n\n[**Next Page**](@next)"
let hints = [
    "Look at the puzzle and see if you can figure out a solution that uses a [loop](glossary://loop). Would multiple different approaches work?",
    "One approach is to write a [`for` loop](glossary://for%20loop) that runs a code block a specific number of times. Another approach is to use a [`while` loop](glossary://while%20loop) to run code while a certain condition is true."
]

let solution = "```swift\nfunc turnAndCollectGem() {\n   moveForward()\n   turnLeft()\n   moveForward()\n   collectGem()\n   turnRight()\n}\n\nwhile !isBlocked {\n   turnAndCollectGem()\n}\n```"


public func assessmentPoint() -> AssessmentResults {
    return updateAssessment(successMessage: success, failureHints: hints, solution: solution)
}
