//#-hidden-code
//
//  Contents.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//
//#-end-hidden-code
/*:#localized(key: "FirstProseBlock")
 **Goal:** Create an array of existing items.
 
Not only can you make an array to place items, you can also make an array out of items that already exist in the puzzle world.
 
    let characters = world.existingCharacters(at: allCoordinates)
 
With the array of characters above, you can [iterate](glossary://iteration) over each character, giving them commands such as `jump()`, or even telling them to show you their fancy dance moves!
 
* callout(Bust a move!): Try calling these methods for each character in your characters array:

    `danceLikeNoOneIsWatching()`\
    `turnUp()`\
    `breakItDown()`\
    `grumbleGrumble()`\
    `argh()`
 
In the code below, create an array from existing characters in the puzzle world. Then iterate over your array of characters, giving each of them a set of actions to perform.
*/
//#-hidden-code
playgroundPrologue()
typealias Character = Actor
//#-end-hidden-code
//#-code-completion(everything, hide)
//#-code-completion(literal, show, color, array)
//#-code-completion(currentmodule, show)
//#-code-completion(identifier, show, isOnOpenSwitch, if, func, for, while, moveForward(), turnLeft(), turnRight(), collectGem(), toggleSwitch(), isBlocked, north, south, east, west, Water, Expert, Character, (, ), (), turnLockUp(), turnLockDown(), isOnClosedSwitch, var, let, ., =, <, >, ==, !=, +=, +, -, isBlocked, move(distance:), Character, Expert, (, ), (), Portal, color:, (color:), Block, Gem, Stair, Switch, Platform, (onLevel:controlledBy:), onLevel:controlledBy:, PlatformLock, jump(), true, false, turnLock(up:numberOfTimes:), world, place(_:facing:at:), place(_:between:and:), removeBlock(atColumn:row:), isBlockedLeft, &&, ||, !, isBlockedRight, Coordinate, column:row:), (column:row:), column:row:, place(_:at:), remove(at:), insert(_:at:), removeItems(at:), append(_:), count, column(_:), row(_:), removeFirst(), removeLast(), randomInt(from:to:), existingCharacters(at:), existingExperts(at:), danceLikeNoOneIsWatching(), turnUp(), breakItDown(), grumbleGrumble(), argh(), randomBool(), removeAll(), allPossibleCoordinates, coordinates(inRows:), coordinates(inColumns:), column, row)
//#-editable-code Tap to enter code
let allCoordinates = world.allPossibleCoordinates

for coordinate in allCoordinates {
    // Change height to be the sum of the column and row for each coordinate.
    let height = coordinate.column
    
    for i in 0...height {
        world.place(Block(), at: coordinate)
    }
    
    if height >= 8 && height < 10 {
        world.place(Character(name: .blu), at: coordinate)
    } else if height > 9 {
        world.place(Character(name: .hopper), at: coordinate)
    }
}

// Initialize an array of existing characters in the puzzle world.

// For each of the characters, perform a set of actions.
for <#item#> in <#array#> {
    
}

//#-end-editable-code
//#-hidden-code
playgroundEpilogue()
//#-end-hidden-code

