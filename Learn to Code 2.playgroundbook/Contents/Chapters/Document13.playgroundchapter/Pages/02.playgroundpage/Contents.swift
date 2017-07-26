//#-hidden-code
//
//  Contents.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
//#-end-hidden-code
/*:
**Goal:** Place five stacked blocks at each corner.

Check out the code below. Instead of an array of [Int](glossary://Int) values, you now have an array of type `Coordinate`.
    
* callout(The Coordinate type):
    
    An instance of `Coordinate` references a location, taking arguments for `column` and `row`.\
    `let corner = Coordinate(column: 3, row: 3)`

Using the `blockLocations` array, you can iterate over each coordinate and perform an action at each location; for example:
    
    for coordinate in blockLocations {
       world.place(Gem(), at: coordinate)
    }
 
 1. steps: Add two coordinates to `blockLocations`, one for each corner of the world.
 2. Use a `for`-`in` loop to [iterate](glossary://iteration) over each coordinate, placing **5 blocks** at each corner. (You might need to [nest](glossary://nest) another [`for` loop](glossary://for%20loop).)
*/
//#-hidden-code
playgroundPrologue()
typealias Character = Actor
//#-end-hidden-code
//#-code-completion(everything, hide)
//#-code-completion(literal, show, color, array)
//#-code-completion(currentmodule, show)
//#-code-completion(identifier, show, isOnOpenSwitch, if, func, for, while, moveForward(), turnLeft(), turnRight(), collectGem(), toggleSwitch(), isBlocked, north, south, east, west, Water, Expert, Character, (, ), (), turnLockUp(), turnLockDown(), isOnClosedSwitch, var, let, ., =, <, >, ==, !=, +, -, isBlocked, move(distance:), Character, Expert, (, ), (), Portal, color:), (color:), Block, Gem, Stair, Switch, Platform, (onLevel:controlledBy:), onLevel:controlledBy:), PlatformLock, jump(), true, false, turnLock(up:numberOfTimes:), world, removeBlock(atColumn:row:), isBlockedLeft, &&, ||, !, isBlockedRight, Coordinate, column:row:), (column:row:), column:row:, place(_:at:), place(_:facing:at:), remove(at:), insert(_:at:), removeItems(at:), append(_:), count, column(_:), row(_:), removeFirst(), removeLast(), randomInt(from:to:), removeAll(), allPossibleCoordinates, coordinates(inRows:), coordinates(inColumns:), column, row)
//#-editable-code Tap to enter code
// Add the two remaining corner coordinates.
var blockLocations = [
    Coordinate(column: 0, row: 0),
    Coordinate(column: 3, row: 3),
    <#Insert a new coordinate#>
]
// Place 5 blocks at each coordinate.
for coordinate in <#T##array name##[Coordinate]#> {

}
//#-end-editable-code
//#-hidden-code
playgroundEpilogue()
//#-end-hidden-code

