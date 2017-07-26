// 
//  SetUp.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
import Foundation

// MARK: Globals
//public let world = GridWorld(columns: 7, rows: 7)
public let world = loadGridWorld(named: "13.6")
let actor = Actor()

public func playgroundPrologue() {
    Display.coordinateMarkers = true

//  placeBlocks()
    
    placeWalls()
    placeItems()
    
    world.place(actor, facing: east, at: Coordinate(column: 0, row: 5))

    // Must be called in `playgroundPrologue()` to update with the current page contents.
    registerAssessment(world, assessment: assessmentPoint)
    
    //// ----
    // Any items added or removed after this call will be animated.
    finalizeWorldBuilding(for: world)
    //// ----
}

public func presentWorld() {
    setUpLiveViewWith(world)
    
}

// MARK: Epilogue

public func playgroundEpilogue() {
    sendCommands(for: world)
}

// MARK: Placement
    
func placeItems() {
    let itemCoordinates = [
        Coordinate(column: 0, row: 5),
        Coordinate(column: 1, row: 6),
        Coordinate(column: 1, row: 4),
        Coordinate(column: 2, row: 5),
        
        Coordinate(column: 5, row: 0),
        Coordinate(column: 6, row: 1),
        Coordinate(column: 4, row: 1),
        Coordinate(column: 5, row: 2),
        
        ]
    world.placeGems(at: itemCoordinates)
}

func placeWalls() {
    world.place(Wall(edges: [.bottom, .right]), at: Coordinate(column: 0, row: 6))
    world.place(Wall(edges: [.bottom, .right]), at: Coordinate(column: 4, row: 2))
    world.place(Wall(edges: [.top, .left]), at: Coordinate(column: 6, row: 0))
    world.place(Wall(edges: [.top, .left]), at: Coordinate(column: 2, row: 4))
    world.place(Wall(edges: [.top, .right]), at: Coordinate(column: 0, row: 4))
    world.place(Wall(edges: [.top, .right]), at: Coordinate(column: 4, row: 0))
    world.place(Wall(edges: [.bottom, .left]), at: Coordinate(column: 2, row: 6))
    world.place(Wall(edges: [.bottom, .left]), at: Coordinate(column: 6, row: 2))
}

func placeBlocks() {
    world.removeItems(at: world.allPossibleCoordinates)
    
    world.placeBlocks(at: world.coordinates(inColumns: [0,1,2], intersectingRows: [4,5,6]))
    world.placeBlocks(at: world.coordinates(inColumns: [0,1,2], intersectingRows: [4,5,6]))
    world.placeBlocks(at: world.coordinates(inColumns: [0,1,2], intersectingRows: [4,5,6]))
    world.placeBlocks(at: world.coordinates(inColumns: [0,1,2], intersectingRows: [4,5,6]))
    
    world.placeBlocks(at: world.coordinates(inColumns: [4,5,6], intersectingRows: [0,1,2]))
    world.placeBlocks(at: world.coordinates(inColumns: [4,5,6], intersectingRows: [0,1,2]))
    world.placeBlocks(at: world.coordinates(inColumns: [4,5,6], intersectingRows: [0,1,2]))
    world.placeBlocks(at: world.coordinates(inColumns: [4,5,6], intersectingRows: [0,1,2]))
}
