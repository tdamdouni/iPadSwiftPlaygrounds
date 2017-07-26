/*:
**Goal:** Place your character at a specific location in the puzzle world.
 
So far, the starting point for your character has been chosen for you. In this puzzle, you’ll choose a starting point by passing [arguments](glossary://argument) into a [method](glossary://method) called `place`.

* callout(Using the place method): `place` has 4 [parameters](glossary://parameter):
    
    `world.place(item: Item, facing: Direction, atColumn: Int, row: Int)`

  - **item:** Takes an input of type `Item`, which includes your `Character` and `Expert` types. Pass in an [instance](glossary://instance) of your expert, `expert`.
  - **facing:** Takes an input of type `Direction`. Pass in *north*, *south*, *east*, or *west*.
  - **atColumn:** Takes an [Int](glossary://Int) for the column you want your character to be placed at.
  - **row:** Takes an Int for the row you want your character to be placed at.

 
    world.place(expert, facing: east, atColumn: 1, row: 1)
 
 
 1. steps: Specify grid coordinates to identify a starting location for your expert. The bottom left of the map is (0,0).
 2. Use the example above as a guide to pass in arguments to the `place` method.
*/
//#-code-completion(everything, hide)
//#-code-completion(currentmodule, show)
//#-code-completion(identifier, show, isOnOpenSwitch, if, func, for, while, moveForward(), turnLeft(), turnRight(), collectGem(), toggleSwitch(), isOnGem, Expert(), Character(), turnLockUp(), turnLockDown(), isOnClosedSwitch, var, let, ., =, <, >, ==, !=, +, -, isBlocked, move(distance:), world, place(_:facing:atColumn:row:), true, false, turnLock(up:numberOfTimes:), world, place(_:facing:atColumn:row:), place(_:atColumn:row:), isBlockedLeft, &&, ||, !, isBlockedRight, world, place(_:facing:atColumn:row:), place(_:atColumn:row:))
//#-hidden-code
playgroundPrologue()
//#-end-hidden-code
//#-editable-code Tap to enter code
let expert = Expert()
world.place(<#WorldNode#>, facing: <#Direction#>, atColumn: <#T##Int##Int#>, row: <#T##Int##Int#>)


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
