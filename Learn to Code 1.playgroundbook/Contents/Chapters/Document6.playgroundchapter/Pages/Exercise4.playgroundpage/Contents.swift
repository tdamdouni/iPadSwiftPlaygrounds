//#-hidden-code
//
//  Contents.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
//#-end-hidden-code
/*:
 **Goal:** Use a loop inside another loop to move around a spiral.
 
In this puzzle, notice the spiral of gems, one at each turning point. To solve the puzzle, you'll need to [nest](glossary://nest) one [loop](glossary://loop) inside another. Don't worry—it's not as hard as it sounds!

Before you write your code, think it through. For the first side of the spiral, you have to move forward until there's a gem to collect. After collecting the gem, you turn left, ready to start down the next side of the spiral. This [pattern](glossary://pattern) repeats until you reach the point farthest inside the spiral, becoming blocked.

When you write code that uses nested loops, you need to think backward. The first loop you write for this puzzle represents the last part of the logic above. That's the "repeat until blocked" part.
 
 1. steps: Add a condition to the [outer loop](glossary://outer%20loop) so that the [inner loop](glossary://inner%20loop) repeats until your character is blocked.
 2.  Adjust your inner loop to move forward until there's a gem to collect.
 3.  Once your character reaches a gem, collect the gem and turn left.
*/
//#-code-completion(everything, hide)
//#-code-completion(currentmodule, show)
//#-code-completion(identifier, show, isOnOpenSwitch, moveForward(), turnLeft(), turnRight(), collectGem(), toggleSwitch(), isOnGem, isOnClosedSwitch, isBlocked, isBlockedLeft, &&, ||, !, isBlockedRight, if, while, func, for)
//#-hidden-code
playgroundPrologue()
//#-end-hidden-code
while /*#-editable-code Condition*/<#Condition#>/*#-end-editable-code*/ {
    while /*#-editable-code Condition*/<#Condition#>/*#-end-editable-code*/ {
        //#-editable-code Add commands to your loop
    
        //#-end-editable-code
    }
    //#-editable-code Add commands to your loop
    
    //#-end-editable-code
}

//#-hidden-code
playgroundEpilogue()
//#-end-hidden-code

