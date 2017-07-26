// 
//  Assessments.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
let success = "### Keep going! \n\nYou can continue to build your puzzle until you’re satisfied with it. When you’re done, you can even have someone else try to solve it! \n\nCongratulations on completing World Building. You now have the skills to begin constructing more complex landscapes! To do this, you’ll learn how to store multiple pieces of information in a certain order using [arrays](glossary://array). \n\n[Introduction to Arrays](Arrays/Introduction)"
let hints = [
    "Add a gem or a switch to your puzzle a method like this: `world.place(Gem(), atColumn: 3, row: 3)`.",
    "See if you can figure out how to add an instance of `PlatformLock` and  `Platform` by experimenting with the code.",
    "You can build your world however you’d like. The sky is the limit!"
]

let solution: String? = nil


public func assessmentPoint() -> AssessmentResults {
    return updateAssessment(successMessage: success, failureHints: hints, solution: solution)
}
