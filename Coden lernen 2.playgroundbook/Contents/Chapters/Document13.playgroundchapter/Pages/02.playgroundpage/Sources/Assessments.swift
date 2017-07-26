// 
//  Assessments.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//

import Foundation

let success = NSLocalizedString("### Bravo! \n\nYou may have noticed that the `place(item: Item, at: Coordinate)` [method](glossary://method) takes an input of type `Coordinate`, while `place(item: Item, atColumn: Int, row: Int)` takes two [Int](glossary://Int) values. Both of these methods work for placing items, but in this chapter, you’ll use `place(item: Item, at: Coordinate)` because you'll be working with arrays of the `Coordinate` type. \n\n[**Next Page**](@next)", comment:"Success message")
let hints = [
NSLocalizedString("First, add two coordinates to `blockLocations`, one for each remaining corner of the puzzle world. Use the following [syntax](glossary://syntax):\n\n```swift\nvar corners = [\n    Coordinate(column: 0, row: 0),\n    Coordinate(column: 3, row: 3)\n]\n", comment:"Hint"),
NSLocalizedString("After you add coordinates to your array, [iterate](glossary://iteration) over each coordinate in the array, placing `5` blocks at each coordinate. You may want to write an additional [`for` loop](glossary://for%20loop) inside your `for-in` loop:\n\n```swift\nfor coordinate in blockLocations {\n    for i in 1...5 {\n        place a block\n    }\n}\n", comment:"Hint")
]

let solution: String? = "```swift\nlet corners = [\n   Coordinate(column: 0, row: 0),\n   Coordinate(column: 3, row: 3),\n   Coordinate(column: 0, row: 3),\n   Coordinate(column: 3, row: 0),\n]\n\nfor coordinate in corners {\n   for i in 1...5 {\n      world.place(Block(), at: coordinate)\n   }\n}"


public func assessmentPoint() -> AssessmentResults {
    return updateAssessment(successMessage: success, failureHints: hints, solution: solution)
}
