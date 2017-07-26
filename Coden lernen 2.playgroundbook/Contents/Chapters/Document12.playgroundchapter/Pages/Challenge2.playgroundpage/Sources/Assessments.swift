// 
//  Assessments.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//

import Foundation

let success = NSLocalizedString("### Impressive! \nEvery time you figure out a new solution, you gain a better sense of which solutions will work for a certain kind of problem. The next time you see something similar, you’ll already have a hunch about how to solve it! \n\n[**Next Page**](@next)", comment:"Success message")
let hints = [
    NSLocalizedString("There are many different ways to solve this puzzle. Use your world-building skills to add blocks, portals, and stairs that will help you solve the puzzle in whatever way you think will work best.", comment:"Hint"),
    NSLocalizedString("You need to add an [instance](glossary://instance) of your character or the expert to solve this puzzle. In case you’ve forgotten, [here's a refresher](Document11.playgroundchapter/Exercise3.playgroundpage).", comment:"Hint"),
    NSLocalizedString("Don't be afraid to try different approaches to solving this puzzle. Coders often don’t get things right on the first try!", comment:"Hint"),
    NSLocalizedString("This puzzle is a **challenge** and has no provided solution. Strengthen your coding skills by creating your own approach to solving it.", comment:"Hint")

]


let solution: String? = nil


public func assessmentPoint() -> AssessmentResults {
    return updateAssessment(successMessage: success, failureHints: hints, solution: solution)
}
