/*:
 **Challenge:** Build your world and collect a randomly determined number of gems, represented by the `totalGems` constant.
 
In this puzzle, a random number of gems is generated each time you run your code. Your goal is to modify the puzzle world so you can effectively navigate around it, picking up gems until you’ve collected all of them. The number of gems is determined by a value stored in the [constant](glossary://constant) `totalGems`.
 
Keep track of the number of gems collected to figure out when to stop running your code.
*/
//#-code-completion(everything, hide)
//#-code-completion(currentmodule, show)
//#-code-completion(identifier, show, isOnOpenSwitch, if, func, for, while, moveForward(), turnLeft(), turnRight(), collectGem(), toggleSwitch(), isOnGem, Expert(), Character(), turnLockUp(), turnLockDown(), isOnClosedSwitch, var, let, ., =, <, >, ==, !=, +, -, isBlocked, move(distance:), jump(), true, false, turnLock(up:numberOfTimes:), world, place(_:facing:atColumn:row:), place(_:atColumn:row:), isBlockedLeft, &&, ||, !, isBlockedRight)
//#-hidden-code
playgroundPrologue()
//#-end-hidden-code
let totalGems = randomNumberOfGems
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
