// 
//  Assessments.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
let success = "### Wonderful work! \nYou've completed Learn to Code 2. Go ahead and celebrate; that’s quite an accomplishment! But it’s not the end of your journey-it’s only the beginning. Learning to code is like learning to speak a language-you need to practice to get better. Try using your new skills in some of the earlier puzzles, and see if you can solve them by using more advanced solutions. Or better yet, try Learn to Code 3 and some coding challenges. However you choose to practice, get out there and keep coding!\n\n[**Continue coding**](playgrounds://featured)"
let hints = [
"Use all of the knowledge you’ve gained in Learn to Code 2 to create something cool!",
"Try going back and revisiting some of the skills you’ve learned. How can you use those skills to create an interesting effect in your world?",
"Feel free to come back and continue to build on your world at any time. Sometimes a piece of code will come into your mind at a random moment in your day-don't hesitate to come back and try writing it out!"
]

let solution: String? = nil


public func assessmentPoint() -> AssessmentResults {
    return updateAssessment(successMessage: success, failureHints: hints, solution: solution)
}
