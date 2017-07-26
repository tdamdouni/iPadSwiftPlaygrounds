//#-hidden-code
//
//  Contents.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
//#-end-hidden-code
/*:
 **Goal:** Remove coordinates from one array while appending to another.
 
Sometimes you’ll want to use an item that you remove from an array. Fortunately, a removed item is stored for a short time, so you can assign it to a variable or append it to another array.
 
    var rightColumn = world.column(7)
    newArray.append(rightColumn.remove(at: 1))
 
In the code above, the coordinate appended to `newArray` is the one that is also removed from `rightColumn`.
 
You may have noticed that `rightColumn` is initialized with a method. The `world` [instance](glossary://instance) includes a set of [methods](glossary://method) that let you quickly create an [array](glossary://array) containing all coordinates in a column or row.
 
* callout(Calling a method to create an array):
 
    `var row1 = world.row(1)`\
    `var column5 = world.column(5)`
 
    `var topRows = world.coordinates(inRows: [5,6,7])`\
    `var allCoords = world.allPossibleCoordinates`
 
 1. steps: Create one empty array of coordinates, and use a method to create another array of all coordinates in row `2`.
 2. Each time the [outer loop](glossary://outer%20loop) runs, remove an item from the array and append it to your empty array.
 3. Iterate over your empty array, placing an instance of type `Character` at each coordinate.
 */
//#-hidden-code
playgroundPrologue()
typealias Character = Actor
//#-end-hidden-code
//#-code-completion(everything, hide)
//#-code-completion(literal, show, color, array)
//#-code-completion(currentmodule, show)
//#-code-completion(identifier, show, isOnOpenSwitch, if, func, for, while, moveForward(), turnLeft(), turnRight(), collectGem(), toggleSwitch(), isBlocked, north, south, east, west, Water, Expert, Character, (, ), (), turnLockUp(), turnLockDown(), isOnClosedSwitch, var, let, ., =, <, >, ==, !=, +, -, isBlocked, move(distance:), Character, Expert, (, ), (), Portal, color:), (color:), Block, Gem, Stair, Switch, Platform, (onLevel:controlledBy:), onLevel:controlledBy:), PlatformLock, jump(), true, false, turnLock(up:numberOfTimes:), world, place(_:facing:at:), removeBlock(atColumn:row:), isBlockedLeft, &&, ||, !, isBlockedRight, Coordinate, column:row:), (column:row:), column:row:, place(_:at:), remove(at:), insert(_:at:), removeItems(at:), append(_:), count, column(_:), row(_:), removeFirst(), removeLast(), randomInt(from:to:), removeAll(), allPossibleCoordinates, coordinates(inRows:), coordinates(inColumns:), column, row)
//#-editable-code Tap to enter code
// Create an array of all coordinates in row 2.

// Create an empty array of coordinates.


for i in 1...12 {
    for <#coordinate#> in <#row 2#> {
        world.place(Block(), at: <#coordinate#>)
    }
    // Remove a coordinate and append it to your empty array.
    
}

// Place a character for each coordinate added to your empty array.
for <#item#> in <#array#> {
    
}

//#-end-editable-code
//#-hidden-code
playgroundEpilogue()
//#-end-hidden-code

