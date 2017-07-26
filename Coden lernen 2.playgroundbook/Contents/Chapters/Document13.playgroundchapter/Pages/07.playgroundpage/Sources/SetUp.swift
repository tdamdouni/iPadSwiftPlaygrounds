// 
//  SetUp.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//
import Foundation

// MARK: Globals
public let world = GridWorld(columns: 9, rows: 9)
public let lock = PlatformLock(color: .pink)

public func playgroundPrologue() {
    Display.coordinateMarkers = true
   
    buildWorld()
    
    var placementLocations = world.coordinates(inColumns: [1,2,3,5,6,7], intersectingRows: [4])
    placementLocations += world.coordinates(inColumns: [0,4,8], intersectingRows: [3])

    let handler = assessment(world.coveredInCharacters(at: placementLocations))
    world.successCriteria = .pageSpecific(handler)

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

func buildWorld() {
    
    world.place(Gem(), at: Coordinate(column: 2, row: 4))
    world.place(Gem(), at: Coordinate(column: 6, row: 4))
    world.place(lock, at: Coordinate(column: 4, row: 8))
    var platformColumn = 0
    for _ in 1...3 {
        world.place(Platform(onLevel: 2, controlledBy: lock), at: Coordinate(column: platformColumn, row: 3))
        platformColumn += 4
    }
}

