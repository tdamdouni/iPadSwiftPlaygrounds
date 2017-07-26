//#-hidden-code
//
//  Contents.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//
//#-end-hidden-code
/*:#localized(key: "FirstProseBlock")
 **Challenge:** Build your world and collect a randomly determined number of gems, represented by the `totalGems` constant.
 
In this puzzle, a random number of gems is generated each time you run your code. Your goal is to modify the puzzle world so you can effectively navigate around it, picking up gems until you’ve collected all of them. The number of gems is determined by a value stored in the [constant](glossary://constant) `totalGems`.
 
Keep track of the number of gems collected to figure out when to stop running your code.
*/
//#-code-completion(everything, hide)
//#-code-completion(currentmodule, show)
//#-code-completion(literal, show, color)
//#-code-completion(identifier, show, isOnOpenSwitch, if, func, for, while, moveForward(), turnLeft(), turnRight(), collectGem(), toggleSwitch(), north, south, east, west, Expert, Character, (, ), (), Portal, color:, (color:), Block, Stair, turnLockUp(), greenPortal, bluePortal, yellowPortal, isActive, turnLockDown(), isOnClosedSwitch, var, let, ., =, <, >, ==, !=, +=, +, -, isBlocked, move(distance:), jump(), true, false, turnLock(up:numberOfTimes:), place(_:atStartColumn:startRow:atEndColumn:endRow:), world, place(_:facing:atColumn:row:), place(_:atColumn:row:), isBlockedLeft, isOnGem, &&, ||, 0, !, isBlockedRight)
//#-hidden-code
playgroundPrologue()
typealias Character = Actor
//#-end-hidden-code
let totalGems = randomNumberOfGems
//#-editable-code Tap to enter code

//#-end-editable-code
//#-hidden-code
playgroundEpilogue()
//#-end-hidden-code

