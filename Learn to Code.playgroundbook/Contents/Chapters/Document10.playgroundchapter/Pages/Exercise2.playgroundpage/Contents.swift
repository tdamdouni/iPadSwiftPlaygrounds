/*:
**Goal:** Modify the state of each portal to gather the gems.
 
 In this puzzle, there are two portals, and you’ll need to use both of them to move Byte to other parts of the puzzle world. But you’ll also need Byte to *walk* across some areas, so you have to refer to each portal [instance](glossary://instance) separately to modify the `isActive` [property](glossary://property).
 
To do this, you must set the [state](glossary://state) of each portal instance. State is the stored information of a [variable](glossary://variable) at any given time. So while sometimes a portal instance stores an `isActive` value of *true*, other times it stores a value of `false`.
 
1. steps: Plan how to activate and deactivate each portal so Byte collects all the gems.
2. Use dot notation to modify the `isActive` [property](glossary://property) for `bluePortal` and `pinkPortal` as you solve the puzzle.
*/
//#-hidden-code
playgroundPrologue()
//#-end-hidden-code
//#-code-completion(everything, hide)
//#-code-completion(currentmodule, show)
//#-code-completion(identifier, show, isOnOpenSwitch, if, func, for, while, moveForward(), turnLeft(), turnRight(), collectGem(), toggleSwitch(), isOnGem, isOnClosedSwitch, var, ., =, isActive, true, false, isBlocked, true, false, isBlockedLeft, bluePortal, pinkPortal, &&, ||, !, isBlockedRight)
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
