//#-hidden-code
//
//  Contents.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//
//#-end-hidden-code
/*:#localized(key: "FirstProseBlock")
**Challenge:** Use your expert and the `turnLock` [method](glossary://method) to collect all the gems. 
 
In this puzzle, you can use both `turnLock` and `move` to help your character collect all the gems. There are many ways to solve this puzzle, so take some time to think through several different approaches before you get started. Good luck!
*/
//#-code-completion(everything, hide)
//#-code-completion(currentmodule, show)
//#-code-completion(identifier, show, isOnOpenSwitch, if, func, for, while, moveForward(), turnLeft(), turnRight(), collectGem(), toggleSwitch(), isOnGem, Expert, Character, (, ), (), turnLockUp(), turnLockDown(), isOnClosedSwitch, var, let, ., =, <, >, ==, !=, +=, +, -, isBlocked, move(distance:), true, false, isBlockedLeft, &&, ||, !, isBlockedRight, turnLock(up:numberOfTimes:), expert)
//#-hidden-code
playgroundPrologue()
typealias Character = Actor
//#-end-hidden-code
//#-editable-code Initialize your expert here
let expert = <#initialize#>
let character = <#initialize#>
//#-end-editable-code
//#-hidden-code
if let expert = expert as? Expert, let character = character as? Character {
    world.place(expert, facing: north, at: Coordinate(column: 1, row: 6))
    world.place(character, facing: north, at: Coordinate(column: 4, row: 3))
}
//#-end-hidden-code
//#-editable-code Enter the rest of your solution here

//#-end-editable-code
//#-hidden-code
playgroundEpilogue()
//#-end-hidden-code

