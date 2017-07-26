// 
//  SetUp.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//
import Foundation

// MARK: Globals
//public let world = GridWorld(columns: 8, rows: 7)
public let world = loadGridWorld(named: "13.4")
public func playgroundPrologue() {
    Display.coordinateMarkers = true
    // Must be called in `playgroundPrologue()` to update with the current page contents.
    world.successCriteria = .pageSpecific(world.didAddGemOrSwitch)
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
    world.removeItems(at: world.coordinates(inColumns: [3], intersectingRows: [4,5,6]))
    world.placeWater(at: world.coordinates(inColumns: [3], intersectingRows: [4,5,6]))
    
    world.removeItems(at: world.coordinates(inColumns: [7], intersectingRows: 0...4))
    world.placeWater(at: world.coordinates(inColumns: [7], intersectingRows: 0...4))
    world.removeItems(at: world.coordinates(inColumns: [5,6], intersectingRows: [0]))
    world.placeWater(at: world.coordinates(inColumns: [5,6], intersectingRows: [0]))
    
    world.placeBlocks(at: world.coordinates(inColumns: 0...2, intersectingRows: [4,5]))
    world.placeBlocks(at: world.coordinates(inColumns: [6,7,5], intersectingRows: [5,6]))
    world.placeBlocks(at: world.coordinates(inColumns: [7], intersectingRows: [5,6]))
    world.placeBlocks(at: world.coordinates(inColumns: [5,6,4], intersectingRows: [4,5,6]))
    world.placeBlocks(at: world.coordinates(inColumns: [0], intersectingRows: [0,1]))
}
