// 
//  Assessments.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//

import Foundation

let success = NSLocalizedString("### Great work! \nYou just solved a tough challenge! By examining a problem and choosing which skills to use, you’re teaching your brain to recognize how to solve a range of problems. As you gain experience, you’ll be able to solve new problems more quickly and effectively. \n\n[**Next Page**](@next)", comment:"Success message")
var hints = [
    NSLocalizedString("Take a minute to examine the puzzle and see which of the skills you've learned so far will be most useful in solving it. There are many different solutions, so give one of your ideas a try!", comment:"Hint"),
    NSLocalizedString("Just like in the previous puzzle, you’ll need to use [dot notation](glossary://dot%20notation) to modify the [state](glossary://state) of each portal [instance](glossary://instance) separately. \nExample: `greenPortal.isActive = true`", comment:"Hint"),
    NSLocalizedString("This puzzle is a **challenge** and has no provided solution. Strengthen your coding skills by creating your own approach to solving it.", comment:"Hint")

]

let solution: String? = nil


public func assessmentPoint() -> AssessmentResults {
    return updateAssessment(successMessage: success, failureHints: hints, solution: solution)
}
