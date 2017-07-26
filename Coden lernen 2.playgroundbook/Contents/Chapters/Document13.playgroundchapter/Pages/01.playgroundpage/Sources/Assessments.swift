// 
//  Assessments.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//

import Foundation

let success = NSLocalizedString("### Now you're iterating! \n\n[Iterating](glossary://iteration) over an array allows you to build worlds much faster than placing items one at a time. To iterate over an array, use a `for`-`in` loop that performs an action for each item in the array.\n\n[**Next Page**](@next)", comment:"Success message")

let hints = [
NSLocalizedString("When naming the [variable](glossary://variable) in your `for`-`in` loop, remember to use **camelCase**, starting the variable with a lowercase letter. For example, `column`, `currentColumn`, and `eachColumn` all work as variable names. `Column` doesn’t work because it starts with a capital letter.", comment:"Hint"),
NSLocalizedString("To iterate over `columns`, use a `for`-`in` loop, like this:\n\n    for currentColumn in columns {\n        place a gem \n        place a switch \n    }", comment:"Hint"),
NSLocalizedString("Use `world.place(Gem(), atColumn: currentColumn, row: 1)` to place a gem at one of the coordinates in your `columns` array.", comment:"Hint"),
NSLocalizedString("This puzzle is a **challenge** and has no provided solution. Strengthen your coding skills by creating your own approach to solving it.", comment:"Hint")
]


let solution: String? = nil


public func assessmentPoint() -> AssessmentResults {
    return updateAssessment(successMessage: success, failureHints: hints, solution: solution)
}
