//#-hidden-code
//
//  Contents.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//
//#-end-hidden-code
/*:#localized(key: "FirstProseBlock")
 **Goal:** Use a while loop and an `if` statement to open all the switches.
 
Now try making your `while` loops even smarter using conditional code. To solve this puzzle, you’ll need a [`while` loop](glossary://while%20loop) to toggle open every switch along the three platforms. However, you can't simply use the condition `isOnClosedSwitch`, or the loop will stop running when you reach a portal or an open switch.

1. steps: Add a `while` loop by tapping `while` in the shortcut bar. 
2. Add a condition to make your character continue moving forward until reaching the end of the third platform.
3. In your while loop, use an [`if` statement](glossary://if%20statement) to toggle only closed switches, not open ones.
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

