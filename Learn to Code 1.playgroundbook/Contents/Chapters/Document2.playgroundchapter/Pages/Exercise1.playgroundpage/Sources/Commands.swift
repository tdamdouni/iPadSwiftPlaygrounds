// 
//  Commands.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
/**
Turns the character left.
*/
public func turnLeft() {
    actor.turnLeft()
}

/**
Moves the character forward one tile. 
*/
public func moveForward() {
    actor.moveForward()
}

/**
 Instructs the character to toggle a switch on the current tile.
 */
public func toggleSwitch() {
    actor.toggleSwitch()
}

/**
 Instructs the character to collect a gem on the current tile.
*/
public func collectGem() {
    actor.collectGem()
}

/**
Condition that checks if the character is on a tile with an open switch on it.
*/
public var isOnOpenSwitch: Bool {
    return actor.isOnOpenSwitch
}

/**
Condition that checks if the character is on a tile with a closed switch on it.
 */
public var isOnClosedSwitch: Bool {
    return actor.isOnClosedSwitch
}

/**
Condition that checks if the character is on a tile with a gem on it.
*/
public var isOnGem: Bool {
    return actor.isOnGem
}

/**
Condition that checks if the character is blocked from moving forward in the current direction.  
*/
public var isBlocked: Bool {
    return actor.isBlocked
}

/**
 Condition that checks if the character is blocked on the right.
 */
public var isBlockedRight: Bool {
    return actor.isBlockedRight
}

/**
 Condition that checks if the character is blocked on the left.
 */
public var isBlockedLeft: Bool {
    return actor.isBlockedLeft
}

/**
 Instructs the character to jump up or down onto the block the character is facing. If the current tile and the tile the character is facing are the same height, the character simply jumps forward one tile.
 */
public func jump() {
    actor.jump()
}
