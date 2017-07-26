/*:
 **Goal:** Use the Right-Hand Rule algorithm to help Byte navigate around walls.
 
Run this puzzle, and notice how Byte stops after the first gem. The algorithm used here follows the *right-hand rule* to move around walls. To solve the puzzle, you’ll need to tweak the algorithm, but first try using [pseudocode](glossary://pseudocode) to plan the action.

Pseudocode looks looks a bit like [Swift](glossary://Swift) code, but it’s worded and structured so humans can easily understand it. Here’s the `navigateAroundWall()` function written in pseudocode:
 
    navigate around wall {
       if blocked to the right {
          move forward
       } else {
          turn right
          move forward
       }
    }
 
 1. steps: Based upon the pseudocode above, create your own pseudocode to map out a possible solution for the puzzle.
 2. Using your pseudocode, write out an algorithm for Byte to collect each of the gems and toggle the final switch.
 3. Run your code and tweak your algorithm if necessary to solve the puzzle.

*/
//#-code-completion(everything, hide)
//#-code-completion(currentmodule, show)
//#-code-completion(identifier, show, isOnOpenSwitch, moveForward(), turnLeft(), turnRight(), collectGem(), toggleSwitch(), isOnGem, isOnClosedSwitch, isBlocked, isBlockedLeft, &&, ||, !, isBlockedRight, if, while, func, for)
//#-hidden-code
playgroundPrologue()
//#-end-hidden-code
//#-editable-code Tap to enter code
func navigateAroundWall() {
    if isBlockedRight {
        moveForward()
    }  else {
        turnRight()
        moveForward()
    }
}
    
while !isOnGem {
    navigateAroundWall()
}
//#-end-editable-code
 
//#-hidden-code
playgroundEpilogue()
//#-end-hidden-code
//#-hidden-code
//
//  Contents.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
//#-end-hidden-code
