//#-hidden-code
//
//  Contents.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
//#-end-hidden-code
/*:
 **Goal:** Adjust your algorithm to navigate around extra blocks.
 
This puzzle is similar to the previous one, but it has additional blocks around the walls.
 
The code below uses the algorithm from the previous puzzle. To solve this new puzzle, you'll need to tweak the algorithm.
 
 1. steps: Use [pseudocode](glossary://pseudocode) to plan a workable algorithm.
 2. Before tweaking the code below, walk through the pseudocode in your mind to be sure your algorithm will work.
 3. Write code to implement the algorithm.
*/
//#-code-completion(everything, hide)
//#-code-completion(currentmodule, show)
//#-code-completion(identifier, show, isOnOpenSwitch, moveForward(), turnLeft(), turnRight(), collectGem(), toggleSwitch(), isOnGem, isOnClosedSwitch, isBlocked, isBlockedLeft, &&, ||, !, isBlockedRight, if, while, func, for)
//#-hidden-code
playgroundPrologue()
//#-end-hidden-code
//#-editable-code
func navigateAroundWall() {
    if isBlockedRight {
        moveForward()
    }  else {
        turnRight()
        moveForward()
    }
}
    
while !isOnOpenSwitch {
    while !isOnGem && !isOnClosedSwitch {
        navigateAroundWall()
    }
    if isOnGem {
        collectGem()
    } else {
        toggleSwitch()
    }
    turnLeft()
    turnLeft()
}
//#-end-editable-code

//#-hidden-code
playgroundEpilogue()
//#-end-hidden-code

