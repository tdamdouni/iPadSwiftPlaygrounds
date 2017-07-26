// 
//  SetUp.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
import Foundation

// MARK: Globals
//let world = GridWorld(columns: 10, rows: 8)
let world = loadGridWorld(named: "8.2")
public let actor = Actor()

public func playgroundPrologue() {
    
    placeItems()
    placeRandomPlaceholderElements()
    
    world.place(actor, facing: north, at: Coordinate(column: 0, row: 0))

    // Must be called in `playgroundPrologue()` to update with the current page contents.
    registerAssessment(world, assessment: assessmentPoint)
    
    //// ----
    // Any items added or removed after this call will be animated.
    finalizeWorldBuilding(for: world) {
        realizeRandomElements()
    }
    //// ----
}

// Called from LiveView.swift to initially set the LiveView.
public func presentWorld() {
    setUpLiveViewWith(world)
    
}

// MARK: Epilogue

public func playgroundEpilogue() {
    sendCommands(for: world)
}

func placeRandomPlaceholderElements() {
    let block = Block()
    for i in 1..<4 {
        world.place(RandomNode(resembling: block), at: Coordinate(column: 2, row: i))
    }
    
    let random2 = 3
    let rect3 = world.coordinates(inColumns: Set((5-random2)...5), intersectingRows: ([5]))
    for coord in rect3 {
        world.place(RandomNode(resembling: block), at: coord)
    }
    
    for i in 1..<5 {
        world.place(RandomNode(resembling: block), at: Coordinate(column: 7, row: i))
    }
}

func realizeRandomElements() {
    let random1 = Int(arc4random_uniform(3)) + 1
    world.place(Block(), at: Coordinate(column: 2, row: random1))
    
    let random2 = Int(arc4random_uniform(3)) + 1
    let rect3 = world.coordinates(inColumns: Set((5-random2)...5), intersectingRows: ([5]))
    world.placeBlocks(at: rect3)
    
    let random3 = Int(arc4random_uniform(2)) + 1
    world.place(Block(), at: Coordinate(column: 7, row: random3))
    world.place(Block(), at: Coordinate(column: 7, row: random3 + 2))
    world.place(Block(), at: Coordinate(column: 7, row: random3 + 3))
}

func placeItems() {
    let items = [
                    Coordinate(column: 2, row: 0),
                    Coordinate(column: 5, row: 0),
                    
                    ]
    world.placeGems(at: items)
    
    world.place(Switch(), at: Coordinate(column: 9, row: 0))
}

func placeBlocks() {
    let rect1 = world.coordinates(inColumns: [1], intersectingRows: 0..<4)
    world.placeBlocks(at: rect1)
    
    let rect2 = world.coordinates(inColumns: [5], intersectingRows: 1..<6)
    world.placeBlocks(at: rect2)
    
    let rect4 = world.coordinates(inColumns: [8], intersectingRows: 0..<4)
    world.placeBlocks(at: rect4)
    
    let tiers = [
                    Coordinate(column: 4, row: 0),
                    Coordinate(column: 4, row: 1),
                    Coordinate(column: 1, row: 0),
                    Coordinate(column: 4, row: 0),
                    Coordinate(column: 8, row: 0)
    ]
    world.placeBlocks(at: tiers)
    
    let row7 = world.coordinates(inRows:[7])
    world.removeNodes(at: row7)
    world.placeWater(at: row7)
    
    let obstacles = [
                        Coordinate(column: 9, row: 6),
                        Coordinate(column: 9, row: 5),
                        Coordinate(column: 0, row: 6)
    ]
    world.removeNodes(at: obstacles)
    world.placeWater(at: obstacles)
}
