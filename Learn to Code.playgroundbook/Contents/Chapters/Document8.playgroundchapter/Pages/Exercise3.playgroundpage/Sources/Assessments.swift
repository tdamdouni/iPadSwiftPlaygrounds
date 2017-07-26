// 
//  Assessments.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
let solution = "```swift\nfunc navigateAroundWalls() {\n    if isBlockedRight && isBlocked {\n        turnLeft()\n    }  else if isBlockedRight {\n        moveForward()\n    } else {\n        turnRight()\n        moveForward()\n    }\n}\n\nwhile !isOnGem {\n    navigateAroundWalls()\n}\ncollectGem()\n"

import PlaygroundSupport
public func assessmentPoint() -> AssessmentResults {
    pageIdentifier = "Conquering_A_Maze"
    
    
    let success = "### Wow! \nYou have really improved your programming skills. By creating and tweaking your algorithm in these recent puzzles, you've created a powerful bit of code that will continue to work in new situations. Now that you've mastered solving a maze, see if you can generate algorithms to solve different scenarios. \n\n[Next Page](@next)"
    var hints = [
            "Even though this puzzle looks different from others you've seen, you can still solve it using the right hand rule. Always follow the right wall of the maze, and Byte will eventually reach the gem.",
            "Start by using your code from the previous solution, and figure out how to tweak it to work in the maze. In this puzzle, the goal is to collect the gem at the end of the maze.",
                    ]
    
    
//    switch currentPageRunCount {
//        
//    case 2..<4:
//        hints[0] = "To follow the right wall of the maze, you'll need to create rules for what happens when Byte is blocked on the right and in front, for when Byte is blocked only on the right, and for when Byte is not blocked on the right."
//    case 4..<6:
//        hints[0] = "Use a `while` loop to run your code until Byte reaches the gem."
//    case 5..<9:
//        hints[0] = "You've got this! Experts know that sometimes taking a quick break before going back to a problem can actually help you figure it out. Why not try that if you're stumped?"
//    default:
//        break
//        
//    }
    
    
    
    
    return updateAssessment(successMessage: success, failureHints: hints, solution: solution)
}
