/*:
**Challenge:** Collect exactly three gems and toggle open four switches.
 
To collect the right number of gems and toggle open the right number of switches in this challenge, you'll need two separate variables. As Byte handles the gems and switches, you'll increment the right [variable](glossary://variable) so you stop at the right time.
 
 * callout(More [comparison operators](glossary://comparison%20operator)):

     **Less than operator:** (`a < b`) returns true if `a` is less than `b`.\
     **Greater than operator:** (`a > b`) returns true if `a` is greater than `b`.\
     **Equal to operator:** (`a == b`) returns true if `a` equals `b`.\
     **Not equal to operator:** (`a != b`) returns true if `a` is not equal to `b`.
 
You can use any of the comparison operators above to create a [Boolean](glossary://Boolean) condition for an `if` statement or `while` loop. Example: `while gemCounter != 3`
 
Start by [declaring](glossary://declaration) one variable for the number of gems, and another for the number of switches. Increment each variable by 1 when Byte collects a gem or toggles a switch. Use one of the comparison operators above to create a condition in an `if` statement or `while` loop to tell Byte when to stop.
*/
//#-hidden-code
playgroundPrologue()
//#-end-hidden-code
//#-code-completion(everything, hide)
//#-code-completion(currentmodule, show)
//#-code-completion(identifier, show, isOnOpenSwitch, if, func, for, while, moveForward(), turnLeft(), turnRight(), collectGem(), toggleSwitch(), isOnGem, isOnClosedSwitch, var, =, <, >, ==, !=, +, -, isBlocked, true, false, isBlockedLeft, &&, ||, !, isBlockedRight)
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
