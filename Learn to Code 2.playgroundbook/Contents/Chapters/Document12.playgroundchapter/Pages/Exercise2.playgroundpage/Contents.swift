//#-hidden-code
//
//  Contents.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
//#-end-hidden-code
/*:
 **Goal:** Add a portal to jump to a different area.
 
You've used portals to teleport between areas of the puzzle world. In this puzzle, you'll create a portal between two floating islands.
 
First, you’ll need to create an instance of [type](glossary://type) `Portal` and pass in a color. Next, you'll place the portal by specifying coordinates for both the starting side of the portal and the ending side. An example is included below.
 
* callout(Placing a portal):

     `world.place(newPortal, atStartColumn: 1, startRow: 1, atEndColumn: 2, endRow: 2)`
 
 1 steps: Place your portal by calling the `place` [method](glossary://method) that includes the parameters `atStartColumn`, `startRow`, `atEndColumn`, and `endRow`.
 2. Collect all the gems, using the portals to jump from one island to the other.
*/
//#-hidden-code
playgroundPrologue()
typealias Character = Actor
//#-end-hidden-code
//#-code-completion(everything, hide)
//#-code-completion(currentmodule, show)
//#-code-completion(literal, show, color)
//#-code-completion(identifier, show, isOnOpenSwitch, if, func, for, while, moveForward(), turnLeft(), turnRight(), collectGem(), toggleSwitch(), north, south, east, west, Expert, Character, Portal, color:), (color:), Block, (, ), (), turnLockUp(), turnLockDown(), isOnClosedSwitch, var, let, ., =, <, >, ==, !=, +, -, isBlocked, isOnGem, move(distance:), jump(), true, false, turnLock(up:numberOfTimes:), world, place(_:facing:atColumn:row:), place(_:atColumn:row:), place(_:atStartColumn:startRow:atEndColumn:endRow:), isBlockedLeft, &&, ||, !, isBlockedRight)
//#-editable-code Tap to enter code
let greenPortal = Portal(color: #colorLiteral(red: 0.4028071761, green: 0.7315050364, blue: 0.2071235478, alpha: 1))
//#-end-editable-code
//#-hidden-code
playgroundEpilogue()
//#-end-hidden-code

