// 
//  SetUp.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//
import Foundation

// MARK: Globals
public let world = loadGridWorld(named: "10.3")
public var bluePortal = Portal(color: .blue)
public var pinkPortal = Portal(color: .pink)
let actor = Actor()

public func playgroundPrologue() {
    
    placeActor()
    placeItems()
    placePortals()

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
    world.place(actor, facing: north, at: Coordinate(column: 1, row: 1))
}

func placePortals() {
    world.place(bluePortal, between: Coordinate(column: 1, row: 2), and: Coordinate(column: 6, row: 3))
    world.place(pinkPortal, between: Coordinate(column: 1, row: 3), and: Coordinate(column: 4, row: 1))
}

func placeItems() {
    let itemCoordinates = [
                              Coordinate(column: 1, row: 4),
                              Coordinate(column: 4, row: 2),
                              Coordinate(column: 6, row: 2),
                              Coordinate(column: 6, row: 4),
                              
                              ]
    world.placeGems(at: itemCoordinates)
}

func placeBlocks() {
    world.placeBlocks(at: world.coordinates(inColumns: [5], intersectingRows: [1,2,3,4,5]))
    world.placeBlocks(at: world.coordinates(inColumns: [3], intersectingRows: [0,1,2,3]))
    world.placeBlocks(at: world.coordinates(inColumns: [3], intersectingRows: [0,1]))
    
    
    world.removeItems(at: world.coordinates(inColumns: [3,4], intersectingRows: [4,5]))
    world.placeWater(at: world.coordinates(inColumns: [3,4], intersectingRows: [4,5]))
    
    let obstacles = [
                        Coordinate(column: 1, row: 5),
                        Coordinate(column: 4, row: 3),
                        Coordinate(column: 6, row: 5),
                        
                        
                        
                        ]
    world.removeItems(at: obstacles)
    world.placeWater(at: obstacles)
    
    world.removeItems(at: world.coordinates(inColumns: [0,1,2,4,5,6], intersectingRows: [0]))
    world.placeWater(at: world.coordinates(inColumns: [0,1,2,4,5,6], intersectingRows: [0]))
    
    let tiers = [
                    Coordinate(column: 0, row: 5),
                    Coordinate(column: 0, row: 5),
                    Coordinate(column: 0, row: 4),
                    Coordinate(column: 2, row: 5),
                    Coordinate(column: 2, row: 5),
                    Coordinate(column: 2, row: 4),
                    Coordinate(column: 3, row: 0),
                    
                    Coordinate(column: 5, row: 5),
                    Coordinate(column: 5, row: 5),
                    Coordinate(column: 5, row: 5),
                    
                    
                    Coordinate(column: 5, row: 4),
                    Coordinate(column: 5, row: 4),
                    
                    Coordinate(column: 5, row: 3),
                    
                    
                    
                    
                    ]
    world.placeBlocks(at: tiers)
}