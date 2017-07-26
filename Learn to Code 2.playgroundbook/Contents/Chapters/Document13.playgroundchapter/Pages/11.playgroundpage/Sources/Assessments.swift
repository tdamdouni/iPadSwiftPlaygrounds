// 
//  Assessments.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
let success = "### Incredible! \n\nThe ability to read and tweak existing code is extremely important for a coder. There will be many times when you’ll need to understand what someone else has written. In the future, you’ll start writing code comments of your own to make your code clear enough for others to understand. \n\n[**Next Page**](@next)"
let hints = [
"Remember to read the code comments to understand what each section is doing. It may even help you to play with the code a bit. Change something, rerun your code, and see what’s different. Repeat the process to help you discover all the places you can personalize your code.",
"There's no wrong way to complete this challenge-just change the code until you're happy with it!"
]

let solution: String? = nil


public func assessmentPoint() -> AssessmentResults {
    return updateAssessment(successMessage: success, failureHints: hints, solution: solution)
}
