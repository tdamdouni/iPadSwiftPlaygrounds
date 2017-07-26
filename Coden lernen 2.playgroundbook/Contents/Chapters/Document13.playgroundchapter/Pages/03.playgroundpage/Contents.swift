//#-hidden-code
//
//  Contents.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//
//#-end-hidden-code
/*:#localized(key: "FirstProseBlock")
 **Goal:** Place Blu, Hopper, and the expert in order by height.
 
The `Array` [type](glossary://type) comes with a set of [methods](glossary://method) that let you add or remove items from your [array](glossary://array).
 
 * callout(Array methods):
   
    **`remove(at: Int)`**. Removes an item at an [index](glossary://index).\
    **`append(newElement: Element)`**. Adds an item to the end of the array.\
    **`insert(newElement: Element, at: Int)`**. Inserts an item at a specific index.

Use [dot notation](glossary://dot%20notation) to call a method on an array:
  
 ![var favoriteFoods = [🌮, 🍓, 🍣, 🍳, 🧀] Calling `remove(at: 2)` on `favoriteFoods` removes 🍣 from the array. Calling `insert(🍝, at: 1)` adds 🍝 at index `1`.](ArrayTable@2x.png)
 
 Calling `remove(at: 2)` on `favoriteFoods` removes 🍣 from the array. Calling `insert(🍝, at: 1)` adds 🍝 at index `1`.

1. steps: In the `characters` array below, remove the portal and gem.
2. Insert an instance of type `Expert` so that the characters are arranged from *shortest* in the front (row `0`) to *tallest* in the back.
*/
//#-hidden-code
playgroundPrologue()
typealias Character = Actor
//#-end-hidden-code
//#-code-completion(everything, hide)
//#-code-completion(literal, show, color, array)
//#-code-completion(currentmodule, show)
//#-code-completion(identifier, show, isOnOpenSwitch, if, func, for, while, moveForward(), turnLeft(), turnRight(), collectGem(), toggleSwitch(), isBlocked, north, south, east, west, Water, Expert, Character, (, ), (), turnLockUp(), turnLockDown(), isOnClosedSwitch, var, let, ., =, <, >, ==, !=, +=, +, -, isBlocked, move(distance:), Character, Expert, (, ), (), Portal, color:, (color:), Block, Gem, Stair, Switch, Platform, (onLevel:controlledBy:), onLevel:controlledBy:, PlatformLock, jump(), true, false, turnLock(up:numberOfTimes:), world, place(_:facing:at:), removeBlock(atColumn:row:), isBlockedLeft, &&, ||, !, isBlockedRight, Coordinate, column:row:), (column:row:), column:row:, place(_:at:), remove(at:), insert(_:at:), removeItems(at:), append(_:), count, column(_:), row(_:), removeFirst(), removeLast(), randomInt(from:to:), removeAll(), allPossibleCoordinates, coordinates(inRows:), coordinates(inColumns:), column, row)
//#-hidden-code
var characters: [Item]
//#-end-hidden-code
characters = [
    Character(name: .blu),
    Portal(color: #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)),
    Character(name: .hopper),
    Gem()
]
//#-editable-code Tap to enter code

// Remove the portal.

// Remove the gem.

// Insert the expert.

var rowPlacement = 0
for character in characters {
    world.place(character, at: Coordinate(column: 1, row: rowPlacement))
    rowPlacement += 1
}

//#-end-editable-code
//#-hidden-code
playgroundEpilogue()
//#-end-hidden-code

