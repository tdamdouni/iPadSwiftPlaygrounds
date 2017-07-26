// 
//  SetUp.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
import Foundation

// MARK: Globals
let world: GridWorld = loadGridWorld(named: "1.5")
let actor = Actor()

public func playgroundPrologue() {
    
    world.place(actor, facing: north, at: Coordinate(column: 3, row: 1))
    
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
    world.placeGems(at: [Coordinate(column: 2, row: 3)])
    world.place(nodeOfType: Switch.self, facing: north, at: [Coordinate(column: 1, row: 3)])
}

func placeFloor() {
    let obstacles = [
                        Coordinate(column: 1, row: 1),
                        Coordinate(column: 0, row: 0),
                        
                        Coordinate(column: 1, row: 4),
                        Coordinate(column: 2, row: 1),
                        Coordinate(column: 2, row: 4),
                        Coordinate(column: 1, row: 0),
                        Coordinate(column: 2, row: 0),
                        Coordinate(column: 3, row: 0),
                        Coordinate(column: 4, row: 0),
                        Coordinate(column: 4, row: 1),
                        Coordinate(column: 4, row: 2),
                        Coordinate(column: 4, row: 3),
                        Coordinate(column: 4, row: 4),
                        
                        ]
    world.removeNodes(at: obstacles)
    world.placeWater(at: obstacles)
    
    let tiers = [
                    Coordinate(column: 1, row: 3),
                    Coordinate(column: 2, row: 3),
                    Coordinate(column: 3, row: 1),
                    Coordinate(column: 3, row: 2),
                    Coordinate(column: 3, row: 3),
                    Coordinate(column: 3, row: 4),
                    
                    
                    ]
    world.placeBlocks(at: tiers)
    world.place(Stair(), facing: west, at: Coordinate(column: 2, row: 2))
}
