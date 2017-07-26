// 
//  SetUp.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//

import Foundation

// MARK: Globals
//let world = GridWorld(columns: 10, rows: 7)
let world = loadGridWorld(named: "8.1")
public let actor = Actor()

let wallLength: Int = 5

public func playgroundPrologue() {
    
    placeItems()
    addRandomElementPlaceholders()
    
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

func addRandomElementPlaceholders() {
    let block = Block()
    let height = wallLength
    let rects = [
                    world.coordinates(inColumns: [1], intersectingRows: 0..<height),
                    world.coordinates(inColumns: [3], intersectingRows: 0..<height),
                    world.coordinates(inColumns: 5...6, intersectingRows: 0..<height),
                    world.coordinates(inColumns: [8], intersectingRows: 0..<height)
    ]
    
    for rect in rects {
        for coord in rect {
            world.place(RandomNode(resembling: block), at: coord)
        }
    }
}

func placeItems() {
    let items = [
        Coordinate(column: 2, row: 0),
        Coordinate(column: 7, row: 0),
        Coordinate(column: 4, row: 0),
        
        ]
    world.placeGems(at: items)
    
    world.place(Switch(), at: Coordinate(column: 9, row: 0))
    
}

func addStaticElements() {
    let tiers = [
                    Coordinate(column: 1, row: 0),
                    Coordinate(column: 3, row: 0),
                    Coordinate(column: 5, row: 0),
                    Coordinate(column: 6, row: 0),
                    Coordinate(column: 8, row: 0),
                    ]
    world.placeBlocks(at: tiers)
    
    
    let row7 = world.coordinates(inRows:[6])
    world.removeNodes(at: row7)
    world.placeWater(at: row7)
}

func realizeRandomElements() {
    let randomMax = UInt32(wallLength + 1)
    let randomHeight1 = Int(arc4random_uniform(randomMax))
    let randomHeight2 = Int(arc4random_uniform(randomMax))
    let randomHeight3 = Int(arc4random_uniform(randomMax))
    let randomHeight4 = Int(arc4random_uniform(randomMax))
    
    let rect1 = world.coordinates(inColumns: [1], intersectingRows: 0..<randomHeight1)
    world.placeBlocks(at: rect1)
    
    let rect2 = world.coordinates(inColumns: [3], intersectingRows: 0..<randomHeight2)
    world.placeBlocks(at: rect2)
    
    let rect3 = world.coordinates(inColumns: 5...6, intersectingRows: 0..<randomHeight3)
    world.placeBlocks(at: rect3)
    
    let rect4 = world.coordinates(inColumns: [8], intersectingRows: 0..<randomHeight4)
    world.placeBlocks(at: rect4)
}
