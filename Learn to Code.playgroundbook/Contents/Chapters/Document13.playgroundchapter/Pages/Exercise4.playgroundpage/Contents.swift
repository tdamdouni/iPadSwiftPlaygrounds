/*:
 **Goal:** Change all elements of the world to create your own puzzle!
 
 In addition to placing new blocks, stairs, and portals, you can also add gems and switches.
 
 * callout(Adding gems and switches): Just like when you add a block, you use the `place` [method](glossary://method) on `world` to place gems and switches.

     `world.place(Gem(), atColumn: 2, row: 3)`\
     `world.place(Switch(), atColumn, 3, row: 5)`
 
You can even use code to *remove* existing blocks.
 
* callout(Removing items): Here's how you would remove all existing items at coordinate (2,3):

     `world.removeItems(atColumn: 2, row: 3)`
 
 The shortcut bar contains the [methods](glossary://method) available on the `world` [instance](glossary://instance). See if you can figure out how to add a wall without seeing the code here first!
 
 1. steps: Add, change, or remove existing parts of the puzzle world by calling methods on the `world` instance.
 2. After you've added a few gems and switches, use your character to solve the puzzle.
*/
//#-code-completion(everything, hide)
//#-code-completion(currentmodule, show)
//#-code-completion(identifier, show, isOnOpenSwitch, if, func, for, while, moveForward(), turnLeft(), turnRight(), collectGem(), toggleSwitch(), isOnGem, Expert(), Character(), turnLockUp(), turnLockDown(), isOnClosedSwitch, var, let, ., =, <, >, ==, !=, +, -, isBlocked, move(distance:), jump(), true, false, turnLock(up:numberOfTimes:), world, place(_:facing:atColumn:row:), place(_:atColumn:row:), removeBlock(atColumn:row:), isBlockedLeft, &&, ||, !, isBlockedRight)
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
