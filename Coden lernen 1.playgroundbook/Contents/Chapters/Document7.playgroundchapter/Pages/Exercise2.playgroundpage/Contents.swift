//#-hidden-code
//
//  Contents.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//
//#-end-hidden-code
/*:#localized(key: "FirstProseBlock")
 **Goal:** Adjust your algorithm to navigate around extra blocks.
 
This puzzle is similar to the previous one, but additional blocks around the walls prevent your [right-hand rule](glossary://right-hand%20rule) algorithm from working properly. In some situations, you're blocked on the right, but you can't move forward because you're also blocked in the front.
 
![Tweaking your algorithm](Byte_turn@2x.png)
 
To fix this, you'll need to tweak your algorithm. The image above shows the three different situations your character will encounter, and the arrows suggest how to respond for each one. Can you modify `navigateAroundWall()` to handle each situation?
 
 1. steps: Use [pseudocode](glossary://pseudocode) to think through how your character should move in the three situations above.
 2. Based on your pseudocode, tweak your code and run it to see what happens.
 3. If something isn't working as expected, identify the bug, fix it, and run your code again.
*/
//#-code-completion(everything, hide)
//#-code-completion(currentmodule, show)
//#-code-completion(identifier, show, isOnOpenSwitch, moveForward(), turnLeft(), turnRight(), collectGem(), toggleSwitch(), isOnGem, isOnClosedSwitch, isBlocked, isBlockedLByte_turn@2x.pngeft, &&, ||, !, isBlockedRight, if, while, func, for)
//#-hidden-code
playgroundPrologue()
//#-end-hidden-code
//#-copy-source(id1)
//#-editable-code
//#-copy-destination("Exercise1", id1)
func navigateAroundWall() {
    if isBlockedRight {
        moveForward()
    }  else {
        turnRight()
        moveForward()
    }
}
    
while !isOnClosedSwitch {
    navigateAroundWall()
    if isOnGem {
        collectGem()
        turnLeft()
        turnLeft()
    }
}
toggleSwitch()
//#-end-copy-destination
//#-end-editable-code
//#-end-copy-source
//#-hidden-code
playgroundEpilogue()
//#-end-hidden-code

