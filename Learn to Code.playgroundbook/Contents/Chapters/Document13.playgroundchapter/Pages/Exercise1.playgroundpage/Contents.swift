/*:
 **Goal:** Add a new block to bridge two worlds.
 
 Up to now, the puzzle world has been defined for you. Are you ready to start making changes to that world? A switch that you’ll need to activate is in an unreachable area, so you’ll need to add a tile to connect the two pieces of this puzzle.
 
 * callout(Placing a block): Here's how you would place a block at coordinate (1,1):
 
    `let block1 = Block()`\
    `world.place(block1, atColumn: 1, row: 1)`
 
 
 1. steps: First, create an [instance](glossary://instance) of type `Block`.
 2. Next, use [dot notation](glossary://dot%20notation) to access the `world` instance and [call](glossary://call) the `place` [method](glossary://method).
 3. Pass your [arguments](glossary://argument) into the `place` method. Use your `Block` instance for the `node` parameter, and a set of coordinates for the `atColumn` and `row` parameters.

*/
//#-hidden-code
playgroundPrologue()
//#-end-hidden-code
//#-code-completion(everything, hide)
//#-code-completion(currentmodule, show)
//#-code-completion(identifier, show, isOnOpenSwitch, if, func, for, while, moveForward(), turnLeft(), turnRight(), collectGem(), toggleSwitch(), isOnGem, Expert(), Character(), turnLockUp(), turnLockDown(), isOnClosedSwitch, var, let, ., =, <, >, ==, !=, +, -, isBlocked, move(distance:), jump(), true, false, turnLock(up:numberOfTimes:), world, place(_:facing:atColumn:row:), place(_:atColumn:row:), isBlockedLeft, &&, ||, !, isBlockedRight)
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
