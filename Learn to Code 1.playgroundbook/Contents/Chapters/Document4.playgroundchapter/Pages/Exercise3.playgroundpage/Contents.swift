//#-hidden-code
//
//  Contents.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
//#-end-hidden-code
/*:
 **Goal:** Use an [``if`` statement](glossary://if%20statement) inside a loop to toggle a switch or collect a gem.
 
In this puzzle, there are 12 tiles containing a gem, a switch, or a portal. If there is a gem on the tile, collect it. If there is a closed switch, toggle it open. If there is a portal, simply move forward. Watch the [wireframes](glossary://wireframe) when you run the puzzle—they show the possible items that might appear.

Instead of writing a long series of [``if`` statements](glossary://if%20statement), you can combine the power of conditional statements with loops, and write your logic inside a [``for`` loop](glossary://for%20loop).

And, because a tile might contain a gem, a switch, or neither, this is a great opportunity to use an [``else if`` block](glossary://else%20if%20block) to check another condition.

1. steps: In the `for` loop below, add an `if` statement after `moveForward()` to check `isOnGem` or `isOnClosedSwitch`.
2. In your `if` statement, tap `if` and add an `else if` block to check another condition.
*/
//#-code-completion(everything, hide)
//#-code-completion(currentmodule, show)
//#-code-completion(identifier, show, isOnOpenSwitch, moveForward(), turnLeft(), collectGem(), toggleSwitch(), turnRight(), if, func, for, isOnGem, isOnClosedSwitch)
//#-hidden-code
playgroundPrologue()
//#-end-hidden-code
for i in 1 ... /*#-editable-code*/<#T##number##Int#>/*#-end-editable-code*/ {
    //#-editable-code Tap to enter code
    moveForward()
    
    //#-end-editable-code
}

//#-hidden-code
playgroundEpilogue()
//#-end-hidden-code

