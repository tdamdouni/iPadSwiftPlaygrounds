/*:
 **Goal:** Add stairs to solve the puzzle.
 
 Your next world-building element is a set of stairs. Unlike simple blocks, stairs need to face the right direction from low to high. You can use the same `place` [parameters](glossary://parameter) you used for your character and expert.
 
 * callout(Placing a stair): Here's how you would place north-facing stair at coordinate (2,3):
 
    `let newStair = Stair()`\
    `world.place(newStair, facing: north, atColumn: 2, row: 3)`
 
 However, you can use a *shortcut* to place stairs more quickly! Just [initialize](glossary://initialization) an [instance](glossary://instance) at the same time you place it.
 
  * callout(Shortcut): Instead of initializing your stair instance separately, this code creates an unnamed instance of [type](glossary://type) `Stair` and places it all with the same line of code:
 
    `world.place(Stair(), facing: north, atColumn: 1, row: 1)`

1. steps: Use the code above as a guide to place stairs into the puzzle. Try using the shortcut to place the stairs more efficiently.
2. Solve the puzzle using the rest of the coding skills you've learned so far.
*/
//#-code-completion(everything, hide)
//#-code-completion(currentmodule, show)
//#-code-completion(identifier, show, isOnOpenSwitch, if, func, for, while, moveForward(), turnLeft(), turnRight(), collectGem(), toggleSwitch(), isOnGem, Expert(), Character(), turnLockUp(), turnLockDown(), isOnClosedSwitch, var, let, ., =, <, >, ==, !=, +, -, isBlocked, move(distance:), jump(), true, false, turnLock(up:numberOfTimes:), world, place(_:facing:atColumn:row:), place(_:atColumn:row:), isBlockedLeft, &&, ||, !, isBlockedRight)
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
