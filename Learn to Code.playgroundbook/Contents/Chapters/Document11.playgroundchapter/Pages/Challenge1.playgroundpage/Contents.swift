/*:
**Challenge:** Create an instance of type `Expert` and use the expert to solve the puzzle.
 
Use this challenge to practice initializing an instance of your expert. As you write a solution to the puzzle, remember what you’ve learned about factoring your code into clear and [reusable](glossary://reusability) functions.
 
 * callout(New Ability):

      In addition to `turnLockUp()`, you can also use `turnLockDown()` to move a platform down from its current position.
 
 Start by [initializing](glossary://initialization) an instance of your expert. Direct your expert to move around, collect the gems, and toggle open the switches. Then have your expert turn the lock to reveal the path to the disconnected platforms.
*/
//#-code-completion(everything, hide)
//#-code-completion(currentmodule, show)
//#-code-completion(identifier, show, isOnOpenSwitch, if, func, for, while, moveForward(), turnLeft(), turnRight(), collectGem(), toggleSwitch(), isOnGem, Expert(), Character(), turnLockUp(), turnLockDown(), isOnClosedSwitch, var, ., let, =, <, >, ==, !=, +, -, isBlocked, true, false, isBlockedLeft, &&, ||, !, isBlockedRight)
//#-hidden-code
playgroundPrologue()
//#-end-hidden-code
//#-editable-code Initialize your expert here
let expert = <#intialize#>
//#-end-editable-code
//#-hidden-code
world.place(expert, facing: west, at: Coordinate(column: 3, row: 2))
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
