// 
//  Assessments.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
let success = "### Look how far you've come! \nYou can now change the very puzzles that you’ve been solving. Code has given you the power to change the world, even if it's only a puzzle world for now. Ready to build one final puzzle? \n\n[Next Page](@next)"
let hints = [
    "Call [methods](glossary://method) on `world` to change the puzzle world, adding or removing whatever parts you’d like to change! After you've added some gems and switches, use your character to solve the puzzle you’ve created."
]


let solution: String? = nil 


public func assessmentPoint() -> AssessmentResults {
    return updateAssessment(successMessage: success, failureHints: hints, solution: solution)
}
