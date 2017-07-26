//#-hidden-code
//
//  Contents.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//
//#-end-hidden-code
/*:#localized(key: "FirstProseBlock")
 **Goal:** Use the Right-Hand Rule algorithm to navigate around walls.
 
Run this puzzle, and notice how your character stops after the first gem. The algorithm used here follows the [right-hand rule](glossary://right-hand%20rule) to move around walls. To solve the puzzle, you’ll need to tweak the algorithm, but first try using [pseudocode](glossary://pseudocode) to plan the action.

Pseudocode looks a bit like [Swift](glossary://Swift) code, but it’s worded and structured so humans can easily understand it.
 
    navigate around wall {
       if blocked to the right {
          move forward
       } else {
          turn right
          move forward
       }
    }
 
    while not on closed switch {
       navigate around wall
       if on gem {
          collect gem
          turn around
       }
    }
    toggle switch
 
 1. steps: Based on the pseudocode above, write out a solution in code for the puzzle.
 2. Run your code and tweak your algorithm, if necessary, to solve the puzzle.
*/
//#-code-completion(everything, hide)
//#-code-completion(currentmodule, show)
//#-code-completion(identifier, show, isOnOpenSwitch, moveForward(), turnLeft(), turnRight(), collectGem(), toggleSwitch(), isOnGem, isOnClosedSwitch, isBlocked, isBlockedLeft, &&, ||, !, isBlockedRight, if, while, func, for)
//#-hidden-code
playgroundPrologue()
//#-end-hidden-code
//#-copy-source(id1)
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
//#-end-copy-source

//#-hidden-code
playgroundEpilogue()
//#-end-hidden-code

