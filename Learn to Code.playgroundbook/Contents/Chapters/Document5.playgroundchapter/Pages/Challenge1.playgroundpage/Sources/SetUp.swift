// 
//  SetUp.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
import Foundation

// MARK: Globals
let world: GridWorld = loadGridWorld(named: "5.4")
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

func placeActor() {
    world.place(actor, facing: east, at: Coordinate(column: 1, row: 1))
}

func placeItems() {
    let items = [
                    Coordinate(column: 2, row: 2),
                    Coordinate(column: 2, row: 5),
                    Coordinate(column: 4, row: 5),
                    Coordinate(column: 4, row: 1),
                    
                    ]
    world.placeGems(at: items)
}

func placeBlocks() {
    world.removeNodes(at: world.coordinates(inColumns: [0], intersectingRows: 0...5))
    world.placeWater(at: world.allPossibleCoordinates)

    world.placeBlocks(at: world.coordinates(inColumns: 1...4, intersectingRows: [5]))
    world.placeBlocks(at: world.coordinates(inColumns: [4], intersectingRows: 3...4))

    let obstacles = [
                        Coordinate(column: 1, row: 4),
                        Coordinate(column: 1, row: 3),
                        Coordinate(column: 1, row: 2),
                        
                        Coordinate(column: 1, row: 0),
                        Coordinate(column: 2, row: 0),
                        Coordinate(column: 3, row: 0),
                        Coordinate(column: 4, row: 0),
                        Coordinate(column: 5, row: 0),
                        
                        Coordinate(column: 3, row: 2),
                        Coordinate(column: 3, row: 3),
                        Coordinate(column: 3, row: 4),
                        
                        
                        
                        
                        ]
    world.removeNodes(at: obstacles)
    world.placeWater(at: obstacles)
    
    let tiers = [
                    Coordinate(column: 2, row: 2),
                    Coordinate(column: 2, row: 2),
                    Coordinate(column: 2, row: 2),
                    
                    Coordinate(column: 2, row: 3),
                    Coordinate(column: 2, row: 3),
                    Coordinate(column: 2, row: 3),
                    
                    Coordinate(column: 2, row: 4),
                    Coordinate(column: 2, row: 4),
                    
                    Coordinate(column: 1, row: 5),
                    Coordinate(column: 2, row: 5)
    ]
    world.placeBlocks(at: tiers)
    
    world.place(Stair(), facing: south, at: Coordinate(column: 4, row: 2))
    
    world.place(Stair(), facing: east, at: Coordinate(column: 3, row: 5))
    
    world.place(Stair(), facing: north, at: Coordinate(column: 2, row: 4))
}
