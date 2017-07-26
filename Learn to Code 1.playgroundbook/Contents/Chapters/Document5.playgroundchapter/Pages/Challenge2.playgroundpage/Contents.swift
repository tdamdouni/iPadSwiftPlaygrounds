//#-hidden-code
//
//  Contents.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
//#-end-hidden-code
/*:
 **Challenge:** Use logical operators and conditional code to move through the puzzle world.
 
 Each of these operators influences the way your conditional code runs:
 
 * The [NOT operator (!)](glossary://logical%20NOT%20operator) inverts a [Boolean](glossary://Boolean) value, saying, "if NOT this condition, do this."
 * The [AND operator (&&)](glossary://logical%20AND%20operator) combines two conditions and runs the code only if *both* are true.
 * The [OR operator (||)](glossary://logical%20OR%20operator) combines two conditions and runs the code if *at least* one is true.
 
 Solve the challenge by choosing the operators and conditions that will work best to collect all the gems and toggle open the switches.
*/
//#-code-completion(everything, hide)
//#-code-completion(currentmodule, show)
//#-code-completion(identifier, show, isOnOpenSwitch, moveForward(), turnLeft(), turnRight(), collectGem(), toggleSwitch(), isOnGem, isOnClosedSwitch, isBlocked, isBlockedLeft, if, func, for, !, &&, ||)
//#-hidden-code
playgroundPrologue()
//#-end-hidden-code
//#-editable-code Tap to enter code
for i in 1 ... 8 {
    moveForward()
    
}
//#-end-editable-code


//#-hidden-code
playgroundEpilogue()
//#-end-hidden-code

