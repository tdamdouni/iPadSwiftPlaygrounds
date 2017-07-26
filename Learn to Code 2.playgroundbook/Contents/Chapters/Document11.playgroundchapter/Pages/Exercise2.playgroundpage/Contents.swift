//#-hidden-code
//
//  Contents.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
//#-end-hidden-code
/*:
 **Goal:** Write a function to turn a lock up or down a given number of times.
 
 Previously, you used [parameters](glossary://parameter) to define a `move` function with an input, `distance`. In this puzzle, you’ll define a `turnLock` function that uses the parameters `up` and `numberOfTimes` to determine the direction and number of times your expert should turn the lock.
 
 * callout(turnLock parameters explained):
 
    `up` takes an input of [type](glossary://type) Bool (Boolean), indicating whether to turn the lock **up** (`true`) or **down** (`false`).\
    `numberOfTimes` takes an input of type [Int](glossary://Int), indicating the number of times to turn the lock.
 
1. steps: Use both parameters, `up` and `numberOfTimes`, to define your function.
2. Check the value of `up` to determine if you should call `turnLockUp()` or `turnLockDown()`.
3. Use the `numberOfTimes` value to determine how many times to run either `turnLockUp()` or `turnLockDown()`.
*/
//#-code-completion(everything, hide)
//#-code-completion(currentmodule, show)
//#-code-completion(identifier, show, isOnOpenSwitch, if, func, for, while, moveForward(), turnLeft(), turnRight(), collectGem(), toggleSwitch(), isOnGem, Expert, Character, (, ), (), turnLockUp(), turnLockDown(), isOnClosedSwitch, var, let, ., =, <, >, ==, !=, +, -, isBlocked, move(distance:), true, false, isBlockedLeft, &&, ||, !, isBlockedRight, expert)
//#-hidden-code
playgroundPrologue()
typealias Character = Actor
//#-end-hidden-code
//#-editable-code Initialize your expert here
let expert = <#initialize#>
let character = <#initialize#>
//#-end-editable-code
//#-hidden-code
world.place(character, facing: south, at: Coordinate(column: 5, row: 3))
world.place(expert, facing: north, at: Coordinate(column: 1, row: 1))
//#-end-hidden-code

func turnLock(up: Bool, numberOfTimes: Int) {
    //#-editable-code Add commands to your function
    
    //#-end-editable-code
}
//#-editable-code Tap to enter code

//#-end-editable-code
//#-hidden-code
playgroundEpilogue()
//#-end-hidden-code

