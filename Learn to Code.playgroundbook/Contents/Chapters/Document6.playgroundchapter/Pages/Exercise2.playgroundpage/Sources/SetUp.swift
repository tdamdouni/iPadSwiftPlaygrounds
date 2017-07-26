// 
//  SetUp.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
import Foundation

// MARK: Globals
let world = loadGridWorld(named: "6.3")
public let actor = Actor()

public func playgroundPrologue() {
    
    placeItems()
    placeActor()

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

func placeBlocks() {
    let obstacles = [
                        Coordinate(column: 3, row: 5),
                        Coordinate(column: 3, row: 3),
                        Coordinate(column: 3, row: 2),
                        
                        Coordinate(column: 2, row: 5),
                        Coordinate(column: 2, row: 3),
                        Coordinate(column: 3, row: 0),
                        Coordinate(column: 3, row: 1)
    ]
    world.removeNodes(at: obstacles)
    world.placeWater(at: obstacles)
    
    let tiers = [
                    Coordinate(column: 0, row: 2),
                    Coordinate(column: 0, row: 4),
                    Coordinate(column: 0, row: 6),
                    Coordinate(column: 0, row: 7),
                    
                    Coordinate(column: 3, row: 7),
                    Coordinate(column: 3, row: 6),
                    Coordinate(column: 3, row: 4),
                    
                    ]
    world.placeBlocks(at: tiers)
    world.place(Stair(), facing: west, at: Coordinate(column: 2, row: 7))
    world.place(Stair(), facing: west, at: Coordinate(column: 2, row: 6))
    world.place(Stair(), facing: west, at: Coordinate(column: 2, row: 4))
}

func placeItems() {
    let items = [
                    Coordinate(column: 1, row: 1),
                    Coordinate(column: 1, row: 3),
                    Coordinate(column: 1, row: 4),
                    Coordinate(column: 1, row: 5),
                    Coordinate(column: 1, row: 6),
                    Coordinate(column: 1, row: 7),
                    
                    Coordinate(column: 3, row: 7),
                    Coordinate(column: 3, row: 6),
                    Coordinate(column: 3, row: 4),
                    
                    
                    
                    ]
    world.placeGems(at: items)
}

func placeActor() {
    world.place(actor, facing: north, at: Coordinate(column: 1, row: 0))
}


