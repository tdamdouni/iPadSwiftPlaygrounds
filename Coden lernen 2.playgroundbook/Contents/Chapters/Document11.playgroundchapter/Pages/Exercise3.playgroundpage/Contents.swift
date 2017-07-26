//#-hidden-code
//
//  Contents.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//
//#-end-hidden-code
/*:#localized(key: "FirstProseBlock")
**Goal:** Place your character at a specific location in the puzzle world.
 
So far, the starting point for your character has been chosen for you. In this puzzle, you’ll choose a starting point by passing [arguments](glossary://argument) into a [method](glossary://method) called `place`.

* callout(Using the place method): `place` has three [parameters](glossary://parameter):
    
    `world.place(item: Item, atColumn: Int, row: Int)`

  - **item:** Takes an input of type `Item`, which includes your `Character` and `Expert` types. Pass in an [instance](glossary://instance) of your expert, `expert`.
  - **atColumn:** Takes an [Int](glossary://Int) for the column you want your character to be placed at.
  - **row:** Takes an Int for the row you want your character to be placed at.

    
    world.place(expert, atColumn: 1, row: 1)
 
 1. steps: Tap on a tile in the puzzle world to reveal its coordinates.
 2. Examine the map to find a starting location for your expert. Use the column and row value of that location in your `place` method.
*/
//#-code-completion(everything, hide)
//#-code-completion(currentmodule, show)
//#-code-completion(identifier, show, isOnOpenSwitch, if, func, for, while, moveForward(), turnLeft(), turnRight(), collectGem(), toggleSwitch(), isOnGem, Expert, Character, (, ), (), turnLockUp(), turnLockDown(), isOnClosedSwitch, var, let, ., =, <, >, ==, !=, +=, +, -, isBlocked, move(distance:), world, place(_:facing:atColumn:row:), true, false, turnLock(up:numberOfTimes:), world, place(_:atColumn:row:), isBlockedLeft, &&, ||, !, isBlockedRight, world, place(_:facing:atColumn:row:), place(_:atColumn:row:))
//#-hidden-code
playgroundPrologue()
typealias Character = Actor
//#-end-hidden-code
//#-editable-code Tap to enter code
let expert = Expert()
world.place(<#Item#>, atColumn: <#T##Int##Int#>, row: <#T##Int##Int#>)


//#-end-editable-code


//#-hidden-code
playgroundEpilogue()
//#-end-hidden-code

