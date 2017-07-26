//#-hidden-code
//
//  Contents.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//
//#-end-hidden-code
/*:#localized(key: "FirstProseBlock")
**Challenge:** Iterate over an array, placing a gem and a switch at each location.

In the code below, you can use the `columns` [array](glossary://array) to place a gem and a switch on each column in the puzzle world. This process is known as [iteration](glossary://iteration), and it allows you to perform an action for each item in an array.
    
  - example:\
    To iterate, use a `for`-`in` loop, a type of [`for` loop](glossary://for%20loop)\
  \
    `for currentColumn in columns {`\
    `   world.place(Gem(), atColumn: currentColumn, row: 1))`\
    `}`
 
A `for`-`in` loop runs a block of code for each [variable](glossary://variable) in the array. In the above example, `currentColumn` is the variable that stores a value in the `columns` array. This value is passed into the `column` [parameter](glossary://parameter) of the `place` method to determine which column to place a gem at.
 
 Each time the `for`-`in` loop runs, `currentColumn` goes to the next item in the array until there are no items left.
 
1. steps: Complete the `for` loop that iterates over your array.
2. Within the loop, place a gem and a switch at each column.
*/
//#-hidden-code
playgroundPrologue()
typealias Character = Actor
//#-end-hidden-code
//#-code-completion(everything, hide)
//#-code-completion(literal, show, color, array)
//#-code-completion(currentmodule, show)
//#-code-completion(identifier, show, isOnOpenSwitch, if, func, for, while, moveForward(), turnLeft(), turnRight(), collectGem(), toggleSwitch(), isBlocked, north, south, east, west, Water, Expert, Character, (, ), (), turnLockUp(), turnLockDown(), isOnClosedSwitch, var, let, ., =, <, >, ==, !=, +=, +, -, isBlocked, move(distance:), Character, Expert, (, ), (), Portal, color:, (color:), Block, Gem, Stair, Switch, Platform, (onLevel:controlledBy:), onLevel:controlledBy:, PlatformLock, jump(), true, false, turnLock(up:numberOfTimes:), world, removeBlock(atColumn:row:), isBlockedLeft, &&, ||, !, isBlockedRight, Coordinate, column:row:), (column:row:), column:row:, place(_:atColumn:row:), append(_:), count, column(_:), row(_:), removeFirst(), removeLast(), randomInt(from:to:), removeAll(), allPossibleCoordinates, coordinates(inRows:), coordinates(inColumns:), column, row)
//#-editable-code Tap to enter code
let columns = [0, 1, 2, 3, 4]

// Give your loop variable a name and pass in your array.
for <#column#> in <#T##array name##[Coordinate]#> {
    // Place a gem and a switch for each column.
    world.place(Gem(), atColumn: <#column#>, row: 1)
}
//#-end-editable-code
//#-hidden-code
playgroundEpilogue()
//#-end-hidden-code

