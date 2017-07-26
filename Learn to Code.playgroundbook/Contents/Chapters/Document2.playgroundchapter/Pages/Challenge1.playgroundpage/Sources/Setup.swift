// 
//  Setup.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
import Foundation

//let world = GridWorld(columns: 4, rows: 7)
let world: GridWorld = loadGridWorld(named: "2.3")
let actor = Actor()

public func playgroundPrologue() {
    
    world.place(actor, facing: west, at: Coordinate(column: 3, row: 5))
    placeItems()
    

    // Must be called in `playgroundPrologue()` to update with the current page contents.
    registerAssessment(world, assessment: assessmentPoint)
    
    //// ----
    // Any items added or removed after this call will be animated.
    finalizeWorldBuilding(for: world)
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

func placeItems() {
    let items = [
                    Coordinate(column: 0, row: 4),
                    Coordinate(column: 1, row: 1),
                    Coordinate(column: 3, row: 2),
                    Coordinate(column: 2, row: 5),
                    
                    ]
    world.placeGems(at: items)
    
    let switchLocations = [
                              Coordinate(column: 0, row: 3),
                              Coordinate(column: 1, row: 5),
                              
                              Coordinate(column: 2, row: 1),
                              Coordinate(column: 3, row: 3),
                              ]
world.place(nodeOfType: Switch.self, facing: west, at: switchLocations)
}

func placeFloor() {
    let obstacles = world.coordinates(inColumns: 0...3, intersectingRows:  [0,6])
    world.removeNodes(at: obstacles)
    world.placeWater(at: obstacles)
    
    world.placeBlocks(at: world.coordinates(inColumns: [0,3], intersectingRows: 1...5))
    
    let tiers = [
                    Coordinate(column: 0, row: 3),
                    Coordinate(column: 3, row: 3),
                    Coordinate(column: 1, row: 5),
                    Coordinate(column: 2, row: 5),
                    
                    Coordinate(column: 1, row: 1),
                    Coordinate(column: 2, row: 1),
                    
                    
                    ]
    world.placeBlocks(at: tiers)
    
    world.place(Stair(), facing:  south, at: Coordinate(column: 0, row: 2))
    world.place(Stair(), facing: north, at: Coordinate(column: 0, row: 4))
    world.place(Stair(), facing:  south, at: Coordinate(column: 3, row: 2))
    world.place(Stair(), facing: north, at: Coordinate(column: 3, row: 4))
}
