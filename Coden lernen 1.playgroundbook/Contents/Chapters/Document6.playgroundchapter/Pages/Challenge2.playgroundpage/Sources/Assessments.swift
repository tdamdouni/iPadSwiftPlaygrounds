// 
//  Assessments.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//

import Foundation

let success = NSLocalizedString("### Right on! \nDeveloping your own solutions for new problems enables you to figure out what types of tools work in certain situations. As your skills grow, you’ll be able to choose those tools more quickly and intelligently. How awesome is that? \n\n[**Next Page**](@next)", comment:"Success message")

let solution: String? = nil

public func assessmentPoint() -> AssessmentResults {
    pageIdentifier = "Turned_Around"

    var hints = [
        NSLocalizedString("Think of all the tools you've learned about so far: [functions](glossary://function), [`for` loops](glossary://for%20loop), [`while` loops](glossary://while%20loop), [conditional code](glossary://conditional%20code), and [operators](glossary://logical%20operator). How can you use these existing tools to solve this puzzle?", comment:"Hint"),
        NSLocalizedString("This puzzle is a **challenge** and has no provided solution. Strengthen your coding skills by creating your own approach to solving it.", comment:"Hint")

        ]
    
    switch currentPageRunCount {
    
    case 0..<5:
        break
    case 5...7:
        hints[0] = NSLocalizedString("When you work hard to figure something out, you remember it far better than if you'd found the answer more easily. Keep trying now, or come back later to solve this challenge.", comment:"Hint")
    default:
        break
    }
    
    
    return updateAssessment(successMessage: success, failureHints: hints, solution: solution)
}



