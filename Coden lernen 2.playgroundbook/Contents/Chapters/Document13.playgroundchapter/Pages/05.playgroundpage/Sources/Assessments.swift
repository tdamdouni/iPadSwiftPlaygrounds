// 
//  Assessments.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//

import Foundation

let success = NSLocalizedString("### Your powers are growing! \n\nWith arrays, you can manage a lot of information quickly and efficiently to create amazing worlds. \n\nDid you notice how the array `allCoordinates` was initialized? You can use the `allPossibleCoordinates` [property](glossary://property) of the `world` instance to give you an array of all the coordinates in the puzzle world. This lets you iterate over every coordinate. How cool is that? \n\n[**Next Page**](@next)", comment:"Success message")
let hints = [
NSLocalizedString("You can create an empty array of coordinates, like this one: \n\n`var island: [Coordinate] = []`\n\nThis code creates a new variable that stores an array of coordinates, initialized with no items.", comment:"Hint"),
NSLocalizedString("After you create your *island* and *sea* [arrays](glossary://array), write conditions for your [`if` statement](glossary://if%20statement) that determine if a coordinate is in the island region of the world. For example, you might want to append any coordinate with both the column and row greater than `3` and less than `7`.", comment:"Hint"),
NSLocalizedString("This puzzle is a **challenge** and has no provided solution. Strengthen your coding skills by creating your own approach to solving it.", comment:"Hint")

]

let solution: String? = nil


public func assessmentPoint() -> AssessmentResults {
    return updateAssessment(successMessage: success, failureHints: hints, solution: solution)
}
