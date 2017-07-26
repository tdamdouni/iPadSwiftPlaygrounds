//#-hidden-code
//
//  Contents.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
//#-end-hidden-code
/*:
 **Challenge:** Test the state of the world to change your route.
 
For this last challenge, you need to collect the gems and toggle the switches along the center platform, but several paths take you away from it.

You can use [conditional code](glossary://conditional%20code) to detect whether your character is on a gem or a closed switch, and take a different action **if** your character is on one instead of the other. 
 
    for i in 1...5 {
       moveForward()
       if isOnGem {
          solveRightSide()
       } else if isOnClosedSwitch {
          solveLeftSide()
       }
    }
*/
//#-code-completion(everything, hide)
//#-code-completion(currentmodule, show)
//#-code-completion(identifier, show, isOnOpenSwitch, isBlocked, moveForward(), turnLeft(), collectGem(), toggleSwitch(), turnRight(), if, func, for, isOnGem, isOnClosedSwitch)
//#-hidden-code
playgroundPrologue()
//#-end-hidden-code
//#-editable-code Tap to enter code

//#-end-editable-code


//#-hidden-code
playgroundEpilogue()
//#-end-hidden-code

