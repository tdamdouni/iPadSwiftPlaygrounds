/*:
 **Goal:** Use a loop to keep Byte moving while not blocked.
 
This puzzle has a line of switches, with a different number of switches each time the puzzle runs. Instead of making Byte walk the entire line, checking each step for a switch to toggle open, you can use a form of [conditional code](glossary://conditional%20code) called a [``while`` loop](glossary://while%20loop).

Just like [`if` statements](glossary://if%20statement), `while` loops allow you to determine when your code will run. A `while` loop runs a code block for as long as a [Boolean](glossary://Boolean) condition is true. When the condition is false, the while loop stops running.
 
1. steps: Choose a Boolean condition for your `while` loop to determine when it will run.
2. Add commands to the `while` block to toggle open all the switches.
*/
//#-code-completion(everything, hide)
//#-code-completion(currentmodule, show)
//#-code-completion(identifier, show, isOnOpenSwitch, moveForward(), turnLeft(), turnRight(), collectGem(), toggleSwitch(), isOnGem, isOnClosedSwitch, isBlocked, isBlockedLeft, &&, ||, !, isBlockedRight, if, while, func, for)
//#-hidden-code
playgroundPrologue()
//#-end-hidden-code
while /*#-editable-code yourFuncName*/<#condition#>/*#-end-editable-code*/ {
    //#-editable-code

    //#-end-editable-code
}

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
