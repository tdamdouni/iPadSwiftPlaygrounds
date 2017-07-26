// 
//  Assessments.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//

import Foundation

let success = NSLocalizedString("### Look how far you've come! \nYou can now change the very puzzles that you’ve been solving. Code has given you the power to change the world, even if it's only a puzzle world for now. Ready to build one final puzzle? \n\n[**Next Page**](@next)", comment:"Success message")
let hints = [
    NSLocalizedString("Call [methods](glossary://method) on `world` to change the puzzle world, adding or removing whatever parts you’d like to change! After you've added some gems and switches, use your character to solve the puzzle you’ve created.", comment:"Hint")
]


let solution: String? = nil 


public func assessmentPoint() -> AssessmentResults {
    return updateAssessment(successMessage: success, failureHints: hints, solution: solution)
}
