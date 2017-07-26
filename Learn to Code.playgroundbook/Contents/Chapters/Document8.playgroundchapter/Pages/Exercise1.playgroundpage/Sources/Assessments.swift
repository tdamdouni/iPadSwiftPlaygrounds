// 
//  Assessments.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
let solution = "```swift\nfunc navigateAroundWall() {\n    if isBlockedRight {\n        moveForward()\n    }  else {\n        turnRight()\n        moveForward()\n    }\n}\n\nwhile !isOnOpenSwitch() {\n    while !isOnGem && !isOnClosedSwitch {\n        navigateAroundWall()\n    }\n    if isOnGem {\n        collectGem()\n    } else {\n        toggleSwitch()\n    }\n    turnLeft()\n    turnLeft()\n}\n"

import PlaygroundSupport
public func assessmentPoint() -> AssessmentResults {
    pageIdentifier = "Using_the_Right_Hand_Rule"
    
    
    let success = "### Incredible! \nBy writing a set of instructions and rules to follow, you've created an algorithm. Your algorithm can solve this puzzle no matter what size any of the walls are, making it reusable and adaptable to different situations. Next, you'll see if the same algorithm works in a slightly different puzzle, or if you'll have to tweak it a bit. \n\n[Next Page](@next)"
    var hints = [
                    "Start by running the code provided. The function `navigateAroundWall()` will move Byte all the way around one of the walls in the puzzle world. Work with the existing code, tweaking it so that Byte picks up all the gems and toggles the switch at the furthest corner of the world.",
                    "This puzzle has many different solutions, so trust your instincts and try different ideas until one works. A good way to begin is to think through (or write down) how you want Byte to solve the puzzle, and then translate your thoughts into code.",
                    "Use a `while` loop to repeat a set of actions while Byte is not yet on the switch."
        
    ]
    
    
//    switch currentPageRunCount {
//        
//    case 2..<4:
//        hints[0] = "When you [call](glossary://call) `navigateAroundWall()`, Byte moves around the wall until reaching the gem. Before Byte can go around the next wall, you need to turn Byte around. Remember, you can always nest your `while` loops. \n\n[Need a refresher?](While%20Loops/Nesting%20Loops)"
//    case 4..<6:
//        hints[0] = "When Byte reaches the gem, collect it turn Byte around. Then run `navigateAroundWall()` again to walk Byte around the next wall. Better yet, figure out a way to walk continuously around walls, collecting the gems until Byte reaches the switch."
//    case 5..<8:
//        hints[0] = "Keep trying! The harder you work to solve a problem, the better you will remember it later. Your brain will thank you for your persistence."
//        
//    default:
//        break
//        
//    }
//    
    
    
    
    return updateAssessment(successMessage: success, failureHints: hints, solution: solution)
}
