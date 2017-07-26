/*:
**Goal:** Place a character and an expert, then use the `jump()` ability to solve the puzzle.
 
 In this puzzle, you'll choose starting locations for both your character and your expert. You'll also need a new ability to solve this puzzle. Just as your expert has the special skill of turning locks, your character has the special skill of jumping.
 
 * callout(New ability!): The `Character` [type](glossary://type) has the ability to jump up and down when you use the following command:

     `jump()`
 
 1. steps: Identify starting locations for your character and your expert.
 2. [Initialize](glossary://initialization) both characters and place them at your starting locations.
 3. Use the `jump()` command to make your character jump when needed to solve the puzzle.
*/
//#-code-completion(everything, hide)
//#-code-completion(currentmodule, show)
//#-code-completion(identifier, show, isOnOpenSwitch, if, func, for, while, moveForward(), turnLeft(), turnRight(), collectGem(), toggleSwitch(), isOnGem, Expert(), Character(), turnLockUp(), turnLockDown(), isOnClosedSwitch, var, let, ., =, <, >, ==, !=, +, -, isBlocked, move(distance:), world, place(_:facing:atColumn:row:), true, false, turnLock(up:numberOfTimes:), world, place(_:facing:atColumn:row:), place(_:atColumn:row:), isBlockedLeft, &&, ||, !, isBlockedRight, jump())
//#-hidden-code
playgroundPrologue()
//#-end-hidden-code
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
