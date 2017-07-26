//#-hidden-code
//
//  Contents.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//
//#-end-hidden-code
/*:#localized(key: "FirstProseBlock")
 **Challenge:** Place your expert in the puzzle world, and solve the puzzle.
 
You can now place the expert in a specific *location*, but what if you want the expert to face a specific *direction*, as well? You can call a different version of the `place` method that takes a direction as an additional [argument](glossary://argument).
 
 * callout(Specifying a direction for your expert): 
 
    `world.place(expert, facing: .west, atColumn: 6, row: 3)`

But wait—what does `.west` mean? Think of it as a shorter form of [dot notation](glossary://dot%20notation) that gives you a group of options to choose from. In this case, you can choose `.west`, `.east`, `.north`, or `.south`, but nothing else!
 
Choices like this work because each choice is of the same [type](glossary://type)—an [enumeration](glossary://enumeration)—that defines that group of related values. You *could* write each choice like `Direction.north`, for example, but you can also leave out `Direction` to make it simpler.
 
 Start by initializing your expert. Then find `world` in the shortcut bar and add it to your code. Use dot notation to call the `place` [method](glossary://method) that includes the `facing` parameter, and pass in your arguments. Then solve the puzzle.
 */
//#-code-completion(everything, hide)
//#-code-completion(currentmodule, show)
//#-code-completion(identifier, show, isOnOpenSwitch, if, func, for, while, moveForward(), turnLeft(), turnRight(), collectGem(), toggleSwitch(), isOnGem, Expert, Character, (, ), (), turnLockUp(), turnLockDown(), isOnClosedSwitch, var, let, ., =, <, >, ==, !=, +=, +, -, isBlocked, move(distance:), world, place(_:facing:atColumn:row:), true, false, turnLock(up:numberOfTimes:), world, place(_:facing:atColumn:row:), place(_:atColumn:row:), north, south, east, west, isBlockedLeft, &&, ||, !, isBlockedRight)
//#-hidden-code
playgroundPrologue()
typealias Character = Actor
//#-end-hidden-code
//#-editable-code Tap to enter code

//#-end-editable-code



//#-hidden-code
playgroundEpilogue()
//#-end-hidden-code

