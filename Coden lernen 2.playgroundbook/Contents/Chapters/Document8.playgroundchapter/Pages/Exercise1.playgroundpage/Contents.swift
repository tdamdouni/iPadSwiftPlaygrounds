//#-hidden-code
//
//  Contents.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//
//#-end-hidden-code
/*:#localized(key: "FirstProseBlock")
**Goal:** Create a [variable](glossary://variable) to track the number of gems collected.
 
For this puzzle, you’ll need to keep track of how many gems you collect. This value should be `0` in the beginning; after your character picks up the first gem, the value should change to `1`.

 To [declare](glossary://declaration) (create) a variable, use `var` and give your variable a name. Then use the [assignment operator](glossary://assignment%20operator) (`=`) to set an initial value for the variable. 

    var myAge = 15
 
After you declare a new variable, you may [assign](glossary://assignment) it a new value at any time:
 
    myAge = 16
 
 1. steps: Set the initial value of `gemCounter` to `0`.
 2. Move to the gem and pick it up.
 3. Set the value of `gemCounter` to `1`.
*/
//#-hidden-code
playgroundPrologue()
//#-end-hidden-code
//#-code-completion(everything, hide)
//#-code-completion(currentmodule, show)
//#-code-completion(identifier, show, isOnOpenSwitch, moveForward(), turnLeft(), turnRight(), collectGem(), toggleSwitch(), isOnGem, isOnClosedSwitch, var, =, isBlocked, true, false, isBlockedLeft, &&, ||, !, isBlockedRight, if, func, for, while)
var gemCounter = /*#-editable-code yourFuncName*/<#T##value##Int#>/*#-end-editable-code*/
//#-hidden-code
initialGemCount = gemCounter
//#-end-hidden-code
//#-editable-code Tap to enter code

//#-end-editable-code
//#-hidden-code
finalGemCount = gemCounter
playgroundEpilogue()
//#-end-hidden-code

