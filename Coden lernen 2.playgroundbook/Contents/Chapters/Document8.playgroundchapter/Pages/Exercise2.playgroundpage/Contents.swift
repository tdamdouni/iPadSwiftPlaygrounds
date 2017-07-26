//#-hidden-code
//
//  Contents.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//
//#-end-hidden-code
/*:#localized(key: "FirstProseBlock")
**Goal:** Increment your variable to track the number of gems collected.
 
In the previous challenge, if you didn't know the number of gems in the puzzle, you couldn’t set exact values like `1`, `2`, or `3`. You’d need to increase the value of the [variable](glossary://variable) compared to its current value. This coding pattern is known as *incrementing a value*.

 * callout(Incrementing a value):

     `var myNumber = 0`\
     `myNumber = myNumber + 1`
 
This puzzle creates a random number of gems each time you run it. You won’t know whether a gem is at a specific location, so you'll need to check each tile. Wherever there's a gem, you’ll need to collect it and increment the `gemCounter` value by `1`.
 
 1. steps: [Assign](glossary://assignment) `gemCounter` a beginning value of `0`.
 2. Write code to check for a gem at each tile.
 3. Wherever there's a gem, collect it and increment the `gemCounter` value by `1`.
*/
//#-hidden-code
playgroundPrologue()
//#-end-hidden-code
//#-code-completion(everything, hide)
//#-code-completion(currentmodule, show)
//#-code-completion(identifier, show, isOnOpenSwitch, moveForward(), turnLeft(), turnRight(), collectGem(), toggleSwitch(), isOnGem, isOnClosedSwitch, var, =, <, >, ==, !=, +=, +, -, isBlocked, true, false, isBlockedLeft, &&, ||, !, isBlockedRight, if, func, for, while)
var gemCounter = /*#-editable-code yourFuncName*/<#T##value##Int#>/*#-end-editable-code*/
//#-editable-code Tap to enter code

//#-end-editable-code
//#-hidden-code
finalGemCount = gemCounter
playgroundEpilogue()
//#-end-hidden-code

