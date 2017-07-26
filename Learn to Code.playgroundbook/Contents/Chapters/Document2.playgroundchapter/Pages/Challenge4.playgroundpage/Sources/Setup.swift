// 
//  Setup.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
import Foundation

//let world = GridWorld(columns: 5, rows: 9)
let world: GridWorld = loadGridWorld(named: "2.7")
let actor = Actor()

public func playgroundPrologue() {
    
    world.place(actor, facing: west, at: Coordinate(column: 2, row: 4))
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
    let switchLocations = [
                              Coordinate(column: 0, row: 4),
                              Coordinate(column: 2, row: 0),
                              Coordinate(column: 2, row: 2),
                              Coordinate(column: 2, row: 6),
                              Coordinate(column: 2, row: 8),
                              Coordinate(column: 4, row: 4),
                              ]
    world.place(nodeOfType: Switch.self, at: switchLocations)
}

func placeFloor() {
    let obstacles = world.coordinates(inColumns: [0,4], intersectingRows: [0,1,2,6,7,8])
    world.removeNodes(at: obstacles)
    world.placeWater(at: obstacles)
    
    world.placeBlocks(at: world.coordinates(inColumns: [1,2,3], intersectingRows: [0,1,2,6,7,8]))
    
    let tiers = [
                    Coordinate(column: 0, row: 3),
                    Coordinate(column: 0, row: 4),
                    Coordinate(column: 0, row: 5),
                    
                    Coordinate(column: 4, row: 3),
                    Coordinate(column: 4, row: 4),
                    Coordinate(column: 4, row: 5),
                    
                    Coordinate(column: 1, row: 0),
                    Coordinate(column: 2, row: 0),
                    Coordinate(column: 3, row: 0),
                    
                    Coordinate(column: 1, row: 8),
                    Coordinate(column: 2, row: 8),
                    Coordinate(column: 3, row: 8),
                    
                    
                    ]
    world.placeBlocks(at: tiers)
    
    
    world.place(Stair(), facing: north, at: Coordinate(column: 2, row: 1))
    world.place(Stair(), facing: north, at: Coordinate(column: 2, row: 3))
    
    
    world.place(Stair(), facing:  south, at: Coordinate(column: 2, row: 7))
    world.place(Stair(), facing:  south, at: Coordinate(column: 2, row: 5))
    
    world.place(Stair(), facing: east, at: Coordinate(column: 1, row: 4))
    world.place(Stair(), facing: west, at: Coordinate(column: 3, row: 4))
}
