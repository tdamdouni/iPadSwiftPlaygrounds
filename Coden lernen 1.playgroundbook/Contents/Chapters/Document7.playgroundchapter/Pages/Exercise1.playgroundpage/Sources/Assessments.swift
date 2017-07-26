// 
//  Assessments.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//

import Foundation

let solution = "```swift\nfunc navigateAroundWall() {\n    if isBlockedRight {\n        moveForward()\n    }   else {\n        turnRight()\n        moveForward()\n    }\n}\n\nwhile !isOnClosedSwitch {\n    navigateAroundWall()\n    if isOnGem {\n        collectGem()\n        turnLeft()\n        turnLeft()\n    }\n}\ntoggleSwitch()"



import PlaygroundSupport
public func assessmentPoint() -> AssessmentResults {
    pageIdentifier = "Using_the_Right_Hand_Rule"
    
    
    let success = NSLocalizedString("### Incredible! \nBy writing a set of instructions and rules to follow, you've created an [algorithm](glossary://algorithm). Your algorithm can solve this puzzle no matter what size any of the walls are, making it [reusable](glossary://reusability) and adaptable to different situations. Next, you'll see if the same algorithm works in a slightly different puzzle, or if you'll have to tweak it a bit. \n\n[**Next Page**](@next)", comment:"Success message")
    var hints = [
                    NSLocalizedString("Start by running the code provided. The [function](glossary://function) `navigateAroundWall()` will move your character all the way around one of the walls in the puzzle world. Work with the existing code, tweaking it to collect all the gems and toggle the switch at the farthest corner of the world.", comment:"Hint"),
                    NSLocalizedString("This puzzle has many different solutions, so trust your instincts and try different ideas until one works. A good way to begin is to think through (or write down) how you want to solve the puzzle, and then translate your thoughts into code.", comment:"Hint"),
                    NSLocalizedString("Use a [`while` loop](glossary://while%20loop) to repeat a set of actions while your character is not yet on the switch.", comment:"Hint")
        
    ]
    
    
    switch currentPageRunCount {
        
    case 2..<4:
        hints[0] = NSLocalizedString("When you [call](glossary://call) `navigateAroundWall()`, your charcter moves around the wall until reaching the gem. Before moving around the next wall, you need to turn your character around. Remember, you can always nest your `while` loops. \n\n[Need a refresher?](Document6.playgroundchapter/Exercise4.playgroundpage)", comment:"Hint")
    case 4..<6:
        hints[0] = NSLocalizedString("When your character reaches the gem, collect it and turn around. Then run `navigateAroundWall()` again to walk around the next wall. Better yet, figure out a way to walk continuously around walls, collecting the gems until your character reaches the switch.", comment:"Hint")
    case 5..<8:
        hints[0] = NSLocalizedString("Keep trying! The harder you work to solve a problem, the better you'll remember it later. Your brain will thank you for your persistence.", comment:"Hint")
        
    default:
        break
        
    }
    
    
    
    
    return updateAssessment(successMessage: success, failureHints: hints, solution: solution)
}
