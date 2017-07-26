// 
//  SetUp.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
import Foundation

// MARK: Globals

let width = Int(arc4random_uniform(4)) + 5
let height = Int(arc4random_uniform(4)) + 4
// we can't use this dressed world because the size of this world is random
// let world = loadGridWorld(named: "7.7")

let world = GridWorld(columns: 9, rows: 8)
public let actor = Actor()

public func playgroundPrologue() {
    removeAllNodes()
    placeRandomItems()

		
    // Must be called in `playgroundPrologue()` to update with the current page contents.
    registerAssessment(world, assessment: assessmentPoint)
    
    //// ----
    // Any items added or removed after this call will be animated.
    finalizeWorldBuilding(for: world) {
        realizeRandomItems()

    }
    //// ----
    world.place(actor, facing: north, at: Coordinate(column: 0, row: 0))

}

// Called from LiveView.swift to initially set the LiveView.
public func presentWorld() {
    setUpLiveViewWith(world)
    
}

// MARK: Epilogue

public func removeAllNodes() {
    world.removeItems(at: world.allPossibleCoordinates)
}
public func playgroundEpilogue() {
    sendCommands(for: world)
}

func placeRandomItems() {
    let block = Block()
    let coordinates = world.coordinates(inColumns: 0...8, intersectingRows: 0...7)
    for coordinate in coordinates {
        world.place(RandomNode(resembling: block), at: coordinate)
    }
}

func realizeRandomItems() {

    for i in 1...(width-2) {
        for j in 1...(height-2) {
            world.placeWater(at: [Coordinate(column: i, row: j)])
        }
    }
    
    for i in 0...(height-2) {
        world.placeBlocks(at: [Coordinate(column: 0, row: i)])
    }
    
    for i in 0...(width-2) {
        world.placeBlocks(at: [Coordinate(column: i, row: height - 1)])
        world.placeBlocks(at: [Coordinate(column: i, row: height - 1)])

    }
    
    for i in 1...(height-1) {
        world.placeBlocks(at: [Coordinate(column: width - 1, row: i)])
        world.placeBlocks(at: [Coordinate(column: width - 1, row: i)])
        world.placeBlocks(at: [Coordinate(column: width - 1, row: i)])

    }
    
    for i in 1...(width-1) {
        world.placeBlocks(at: [Coordinate(column: i, row: 0)])
        world.placeBlocks(at: [Coordinate(column: i, row: 0)])
        world.placeBlocks(at: [Coordinate(column: i, row: 0)])
        world.placeBlocks(at: [Coordinate(column: i, row: 0)])

    }
    
    
    world.place(Stair(), facing: south, at: Coordinate(column: 0, row: height - 2))
    world.place(Stair(), facing: west, at: Coordinate(column: width - 2, row: height - 1))
    world.place(Stair(), facing: north, at: Coordinate(column: width-1, row: 1))
    
    world.place(nodeOfType: Switch.self, at: [Coordinate(column: 1, row: 0)])


}
