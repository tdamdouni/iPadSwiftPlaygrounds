// 
//  SetUp.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
import Foundation

// MARK: Globals
//public let world = GridWorld(columns: 8, rows: 8)
public let world = loadGridWorld(named: "13.2")
let actor = Actor()

public func playgroundPrologue() {
//    placeBlocks()
    placeItems()

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

func placeBlocks() {
    world.removeNodes(at: world.allPossibleCoordinates)
    
    world.placeBlocks(at: world.coordinates(inColumns: 0...3, intersectingRows: [6,7]))
    world.placeBlocks(at: world.coordinates(inColumns: 1...3, intersectingRows: 0...3))
    world.placeBlocks(at: world.coordinates(inColumns: 5...7, intersectingRows: 3...6))
    world.placeBlocks(at: world.coordinates(inColumns: 5...7, intersectingRows: 3...6))
    
    
    let tiers = [
                    Coordinate(column: 0, row: 7),
                    Coordinate(column: 0, row: 7),
                    Coordinate(column: 1, row: 7),
                    Coordinate(column: 2, row: 6),
                    Coordinate(column: 3, row: 6),
                    
                    Coordinate(column: 1, row: 0),
                    Coordinate(column: 2, row: 0),
                    Coordinate(column: 3, row: 0),
                    Coordinate(column: 2, row: 1),
                    
                    Coordinate(column: 5, row: 4),
                    Coordinate(column: 6, row: 4),
                    Coordinate(column: 7, row: 6),
                    Coordinate(column: 7, row: 6),
                    Coordinate(column: 7, row: 5),
                    ]
    world.placeBlocks(at: tiers)

}

func placeItems() {
    let dzCoords = [
                       Coordinate(column: 1, row: 7),
                       Coordinate(column: 2, row: 6),
                       Coordinate(column: 1, row: 1),
                       Coordinate(column: 2, row: 2),
                       Coordinate(column: 5, row: 4),
                       Coordinate(column: 6, row: 3),
                       ]
    world.place(nodeOfType: Switch.self, at: dzCoords)
    
    let itemCoords = [
                         Coordinate(column: 1, row: 6),
                         Coordinate(column: 2, row: 1),
                         Coordinate(column: 6, row: 4),
                         ]
    world.placeGems(at: itemCoords)
    
}

    



