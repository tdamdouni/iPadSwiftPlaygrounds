// 
//  Assessments.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//

import Foundation

let success = NSLocalizedString("### Monumental! \nWhen you have a [type](glossary://type) like `Expert`, you can create as many [instances](glossary://instance) of that type as you want. Because they all came from the same blueprint, you can call the same [methods](glossary://method) to access the same [properties](glossary://property) on any instance of that type. \n\n[**Next Page**](@next)", comment:"Success message")
let hints = [
    NSLocalizedString("You can [initialize](glossary://initialization) two instances of the `Expert` type; just be sure to give them different names.", comment:"Hint"),
    NSLocalizedString("Place both experts into the puzzle world using the `world.place` method.", comment:"Hint"),
    NSLocalizedString("You'll need your experts to work together to solve this puzzle.", comment:"Hint"),
    NSLocalizedString("This puzzle is a **challenge** and has no provided solution. Strengthen your coding skills by creating your own approach to solving it.", comment:"Hint")

]

let solution: String? = nil


public func assessmentPoint() -> AssessmentResults {
    return updateAssessment(successMessage: success, failureHints: hints, solution: solution)
}
