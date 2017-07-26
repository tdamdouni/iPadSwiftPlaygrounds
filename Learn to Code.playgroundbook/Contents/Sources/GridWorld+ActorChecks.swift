// 
//  GridWorld+ActorChecks.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//

import SceneKit

extension GridWorld {
    enum MovementResult {
        case valid
        case wall
        case obstacle
        case edge
        case raisedTile
        case occupied
    }
    
    /**
     Determines if an actor can move to the destination.
     
     Checks for walls between tiles, obstacles on the end tile, and that a
     tile exists to walk on. Also will check if another actor is currently at
     the end tile.
     */
    func isValidActorTranslation(heading: Direction, from start: SCNVector3) -> Bool {
        return movementResult(heading: heading, from: start) == .valid
    }
    
    func movementResult(heading: Direction, from start: SCNVector3) -> MovementResult {
        let startCoordinate = Coordinate(start)
        let endCoordinate = startCoordinate.neighbor(inDirection: heading)
        
        // Ordering is important, if a wall sits at an edge the actor should bump rather than almost fall off.
        if isWall(heading, from: startCoordinate) {
            return .wall
        }
        
        // Look for height difference.
        let startY = height(at: startCoordinate)
        let endY = height(at: endCoordinate)
        if !endY.isClose(to: startY, epiValue: WorldConfiguration.heightTolerance) {
            if !isValidStairApproach(from: startCoordinate, to: endCoordinate, heightDelta: endY - startY) {
                return endY > startY ? .raisedTile : .edge
            }
        }

        if isLock(at: endCoordinate) {
            return .wall
        }
        
        if isActor(at: endCoordinate) {
            return .occupied
        }
    
        return .valid
    }
    
    // Helper
    
    /// Checks for the existence of a wall between the two adjacent coordinates.
    func isWall(_ heading: Direction, from startCoordinate: Coordinate) -> Bool {
        let endCoordinate = startCoordinate.neighbor(inDirection: heading)
        
        let adjacentCoordinates = [
            startCoordinate,
            endCoordinate
        ]
        
        let walls = existingNodes(ofType: Wall.self, at: adjacentCoordinates)
        return walls.contains { wall in
            wall.blocksMovement(from: startCoordinate, to: endCoordinate)
        }
    }
    
    func isObstacle(at coordinate: Coordinate) -> Bool {
        return existingNode(ofType: Water.self, at: coordinate) != nil
    }
    
    func isLock(at coordinate: Coordinate) -> Bool {
        return existingNode(ofType: PlatformLock.self, at: coordinate) != nil
    }
    
    /// Checks if another actor is currently occupying the same position.
    func isActor(at coordinate: Coordinate) -> Bool {
        return existingNode(ofType: Actor.self, at: coordinate) != nil
    }
    
    /// Determines if there is a stair node at the `startCoordinate` or `endCoordinate` and checks if the actor is taking a valid approach up or down the stairs.
    func isValidStairApproach(from startCoordinate: Coordinate, to endCoordinate: Coordinate, heightDelta: SCNFloat) -> Bool {
        // Cannot cover more than the `levelHeight` with a single stair.
        let maxDelta = WorldConfiguration.levelHeight
        
        guard abs(heightDelta).isClose(to: maxDelta, epiValue: WorldConfiguration.heightTolerance) else {
            return false
        }
        let angleOfApproach = Direction(from: startCoordinate, to: endCoordinate)
        
        // HeightDelta is necessary for two stair cases back to back.
        if heightDelta > 0, let stair = existingNode(ofType: Stair.self, at: endCoordinate) {
            // Moving onto a staircase.
            return stair.heading.isOpposite(of: angleOfApproach)
        }
        else if let stair = existingNode(ofType: Stair.self, at: startCoordinate) {
            // Moving off of a staircase.
            return stair.heading == angleOfApproach
        }
        
        return false
    }
}
