// 
//  Assessments.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//

import Foundation

let success = NSLocalizedString("### Pretty cool, huh? \n\nWhen you want to add an item to an array, just add a comma and an item that matches the [type](glossary://type) of the other items in the array. \n\nRemember, after you create an array of a certain type (such as an array of [integers](glossary://Int)), it can't hold items of a different type (such as a [String](glossary://String)). \n\n[**Next Page**](@next)", comment:"Success message")
let hints = [
NSLocalizedString("Look out for code comments!\n\n     // This is a code comment. Read it for guidance toward your goal.\n\n Code comments help you organize your code and keep track of what's happening in each section. Read the provided code comments to guide you toward completing the code on each page.", comment:"Hint"),
NSLocalizedString("You need to place an instance of your character on each tile in the puzzle world. Modify your [array](glossary://array) so that it includes all row values from `0` to `5`.", comment:"Hint"),
NSLocalizedString("Each [Int](glossary://Int) value that you add to `rows` is passed into the `placeCharacters` [function](glossary://function). Be sure to include all row values so that your character appears on every tile.", comment:"Hint")
]


let solution: String? = "```swift\nvar rows = [0,1,2,3,4,5]\n\nplaceCharacters(at: rows)"


public func assessmentPoint() -> AssessmentResults {
    return updateAssessment(successMessage: success, failureHints: hints, solution: solution)
}
