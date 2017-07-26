//#-hidden-code
//
//  Contents.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
//#-end-hidden-code
/*:
 **Challenge:** Use an `if` statement to trigger a sequence of commands if your character is on a gem.
 
Congratulations! You've learned how to write [conditional code](glossary://conditional%20code) using [`if` statements](glossary://if%20statement) and [`else if` blocks](glossary://else%20if%20block).
 
A condition like `isOnGem` is always either **true** or **false**. This is known as a [Boolean](glossary://Boolean) value. Coders often use Boolean values with [conditional code](glossary://conditional%20code) to tell a program when to run certain blocks of code.
 
 1. steps: In the `if` statement below, use the Boolean condition `isOnGem` and add commands to run if the condition is true.
 2. Modify or keep the existing [`else` block](glossary://else%20block) to run code if your Boolean condition is false.
 3. If necessary, tweak the number of times your `for` loop runs. 

*/
//#-code-completion(everything, hide)
//#-code-completion(currentmodule, show)
//#-code-completion(identifier, show, isOnOpenSwitch, isOnGem, isOnClosedSwitch, moveForward(), turnLeft(), collectGem(), toggleSwitch(), turnRight(), if, func, for)
//#-hidden-code
playgroundPrologue()
//#-end-hidden-code
//#-editable-code Tap to enter code
for i in 1 ... 16 {
    if <#condition#> {
        
    } else {
        moveForward()
    }
}
//#-end-editable-code

//#-hidden-code
playgroundEpilogue()
//#-end-hidden-code

