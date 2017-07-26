// 
//  Assessments.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
let success = "### Wonderful work! \nYou've completed Learn to Code. Go ahead and celebrate; that’s quite an accomplishment! However, it’s not the end of your journey-it’s only the beginning. Learning to code is like learning to speak a language; you need to practice to get better. Try using your new skills in some of the previous levels, and see if you can solve them by using more advanced solutions. Or better yet, try some coding challenges. However you choose to practice, get out there and keep coding!"
let hints = [
    "You can build your world however you’d like. The sky is the limit!"
]

let solution: String? = nil


public func assessmentPoint() -> AssessmentResults {
    return updateAssessment(successMessage: success, failureHints: hints, solution: solution)
}
