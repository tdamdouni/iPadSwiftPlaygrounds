//#-hidden-code
//
//  Contents.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//
//#-end-hidden-code
/*:#localized(key: "FirstProseBlock")
 **Challenge:** Use randomization to generate a unique world.

What if you want to use random values in your `heights` array to create a unique landscape each time you run your code?
 
The `randomInt` [function](glossary://function) generates a random [integer](glossary://Int) using the values that you pass in. In the code below, `localNumber` is [defined](glossary://define) inside the [`for` loop](glossary://for%20loop). Each time the loop runs, a new number is generated and appended to `heights`.
 
    for i in 1...20 {
       let localNumber = randomInt(from: 0, to: 12)
       heights.append(localNumber)
    }
 
A variable defined inside a code structure like a function or a loop is called a [local variable](glossary://local%20variable). Like `localNumber` above, a local variable exists *only* inside the code structure it's defined in. It can't be used anywhere else in the code.
 
For this challenge, use the `randomInt` function, along with your knowledge of arrays and conditional code, to generate a unique landscape each time your code runs. Be creative, and have fun!
*/
//#-hidden-code
playgroundPrologue()
typealias Character = Actor

let bigOldBlock: (GridWorld) -> Swift.Void = { world in
//#-end-hidden-code
//#-code-completion(everything, hide)
    //#-code-completion(literal, show, color, array)
//#-code-completion(currentmodule, show)
//#-code-completion(identifier, show, isOnOpenSwitch, if, func, for, while, moveForward(), turnLeft(), turnRight(), collectGem(), toggleSwitch(), isBlocked, north, south, east, west, Water, Expert, Character, (, ), (), turnLockUp(), turnLockDown(), isOnClosedSwitch, var, let, ., =, <, >, ==, !=, +=, +, -, isBlocked, move(distance:), Character, Expert, (, ), (), Portal, color:, (color:), Block, Gem, Stair, Switch, Platform, (onLevel:controlledBy:), onLevel:controlledBy:, PlatformLock, jump(), true, false, turnLock(up:numberOfTimes:), world, place(_:facing:at:), removeBlock(atColumn:row:), isBlockedLeft, &&, ||, !, isBlockedRight, Coordinate, column:row:), (column:row:), column:row:, place(_:at:), place(_:between:and:), remove(at:), insert(_:at:), removeItems(at:), append(_:), count, column(_:), row(_:), removeFirst(), removeLast(), randomInt(from:to:), removeAll(), allPossibleCoordinates, randomBool(), coordinates(inRows:), coordinates(inColumns:), column, row)
//#-editable-code Tap to enter code
let allCoordinates = world.allPossibleCoordinates
var heights: [Int] = []

// Append random numbers to heights.


var index = 0
for coordinate in allCoordinates {
    if index == heights.count {
        index = 0
    }
    
    // currentHeight stores the height at the current index.
    var currentHeight = heights[index]
    

    if currentHeight == 0 {
        // Do something interesting if currentHeight is equal to 0.


    } else {
        for i in 1...currentHeight {
            world.place(Block(), at: coordinate)
        }
        if currentHeight > 10 {
            // Do something different, such as placing a character.
            
        } else if coordinate.column >= 3 && coordinate.column < 6 {
            // Do something different, such as placing water.
            
        }
        // Add more rules to customize your world.

        
    }
    index += 1
    
}
//#-end-editable-code
//#-hidden-code
}

playgroundEpilogue(block: bigOldBlock)
//#-end-hidden-code

