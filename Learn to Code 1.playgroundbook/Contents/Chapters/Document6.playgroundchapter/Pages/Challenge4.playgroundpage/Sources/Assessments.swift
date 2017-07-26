// 
//  Assessments.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
let success = "### Phenomenal! \nNotice how even small bits of code can be extremely powerful and can work in many different situations. You’re starting to write code that is adaptable and reusable, which is what professional coders strive for! \n\n[**Next Page**](@next)"

let solution: String? = nil

public func assessmentPoint() -> AssessmentResults {
    pageIdentifier = "Random Rectangles"

    var hints = [
        "The size of this puzzle world will change every time you run your code, but it will always be shaped like a rectangle.",
        "Use [nested loops](glossary://nest) to run one [`while` loop](glossary://while%20loop) as long as another `while` loop condition is true.",
        "Run the [outer loop](glossary://outer%20loop) until you reach the switch, and run the [inner loop](glossary://inner%20loop) until you reach the end of one side of the rectangle.",
        "This puzzle is a **challenge** and has no provided solution. Strengthen your coding skills by creating your own approach to solving it."

    ]
    
    switch currentPageRunCount {
    
    case 0..<5:
        break
    case 5...7:
        hints[0] = "You're doing great! Some of the best programmers in the world try and fail often. Every time you correct a mistake, your brain gets a little better at what you're doing, even if it doesn't feel that way!"
    default:
        break
   
        
    }
    
    
    return updateAssessment(successMessage: success, failureHints: hints, solution: solution)
}




