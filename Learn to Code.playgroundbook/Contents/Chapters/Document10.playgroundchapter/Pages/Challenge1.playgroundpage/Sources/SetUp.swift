// 
//  SetUp.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
import Foundation

// MARK: Globals
public let world = loadGridWorld(named: "10.2")
let actor = Actor()

public var purplePortal = Portal(color: .purple)

public func playgroundPrologue() {
    placeItems()
    placeActor()
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

func placeItems() {
    world.place(Switch(), at: Coordinate(column: 0, row: 1))
    world.placeGems(at: world.coordinates(inColumns: [3,4,5], intersectingRows: [1]))
    world.placeGems(at: world.coordinates(inColumns: [3,4,5,6], intersectingRows: [4]))
}

func placePortals() {
    world.place(purplePortal, between: Coordinate(column: 2, row: 4), and: Coordinate(column: 2, row: 1))
}

func placeActor() {
    world.place(actor, facing: east, at: Coordinate(column:0, row: 4))
}

func placeBlocks() {
    world.removeNodes(at: world.coordinates(inColumns: [4,5,6], intersectingRows: [2,3,5,6]))
    world.placeWater(at: world.coordinates(inColumns: [4,5,6], intersectingRows: [2,3,5,6]))
    
    world.removeNodes(at: world.coordinates(inColumns: [6], intersectingRows: [0,1]))
    world.placeWater(at: world.coordinates(inColumns: [6], intersectingRows: [0,1]))
    
    world.removeNodes(at: world.coordinates(inColumns: [0,1,2,3], intersectingRows: [5]))
    world.placeWater(at: world.coordinates(inColumns: [0,1,2,3], intersectingRows: [5]))
    
    world.removeNodes(at: world.coordinates(inColumns: [4,5], intersectingRows: [0]))
    world.placeWater(at: world.coordinates(inColumns: [4,5], intersectingRows: [0]))
    
    world.placeBlocks(at: world.coordinates(inColumns: [0,1,2,3], intersectingRows: [7]))
    world.placeBlocks(at: world.coordinates(inColumns: [0,1,2,3], intersectingRows: [7]))
    
    world.placeBlocks(at: world.coordinates(inColumns: [1,2,3], intersectingRows: [6]))
    
    world.placeBlocks(at: world.coordinates(inColumns: [1,2,3], intersectingRows: [2,3]))
    world.placeBlocks(at: world.coordinates(inColumns: [0,1,2], intersectingRows: [2]))
    
    world.placeBlocks(at: world.coordinates(inColumns: [1,2,3], intersectingRows: [0]))
    
    let tiers = [
                    Coordinate(column: 1, row: 6),
                    Coordinate(column: 2, row: 6),
                    Coordinate(column: 2, row: 6),
                    Coordinate(column: 3, row: 6),
                    Coordinate(column: 3, row: 6),
                    Coordinate(column: 3, row: 6),
                    Coordinate(column: 0, row: 3)
    ]
    world.placeBlocks(at: tiers)
    
    world.removeNodes(at: world.coordinates(inColumns: [2,3], intersectingRows: [3]))
    world.placeWater(at: world.coordinates(inColumns: [2,3], intersectingRows: [3]))
}
