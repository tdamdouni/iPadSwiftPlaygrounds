//#-hidden-code
//
//  Contents.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
//#-end-hidden-code
/*:
 **Goal:** Use the OR operator to adjust your path if either of two conditions is true.
 
The last logical operator is the [logical OR operator (||)](glossary://logical%20OR%20operator), which combines two [Boolean](glossary://Boolean) conditions and runs your code if *at least* one is true. For example, in the following code, either `isOnGem` OR `isBlockedLeft` must be true.
 
     if isOnGem || isBlockedLeft {
         moveForward()
     }
 
 If neither condition is true, the code doesn't run. If one or both are true, the code runs.
 
 1. steps: Use the || operator to check whether one of two conditions is true. Hint: You may be blocked either in the front or on the left.
 2. If either is true, turn right and move forward.
 3. If neither is true, move forward.
*/
//#-code-completion(everything, hide)
//#-code-completion(currentmodule, show)
//#-code-completion(identifier, show, isOnOpenSwitch, moveForward(), turnLeft(), turnRight(), collectGem(), toggleSwitch(), isOnGem, isOnClosedSwitch, isBlocked, isBlockedLeft, if, func, for, !, &&, ||)
//#-hidden-code
playgroundPrologue()
//#-end-hidden-code
//#-editable-code
for i in 1 ... 12 {
    
}
//#-end-editable-code


//#-hidden-code
playgroundEpilogue()
//#-end-hidden-code

