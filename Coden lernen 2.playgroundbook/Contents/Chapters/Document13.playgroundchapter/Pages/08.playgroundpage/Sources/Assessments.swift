// 
//  Assessments.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//

import Foundation

let success = NSLocalizedString("### Whoa, that was awesome! \n\nDid you notice how the [array out of bounds error](glossary://array%20out%20of%20bounds%20error) was prevented? Say, for example, that the number of values in your array is `10`-that means the highest [index](glossary://index) you can access is `9` (because the index starts at `0`).\n\nIf your `index` variable is equal to `heights.count` (value `10`), you’ll try to access index `10`, which is outside the boundary of the array. Instead, you can reset the value of your `index` variable to `0` when it’s equal to the number of items in your array. \n\n[**Next Page**](@next)", comment:"Success message")
let hints = [
    NSLocalizedString("First, add a set of [Int](glossary://Int) values to your `heights` array. If you want to quickly add more items to the array, try tapping the square brackets and dragging to the right.", comment:"Hint"),
    NSLocalizedString("When completing your [inner for loop](glossary://inner%20loop), you’ll use the value of the `heights` array at `index` to determine how many blocks to place: `for i in 0...heights[index]`.", comment:"Hint"),
    NSLocalizedString("To increment the `index` variable, add `1` to its current value.", comment:"Hint")
]

let solution: String? = "```swift\nvar heights: [Int] = [1,8,4,3,1,5]\nlet allCoordinates = world.allPossibleCoordinates\n\nvar index = 0\nfor coordinate in allCoordinates {\n   if index == heights.count {\n      index = 0\n   }\n   for i in 0...heights[index] {\n      world.place(Block(), at: coordinate)\n   }\n     index += 1\n}"


public func assessmentPoint() -> AssessmentResults {
    return updateAssessment(successMessage: success, failureHints: hints, solution: solution)
}
