// 
//  Assessments.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
let success = "### Fantastic job \nYou found the solution to the hardest problem yet! And guess what? You are now ready to move on to the next major skill—conditional code. \n\n[Introduction to Conditional Code](Conditional%20Code/Introduction)"


let solution = "```swift\nfunc turnAround() {\n    turnRight()\n    turnRight()\n}\n\nfunc collectFour() {\n    collectGem()\n    moveForward()\n    collectGem()\n    turnAround()\n    moveForward()\n    turnRight()\n    moveForward()\n    collectGem()\n    turnAround()\n    moveForward()\n    moveForward()\n    collectGem()\n}\n\nmoveForward()\n\nfor i in 1 ... 3 {\n    collectFour()\n    moveForward()\n    moveForward()\n}\ncollectFour()\n"

import PlaygroundSupport
public func assessmentPoint() -> AssessmentResults {
    
    var hints = [
                    "Notice how the placement in each set of four gems is exactly the same. Write the code for one set so that it works for all of the other sets.",
                    "Try solving one set of four, then move Byte through the portal, and add your loop to repeat that set of actions.",
                    
                    ]
    
//    switch currentPageRunCount {
//        
//    case 3..<6:
//        hints[0] = "### Remember, this is a challenge! \nYou can skip it and come back later."
//    case 6..<12:
//        hints[0] = "Here's one way to solve the challenge:\n\n```swift\nfunc turnAround() {\n    turnRight()\n    turnRight()\n}\n\nfunc collectFour() {\n    collectGem()\n    moveForward()\n    collectGem()\n    turnAround()\n    moveForward()\n    turnRight()\n    moveForward()\n    collectGem()\n    turnAround()\n    moveForward()\n    moveForward()\n    collectGem()\n}\n\nmoveForward()\n\nfor i in 1 ... 4 {\n    collectFour()\n    moveForward()\n    moveForward()\n}"
//    default:
//        break
//        
//    }
//    
    
    return updateAssessment(successMessage: success, failureHints: hints, solution: solution)
}
