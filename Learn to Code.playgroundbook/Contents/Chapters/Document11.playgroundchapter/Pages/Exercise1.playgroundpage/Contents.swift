/*:
 **Goal:** Initialize an instance of type `Expert` and solve the puzzle with the `turnLockUp()` method.
 
 In this puzzle, there's a new element to deal with: a lock. To solve the puzzle, you’ll need to turn the lock, which raises a platform in front of an unreachable gem.
 
The character you've worked with up to now has certain abilities, like moving forward, collecting gems, and toggling switches. One ability your character doesn’t have is picking locks. You’ll need a new character—an expert—to do that. Because your expert won't change, you’ll [declare](glossary://declaration) it by using a [constant](glossary://constant), and then [initialize](glossary://initialization) it by assigning it the `Expert` [type](glossary://type).
 
* callout(Initializing an expert):

     `let expert = Expert()`
 
 1. steps: Initialize your new expert character. Don’t change the constant name, `expert`.
 2. Move your expert around and give commands using dot notation.
 3. Use the `turnLockUp()` [method](glossary://method) on the lock to reveal the path between the platforms.
*/
//#-hidden-code
playgroundPrologue()
//#-end-hidden-code
//#-code-completion(everything, hide)
//#-code-completion(currentmodule, show)
//#-code-completion(identifier, show, isOnOpenSwitch, if, func, for, while, moveForward(), turnLeft(), turnRight(), collectGem(), toggleSwitch(), isOnGem, Expert(), Character(), isOnClosedSwitch, let, ., =, <, >, ==, !=, +, -, isBlocked, true, false, isBlockedLeft, &&, ||, !, isBlockedRight, turnLockUp())
//#-editable-code Initialize your expert here
let expert = <#intialize#>
//#-end-editable-code
//#-hidden-code
world.place(expert, facing: east, at: Coordinate(column: 3, row: 3))
//#-end-hidden-code
//#-editable-code Enter the rest of your solution here

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
