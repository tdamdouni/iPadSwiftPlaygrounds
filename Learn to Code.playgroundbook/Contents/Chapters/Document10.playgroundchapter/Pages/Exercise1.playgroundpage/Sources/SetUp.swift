// 
//  SetUp.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
import Foundation

// MARK: Globals
public let world = loadGridWorld(named: "10.1")
public var greenPortal = Portal(color: .green)

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
    world.place(actor, facing: north, at: Coordinate(column: 3, row: 0))
}

func placeItems() {
    world.place(nodeOfType: Switch.self, at: [Coordinate(column: 0, row: 3)])
    world.place(nodeOfType: Switch.self, at: [Coordinate(column: 3, row: 6)])
    world.place(nodeOfType: Switch.self, at: [Coordinate(column: 6, row: 3)])
}

func placePortals() {
    world.place(greenPortal, between: Coordinate(column: 3, row: 3), and: Coordinate(column: 5, row: 0))
}

func placeBlocks() {
    world.removeNodes(at: world.coordinates(inColumns: [0,1,2], intersectingRows: [0,1,2]))
    world.placeWater(at: world.coordinates(inColumns: [0,1,2], intersectingRows: [0,1,2]))
    
    world.placeBlocks(at: [Coordinate(column: 1, row: 1)])
    
    world.removeNodes(at: world.coordinates(inColumns: [4,5,6], intersectingRows: [0,1,2]))
    world.placeWater(at: world.coordinates(inColumns: [4,5,6], intersectingRows: [0,1,2]))
    
    world.removeNodes(at: world.coordinates(inColumns: [0,1,2,4,5,6], intersectingRows: [4]))
    world.placeWater(at: world.coordinates(inColumns: [0,1,2,4,5,6], intersectingRows: [4]))
    
    let obstacles = [
                        Coordinate(column: 2, row: 6),
                        Coordinate(column: 2, row: 5),
                        Coordinate(column: 4, row: 6),
                        Coordinate(column: 4, row: 5),
                        ]
    world.removeNodes(at: obstacles)
    world.placeWater(at: obstacles)
    
    world.placeBlocks(at: [Coordinate(column: 5, row: 1)])
    world.placeBlocks(at: [Coordinate(column: 5, row: 0)])
    
    
    world.place(Block(), at: Coordinate(column: 3, row: 0))
    world.place(Block(), at: Coordinate(column: 0, row: 3))
    world.place(Block(), at: Coordinate(column: 6, row: 3))
    world.place(Block(), at: Coordinate(column: 3, row: 6))
    
    world.place(Block(), at: Coordinate(column: 0, row: 6))
    world.place(Block(), at: Coordinate(column: 0, row: 6))
    world.place(Block(), at: Coordinate(column: 1, row: 6))
    world.place(Block(), at: Coordinate(column: 0, row: 5))
    
    world.place(Block(), at: Coordinate(column: 6, row: 6))
    world.place(Block(), at: Coordinate(column: 6, row: 6))
    world.place(Block(), at: Coordinate(column: 5, row: 6))
    world.place(Block(), at: Coordinate(column: 6, row: 5))
    
    world.place(Stair(), facing: north, at: Coordinate(column: 3, row: 1))
    world.place(Stair(), facing:  south, at: Coordinate(column: 3, row: 5))
    
    world.place(Stair(), facing: west, at: Coordinate(column: 5, row: 3))
    world.place(Stair(), facing: east, at: Coordinate(column: 1, row: 3))

    world.place(greenPortal, between: Coordinate(column: 3, row: 3), and: Coordinate(column: 5, row: 0))
}
