/*:
 **Goal:** Choose the best loop to collect all the gems.
 
This puzzle has six gems and a simple [pattern](glossary://pattern) for Byte to move around. The best way to solve this puzzle is to use a [loop](glossary://loop), but which kind? You could use a [``while`` loop](glossary://while%20loop) to keep Byte moving while nothing blocks the way. Or, because you know how many gems there are, you could use a [``for`` loop](glossary://for%20loop) to repeat the pattern a specific number of times.

Sometimes deciding how to solve a coding problem is just a matter of which option feels better to you. When coders are faced with this type of choice, they base their decisions on which option results in a shorter solution or has more possibilities for reuse.
 
 1. steps: Identify the pattern for Byte to move from gem to gem.
 2. Decide on a loop and a condition to keep Byte moving.
*/
//#-code-completion(everything, hide)
//#-code-completion(currentmodule, show)
//#-code-completion(identifier, show, isOnOpenSwitch, moveForward(), turnLeft(), turnRight(), collectGem(), toggleSwitch(), isOnGem, isOnClosedSwitch, isBlocked, isBlockedLeft, &&, ||, !, isBlockedRight, if, while, func, for)
//#-hidden-code
playgroundPrologue()
//#-end-hidden-code
//#-editable-code
func turnAndCollectGem() {
    moveForward()
    turnLeft()
    moveForward()
    collectGem()
    turnRight()
}
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
