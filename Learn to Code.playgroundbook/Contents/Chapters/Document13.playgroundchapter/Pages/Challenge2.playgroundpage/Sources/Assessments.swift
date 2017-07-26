// 
//  Assessments.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
let success = "### Impressive! \nEvery time you figure out a new solution, you gain a better sense of which solutions will work for a certain kind of problem. The next time you see something similar, you’ll already have a hunch about how to solve it! \n\n[Next Page](@next)"
let hints = [
    "There are many different ways to solve this puzzle. Use your world-building skills to add blocks, portals, and stairs that will help you solve the puzzle in whatever way you think will work best.",
    "You need to add an [instance](glossary://instance) of your character or the expert to solve this puzzle. In case you’ve forgotten, [here's a refresher](Parameters/Placing%20at%20a%20Specific%20Location).",
    "Don't be afraid to try different approaches to solving this puzzle. Coders often don’t get things right on the first try!"
]


let solution: String? = nil


public func assessmentPoint() -> AssessmentResults {
    return updateAssessment(successMessage: success, failureHints: hints, solution: solution)
}
