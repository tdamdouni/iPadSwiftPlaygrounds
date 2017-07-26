/*:
 **Goal:** Use a while loop and an if statement to open all the switches.
 
Now try making your `while` loops even smarter. To solve this puzzle, you’ll need a `while` loop to toggle open every switch along the three platforms. However, you can't use the condition `isOnClosedSwitch`, or the loop will stop running when Byte reaches a portal or an open switch.

1. steps: Add a `while` loop by tapping `while` in the shortcut bar. 
2. Add a condition to make Byte continue moving forward until reaching the end of the third platform.
3. In your while loop, use an `if` statement to toggle only closed switches, not open ones.
*/
//#-code-completion(everything, hide)
//#-code-completion(currentmodule, show)
//#-code-completion(identifier, show, isOnOpenSwitch, moveForward(), turnLeft(), turnRight(), collectGem(), toggleSwitch(), isOnGem, isOnClosedSwitch, isBlocked, isBlockedLeft, &&, ||, !, isBlockedRight, if, while, func, for)
//#-hidden-code
playgroundPrologue()
//#-end-hidden-code
//#-editable-code

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
