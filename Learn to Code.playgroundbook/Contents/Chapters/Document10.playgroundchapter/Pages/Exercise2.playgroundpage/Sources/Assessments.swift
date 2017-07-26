// 
//  Assessments.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
let success = "### Nice work! \nWhen you reference each portal by its [instance](glossary://instance) name, you can control specific elements of the puzzle world. You'll start to see how useful this becomes as you continue to add more skills to your coding tool belt. \n\n[Next Page](@next)"
let hints = [
    "First, teleport Byte through the blue portal to reach the gems at the opposite portal. You might need to deactivate the blue portal for Byte to get both gems.",
    "Deactivate the pink portal so Byte can reach the gem behind it. Then reactivate the portal to teleport Byte to the final gem."
]

let solution = "```swift\nfunc moveCollect() {\n    moveForward()\n    collectGem()\n}\n\nfunc turnAround() {\n    turnLeft()\n    turnLeft()\n}\n\nmoveForward()\nmoveCollect()\nturnAround()\nbluePortal.isActive = false\nmoveForward()\nmoveCollect()\nturnAround()\nbluePortal.isActive = true\npinkPortal.isActive = false\nmoveForward()\nmoveForward()\nmoveForward()\ncollectGem()\nturnAround()\npinkPortal.isActive = true\nmoveForward()\nturnAround()\nmoveCollect()\n```"


public func assessmentPoint() -> AssessmentResults {
    return updateAssessment(successMessage: success, failureHints: hints, solution: solution)
}
