//#-hidden-code
//
//  Contents.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//
//#-end-hidden-code
/*:#localized(key: "FirstProseBlock")
 **Goal:** Use an array of integers to create a landscape.
 
The code at the bottom of the page contains two arrays: `heights` stores [Int](glossary://Int) values, and `allCoordinates` stores all coordinates in the puzzle world.

Use the `heights` array to determine how many blocks to stack on each coordinate in `allCoordinates`. To do this, you’ll need to access specific `Int` values at each [index](glossary://index) in `heights`.

* callout(Accessing a value at an index):
    
    `var heights = [7,3,2,4]`\
    `for i in 1...heights[0]`

Because the value of `heights` at index `0` is `7`, the [`for` loop](glossary://for%20loop) will run `7` times. Now, what if you want to access a different index for each coordinate? You need to store the index value as a [variable](glossary://variable) and increment it.

    var index = 0
    for coordinate in allCoordinates {
       for i in 1...heights[index] {
          world.place(Block(), at: coordinate)
       }
       index += 1
    }

Be careful. If the value of `index` is greater than the number of items in the `heights` array, you’ll try to access a value that doesn’t exist. This will give you an [array out of bounds error](glossary://array%20out%20of%20bounds%20error). You can prevent this by making sure your `index` value is never greater than `heights.count`, the number of items in your array.
 
    if index == heights.count {
       index = 0
    }
 
 1. steps: Fill in the missing code below to place a stack of blocks of different heights at each coordinate. 
 2. Notice where the `count` property is used to prevent an array out-of-bounds error.
 */
//#-hidden-code
playgroundPrologue()
typealias Character = Actor
//#-end-hidden-code
//#-code-completion(everything, hide)
//#-code-completion(literal, show, color, array)
//#-code-completion(currentmodule, show)
//#-code-completion(identifier, show, isOnOpenSwitch, if, func, for, while, moveForward(), turnLeft(), turnRight(), collectGem(), toggleSwitch(), isBlocked, north, south, east, west, Water, Expert, Character, (, ), (), turnLockUp(), turnLockDown(), isOnClosedSwitch, var, let, ., =, <, >, ==, !=, +=, +, -, isBlocked, move(distance:), Character, Expert, (, ), (), Portal, color:, (color:), Block, Gem, Stair, Switch, Platform, (onLevel:controlledBy:), onLevel:controlledBy:, PlatformLock, jump(), true, false, turnLock(up:numberOfTimes:), world, isBlockedLeft, &&, ||, !, isBlockedRight, Coordinate, column:row:), (column:row:), column:row:, place(_:at:), place(_:between:and:), place(_:facing:at:), remove(at:), insert(_:at:), removeItems(at:), append(_:), count, column(_:), row(_:), removeFirst(), removeLast(), randomInt(from:to:), removeAll(), allPossibleCoordinates, coordinates(inRows:), coordinates(inColumns:), column, row)
//#-editable-code Tap to enter code
var heights: [Int] = [<#T##add Int values##Int#>]
let allCoordinates = <#all world coordinates#>

var index = 0
for coordinate in allCoordinates {
    if index == heights.count {
        index = 0
    }
    for i in 0...<#heights[index]#> {
        // Place a block.
        
    }
    // Increment the index.
    
}

//#-end-editable-code
//#-hidden-code
playgroundEpilogue()
//#-end-hidden-code

