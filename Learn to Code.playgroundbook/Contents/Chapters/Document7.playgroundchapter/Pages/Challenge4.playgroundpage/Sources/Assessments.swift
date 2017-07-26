// 
//  Assessments.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
let success = "### Phenomenal! \nNotice how even small bits of code can be extremely powerful and can work in many different situations. You’re starting to write code that is adaptable and reusable, which is what professional coders strive for! \n\n[Next Page](@next)"

let solution: String? = "```swift\nwhile !isBlocked {\n    while !isBlocked {\n        moveForward()\n    }\n    turnRight()\n}\ntoggleSwitch()\n"

public func assessmentPoint() -> AssessmentResults {
    pageIdentifier = "Random Rectangles"

    var hints = [
        "The size of this puzzle world will change every time you run your code, but it will always be shaped like a rectangle.",
        "Use nested loops to run one `while` loop so long as another `while` loop condition is true.",
        "Run the outer loop until Byte reaches the switch, and run the inner loop until Byte reaches the end of one side of the rectangle."
    ]
    
//    switch currentPageRunCount {
//        
//    case 4..<6:
//        hints[0] = "You're doing great! Some of the smartest people in the world try and fail often. Every time you make a mistake, your brain gets a little better at what you're doing, even if it doesn't feel that way!"
//    case 5..<15:
//        solution = "Here's one way to solve the puzzle:\n\n```swift\nwhile !isBlocked {\n    while !isBlocked {\n        moveForward()\n    }\n    turnRight()\n}\ntoggleSwitch()\n"
//    default:
//        break
//        
//    }
    
    
    return updateAssessment(successMessage: success, failureHints: hints, solution: solution)
}




