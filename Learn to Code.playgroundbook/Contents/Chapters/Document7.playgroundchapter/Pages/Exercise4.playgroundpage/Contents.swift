/*:
 **Goal:** Use a loop inside another loop to move Byte around a spiral.
 
In this puzzle, notice the spiral of gems, one at each turning point. To solve the puzzle, you'll need to [nest](glossary://nest) one [loop](glossary://loop) inside another. Don't worry—it's not as hard as it sounds!

Before you write your code, think it through. For the first side of the spiral, Byte has to move forward until there's a gem to collect. After collecting the gem, Byte turns left, ready to start down the next side of the spiral. This [pattern](glossary://pattern) repeats until Byte reaches the point farthest inside the spiral and is blocked.

When you write code that uses nested loops, you need to think backward. The first loop you write for this puzzle represents the last part of the logic above. That's the "repeat until Byte is blocked" part.
 
 1. steps: Write a loop to keep Byte moving until blocked.
 2. Inside that [outer loop](glossary://outer%20loop), you'll first need an [inner loop](glossary://inner%20loop) that moves Byte forward until there's a gem to collect.
 3. Then have Byte collect the gem and turn left.
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
