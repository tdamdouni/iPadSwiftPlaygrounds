/*:
 **Goal:** [Call](glossary://call) functions from other functions.
 
Up to now, the [functions](glossary://function) you've [defined](glossary://define) have only called existing [commands](glossary://command), such as `moveForward()` and `collectGem()`. It doesn't have to be this way, though!

The function *`turnAround()`* directs Byte to turn around and face the opposite direction. You can call this function inside another function, *`solveStair()`*, and call `solveStair()` in your code to solve bigger parts of the puzzle. 
 
 This process of breaking a larger problem into smaller pieces is called [decomposition](glossary://decomposition).
 
 1. steps: Define the `solveStair()` function, calling `turnAround()` inside of it.
 2. Call `solveStair()` along with the other functions you need.
 3. Solve the puzzle by collecting all four gems.
*/
//#-hidden-code
playgroundPrologue()
//#-end-hidden-code
//#-code-completion(everything, hide)
//#-code-completion(currentmodule, show)
//#-code-completion(identifier, show, moveForward(), turnLeft(), collectGem(), toggleSwitch(), turnRight(), func)
func turnAround() {
    //#-editable-code Tap to enter code
    turnLeft()
    turnLeft()
    //#-end-editable-code
}

func solveStair() {
    //#-editable-code Tap to enter code
    
    //#-end-editable-code
}
//#-editable-code Tap to enter code
solveStair()
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
