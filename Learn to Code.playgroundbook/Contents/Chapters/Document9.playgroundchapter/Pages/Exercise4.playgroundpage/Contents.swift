/*:
**Goal:** Collect as many gems as there are switches.
 
In this puzzle, you'll use a [constant](glossary://constant) called `switchCounter` to collect as many gems as there are switches. Like a [variable](glossary://variable), a constant is a named container that stores a value. However, the value of a constant *cannot* change while the program is running.

 You [declare](glossary://declaration) a constant using the word `let` instead of `var`, and you use it when you know that a value won’t change.
 
* callout(Declaring a constant):

     `let numberOfTries = 3`

To solve this puzzle, you’ll write conditional code that compares the value of a gem-counting variable with the constant `switchCounter`, using a [comparison operator](glossary://comparison%20operator) such as `<`, `>`, `==`, or `!=`.

1. steps: Declare a variable to track the number of gems Byte collects.
2. Compare the value of your gem-counting variable with `switchCounter` to determine when to stop Byte from collecting gems.
*/
//#-hidden-code
playgroundPrologue()
//#-end-hidden-code
//#-code-completion(everything, hide)
//#-code-completion(currentmodule, show)
//#-code-completion(identifier, show, isOnOpenSwitch, if, func, for, while, moveForward(), turnLeft(), turnRight(), collectGem(), toggleSwitch(), isOnGem, isOnClosedSwitch, var, =, <, >, ==, !=, +, -, switchCount, isBlocked, true, false, isBlockedLeft, &&, ||, !, isBlockedRight)
//#-editable-code Tap to enter code
let switchCounter = numberOfSwitches
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
