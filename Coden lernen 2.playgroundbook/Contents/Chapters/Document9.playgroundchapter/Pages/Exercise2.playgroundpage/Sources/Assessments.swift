// 
//  Assessments.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//

import Foundation

let success = NSLocalizedString("### Nice work! \nWhen you reference each portal by its [instance](glossary://instance) name, you can control specific elements of the puzzle world. You'll start to see how useful this becomes as you continue to add more skills to your coding tool belt. \n\n[**Next Page**](@next)", comment:"Success message")
let hints = [
    NSLocalizedString("First, teleport your character through the blue portal to reach the gems at the opposite portal. You might need to deactivate the blue portal to get both gems.", comment:"Hint"),
    NSLocalizedString("Deactivate the pink portal so your character can reach the gem behind it. Then reactivate the portal to teleport to the final gem.", comment:"Hint")
]

let solution = "```swift\nfunc moveCollect() {\n   moveForward()\n   collectGem()\n}\n\nfunc turnAround() {\n   turnLeft()\n   turnLeft()\n}\n\nmoveForward()\nmoveCollect()\nturnAround()\nbluePortal.isActive = false\nmoveForward()\nmoveCollect()\nturnAround()\nbluePortal.isActive = true\npinkPortal.isActive = false\nmoveForward()\nmoveForward()\nmoveForward()\ncollectGem()\nturnAround()\npinkPortal.isActive = true\nmoveForward()\nturnAround()\nmoveCollect()\n```"


public func assessmentPoint() -> AssessmentResults {
    return updateAssessment(successMessage: success, failureHints: hints, solution: solution)
}
