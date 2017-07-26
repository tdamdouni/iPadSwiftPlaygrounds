// 
//  Assessments.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
let success = "### Monumental! \nWhen you have a [type](glossary://type) like `Expert`, you can create as many [instances](glossary://instance) of that type as you want. Because they all came from the same blueprint, you can call the same [methods](glossary://method) to access the same [properties](glossary://property) on any instance of that type. \n\n[Next Page](@next)"
let hints = [
    "You can [initialize](glossary://initialization) two instances of the `Expert` type; just be sure to give them different names.",
    "Place both experts into the puzzle world using the `world.place` method.",
    "You'll need your experts to work together to solve this puzzle."
]

let solution: String? = nil


public func assessmentPoint() -> AssessmentResults {
    return updateAssessment(successMessage: success, failureHints: hints, solution: solution)
}
