//#-hidden-code
//
//  Contents.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//
//#-end-hidden-code
/*:#localized(key: "FirstProseBlock")
 **Challenge:** Build an island surrounded by a sea.
 
 Tired of being landlocked? Use code to create your very own island!
 
 First, create two empty [arrays](glossary://array) that each store an array of coordinates. One will store coordinates for the *island*, and the other will store coordinates for the *sea*.
 
 Next, write a set of conditions within your [`if` statement](glossary://if%20statement) to append coordinates to your island array. These coordinates should be in the center of the map, and might be a 3x3 or 4x4 block. Append any coordinates that don’t meet these conditions to your sea array.
 
 * callout(Adding water): To add water, remove existing items first.
 
    `world.removeItems(at: coordinate)`\
    `world.place(Water(), at: coordinate)`
 
 After you've appended coordinates to each array, place blocks for each coordinate in the island array, and water for coordinates in the sea array. Good luck!
*/
//#-hidden-code
playgroundPrologue()
typealias Character = Actor
//#-end-hidden-code
//#-code-completion(everything, hide)
//#-code-completion(literal, show, color, array)
//#-code-completion(currentmodule, show)
//#-code-completion(identifier, show, isOnOpenSwitch, if, func, for, while, moveForward(), turnLeft(), turnRight(), collectGem(), toggleSwitch(), isBlocked, north, south, east, west, Water, Expert, Character, (, ), (), turnLockUp(), turnLockDown(), isOnClosedSwitch, var, let, ., =, <, >, ==, !=, +=, +, -, isBlocked, move(distance:), Character, Expert, (, ), (), Portal, color:, (color:), Block, Gem, Stair, Switch, Platform, (onLevel:controlledBy:), onLevel:controlledBy:, PlatformLock, jump(), true, false, turnLock(up:numberOfTimes:), world, place(_:facing:at:), removeBlock(atColumn:row:), isBlockedLeft, &&, ||, !, isBlockedRight, Coordinate, column:row:), (column:row:), column:row:, place(_:at:), remove(at:), insert(_:at:), removeItems(at:), append(_:), count, column(_:), row(_:), removeFirst(), removeLast(), randomInt(from:to:), removeAll(), allPossibleCoordinates, coordinates(inRows:), coordinates(inColumns:), column, row)
//#-editable-code Tap to enter code
let allCoordinates = world.allPossibleCoordinates
// Create two empty arrays of type [Coordinate].

for coordinate in allCoordinates {
    if <#condition#> {
        // Append to island array.
        
    } else {
        // Append to sea array.
        
    }
}
// For your island array, place blocks.
for <#item#> in <#array#> {
    
}

// For your sea array, place water.
for <#item#> in <#array#> {
    
}

//#-end-editable-code
//#-hidden-code
playgroundEpilogue()
//#-end-hidden-code

