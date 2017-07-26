// 
//  Assessments.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
let success = "### Impressive! \n\nArrays are leading you to new frontiers of world building! Remember, you can create an array that’s completely empty and add values to it later, but you have to say what type of items it will hold. When you [declare](glossary://declaration) the array, use the following [syntax](glossary://syntax) to give it a type: \n\n`var placementLocations: [Coordinate]`. \n\n[**Next Page**](@next)"
let hints = [
"Modify the condition of your [`if` statement](glossary://if%20statement) so that it checks for coordinates with a column greater than `5` or a row less than `4`. Remember the difference between the [`&&`](glossary://logical%20AND%20operator) and [`||`](glossary://logical%20OR%20operator) operators.",
"If a coordinate meets the conditions of your `if` statement, append it to the `blockSet` array using `blockSet.append(coordinate)`.",
"After you've appended all coordinates to `blockSet`, [iterate](glossary://iteration) over the array to place `6` blocks at each coordinate."
]


let solution: String? = "```swift\nlet allCoordinates = world.allPossibleCoordinates\nvar blockSet: [Coordinate] = []\n\nfor coordinate in allCoordinates {\n  if coordinate.column > 5 || coordinate.row < 4 {\n      blockSet.append(coordinate)\n   }\n}\n\nfor coordinate in blockSet {\n   for i in 1...6 {\n      world.place(Block(), at: coordinate)\n   }\n}"


public func assessmentPoint() -> AssessmentResults {
    return updateAssessment(successMessage: success, failureHints: hints, solution: solution)
}
