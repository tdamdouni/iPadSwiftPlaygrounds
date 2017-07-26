//#-hidden-code
//
//  Contents.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
//#-end-hidden-code
/*:
 **Goal:** Append to an empty array based on coordinate properties. Place 6 blocks on each coordinate in the array.
 
 Adding each item to an array individually is *really* repetitive. What if you could create a set of rules for the coordinates to include in your array?
 
 First, start with `allCoordinates`, an [array](glossary://array) of all the coordinates in the puzzle world.
 
 Next, you’ll need an empty array to append your coordinates to. And because you’re [declaring](glossary://declaration) an array with no stored values, you’ll need to specify the [type](glossary://type) of items it should hold.
 
 * callout(Creating an empty array): Use **`:`** after your variable name to declare its type, then [assign](glossary://assignment) it an empty array.
 
    `var newLocations: [Coordinate] = []`
 
 Finally, [iterate](glossary://iteration) over `allCoordinates` and check the `column` and `row` [properties](glossary://property) of each coordinate. If the property for a coordinate's column is greater than `5` **or** for its row is less than `4`, append it to your empty array.
*/
//#-hidden-code
playgroundPrologue()
typealias Character = Actor
//#-end-hidden-code
//#-code-completion(everything, hide)
//#-code-completion(literal, show, color, array)
//#-code-completion(currentmodule, show)
//#-code-completion(identifier, show, isOnOpenSwitch, if, func, for, while, moveForward(), turnLeft(), turnRight(), collectGem(), toggleSwitch(), isBlocked, north, south, east, west, Water, Expert, Character, (, ), (), turnLockUp(), turnLockDown(), isOnClosedSwitch, var, let, ., =, <, >, ==, !=, +, -, isBlocked, move(distance:), Character, Expert, (, ), (), Portal, color:), (color:), Block, Gem, Stair, Switch, Platform, (onLevel:controlledBy:), onLevel:controlledBy:), PlatformLock, jump(), true, false, turnLock(up:numberOfTimes:), world, removeBlock(atColumn:row:), isBlockedLeft, &&, ||, !, isBlockedRight, Coordinate, column:row:), (column:row:), column:row:, place(_:at:), place(_:facing:at:), remove(at:), insert(_:at:), removeItems(at:), append(_:), count, column(_:), row(_:), removeFirst(), removeLast(), randomInt(from:to:), removeAll(), allPossibleCoordinates, coordinates(inRows:), coordinates(inColumns:), column, row)
let allCoordinates = world.allPossibleCoordinates
var blockSet: [Coordinate] = []

//#-editable-code Tap to enter code
for coordinate in allCoordinates {
    // Check for coordinates with a column > 5 OR a row < 4.
    if coordinate.column > 2 && coordinate.row < 5 {
        // Append coordinate to blockSet.
        
    }
}

// For each coordinate in blockSet, place 6 blocks.
for <#item#> in <#array#> {
    
}

//#-end-editable-code
//#-hidden-code
playgroundEpilogue()
//#-end-hidden-code

