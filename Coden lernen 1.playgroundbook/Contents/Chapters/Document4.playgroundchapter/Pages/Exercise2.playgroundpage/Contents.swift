//#-hidden-code
//
//  Contents.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//
//#-end-hidden-code
/*:#localized(key: "FirstProseBlock")
 **Goal:** Use [``if``](glossary://if%20statement) and [`else if`](glossary://else%20if%20block) to toggle a switch or collect a gem.
 
Again, try running the puzzle a few times, and you'll find that switches and gems both appear in random places.

To figure out whether to toggle a switch or collect a gem, use an [`if` statement](glossary://if%20statement) to check one possible condition and an [`else if` block](glossary://else%20if%20block) to check the other.
 
    if isOnClosedSwitch {
       toggleSwitch()
    } else if isOnGem {
       collectGem()
    }

The new ``isOnGem`` condition will help determine whether your character is on a gem.
 
 1. steps: Move to the first randomized tile, then add an `if` statement.
 2. In your code, tap the word `if` and then tap "Add `else if` Statement" to add an `else if` block.
 3. Enter code to toggle the switch open if on a closed switch, and to collect a gem if on a gem.
 4. Repeat for the second tile.
*/
//#-hidden-code
playgroundPrologue()
//#-end-hidden-code
//#-code-completion(everything, hide)
//#-code-completion(currentmodule, show)
//#-code-completion(identifier, show, isOnOpenSwitch, moveForward(), turnLeft(), collectGem(), toggleSwitch(), turnRight(), isOnGem, isOnClosedSwitch, if, func, for)
//#-editable-code Tap to enter code

//#-end-editable-code
//#-hidden-code
playgroundEpilogue()
//#-end-hidden-code

