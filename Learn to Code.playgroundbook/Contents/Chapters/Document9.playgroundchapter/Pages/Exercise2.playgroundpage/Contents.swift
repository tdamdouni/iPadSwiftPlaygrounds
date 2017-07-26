/*:
**Goal:** Increment your variable to track the number of gems Byte collects.
 
In the previous challenge, if you didn't know the number of gems in the puzzle, you couldn’t set exact values like 1, 2, or 3. You’d need to increase the value of the [variable](glossary://variable) compared to its current value. This coding pattern is known as *incrementing a value*.

 * callout(Incrementing a value):

     `var myNumber = 0`\
     `myNumber = myNumber + 1`
 
This puzzle creates a random number of gems each time you run it. You won’t know whether a gem is at a specific location, so you'll need to check each tile. Wherever there's a gem, you’ll need Byte to collect it and continue to the next tile, and then you can increment the `gemCounter` value by 1.
 
 1. steps: [Declare](glossary://declaration) a `gemCounter` variable and [assign](glossary://assignment) it a beginning value of `0`.
 2. Write code to check for a gem at each tile.
 3. Wherever there's a gem, collect it and increment the `gemCounter` value by `1`.
*/
//#-hidden-code
playgroundPrologue()
//#-end-hidden-code
//#-code-completion(everything, hide)
//#-code-completion(currentmodule, show)
//#-code-completion(identifier, show, isOnOpenSwitch, moveForward(), turnLeft(), turnRight(), collectGem(), toggleSwitch(), isOnGem, isOnClosedSwitch, var, =, <, >, ==, !=, +, -, isBlocked, true, false, isBlockedLeft, &&, ||, !, isBlockedRight, if, func, for, while)
//#-editable-code Tap to enter code

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
