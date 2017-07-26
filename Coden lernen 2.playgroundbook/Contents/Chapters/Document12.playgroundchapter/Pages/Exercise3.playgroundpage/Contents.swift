//#-hidden-code
//
//  Contents.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//
//#-end-hidden-code
/*:#localized(key: "FirstProseBlock")
 **Goal:** Add stairs to solve the puzzle.
 
Your next world-building element is a set of stairs. Unlike simple blocks, stairs need to face the right direction, from low side to high side. Remember, you can choose a direction by passing `.north,` `.south,` `.east,` or `.west` into the `facing` parameter.
 
* callout(Placing stairs): Here's how you would place north-facing stairs at coordinate `(2,3)`:
 
    `let newStair = Stair()`\
    `world.place(newStair, facing: .north, atColumn: 2, row: 3)`
 
 However, you can use a *shortcut* to place the stairs more quickly! Instead of [initializing](glossary://initialization) your stairs [instance](glossary://instance) separately, you can initialize and place the instance at the same time.

 
* callout(Shortcut): This line of code initializes and places an unnamed instance of [type](glossary://type) `Stair`:
 
    `world.place(Stair(), facing: .north, atColumn: 1, row: 1)`

1. steps: Use the code above as a guide to place stairs in the puzzle world. Try using the shortcut to place the stairs more efficiently.
2. Solve the puzzle using the rest of the coding skills you've learned so far.
*/
//#-code-completion(everything, hide)
//#-code-completion(currentmodule, show)
//#-code-completion(identifier, show, isOnOpenSwitch, if, func, for, while, moveForward(), turnLeft(), turnRight(), collectGem(), toggleSwitch(), north, south, east, west, Expert, Character, (, ), (), Block, Stair, turnLockUp(), turnLockDown(), isOnClosedSwitch, var, let, ., =, <, >, ==, !=, +=, +, -, isBlocked, isOnGem, move(distance:), jump(), true, false, turnLock(up:numberOfTimes:), place(_:atStartColumn:startRow:atEndColumn:endRow:), world, place(_:facing:atColumn:row:), place(_:atColumn:row:), isBlockedLeft, &&, ||, !, isBlockedRight)
//#-hidden-code
playgroundPrologue()
typealias Character = Actor
//#-end-hidden-code
//#-editable-code Tap to enter code

//#-end-editable-code
//#-hidden-code
playgroundEpilogue()
//#-end-hidden-code

