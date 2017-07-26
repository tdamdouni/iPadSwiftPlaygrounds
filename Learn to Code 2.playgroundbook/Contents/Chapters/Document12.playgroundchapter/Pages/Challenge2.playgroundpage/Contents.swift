//#-hidden-code
//
//  Contents.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
//#-end-hidden-code
/*:
 **Challenge:** Add blocks, stairs, and portals.

 For this challenge, practice your world-building skills by adding all the elements needed to solve the puzzle. There are many different solutions, so decide whether you prefer to use a portal to jump around, or add blocks to bridge gaps.
  
 * callout(Remember): You can create an instance and place it with the same line of code:
 
    `world.place(Block(), atColumn: 2, row: 2)`
 
 First, you’ll need to [initialize](glossary://initialization) a character to solve the puzzle. See if you can think it through by using [pseudocode](glossary://pseudocode) that navigates through the puzzle world. Then use your code to change the structure of the puzzle world.
*/
//#-code-completion(everything, hide)
//#-code-completion(currentmodule, show)
//#-code-completion(literal, show, color)
//#-code-completion(identifier, show, isOnOpenSwitch, if, func, for, while, moveForward(), turnLeft(), turnRight(), collectGem(), toggleSwitch(), north, south, east, west, Expert, Character, Portal, color:), (color:), Block, Stair, (, ), (), turnLockUp(), turnLockDown(), isOnClosedSwitch, var, let, ., =, <, >, ==, !=, +, -, isBlocked, isOnGem, move(distance:), jump(), true, false, turnLock(up:numberOfTimes:), world, place(_:atStartColumn:startRow:atEndColumn:endRow:), place(_:facing:atColumn:row:), place(_:atColumn:row:), isBlockedLeft, &&, ||, !, isBlockedRight)
//#-hidden-code
playgroundPrologue()
typealias Character = Actor
//#-end-hidden-code
//#-editable-code Tap to enter code

//#-end-editable-code
//#-hidden-code
playgroundEpilogue()
//#-end-hidden-code

