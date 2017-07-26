// 
//  GridWorld+ActorChecks.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//

import SceneKit

extension GridWorld {
    struct MovementObstacle: OptionSet {
        /// A wall exists at the destination.
        static var wall        = MovementObstacle(rawValue: 1 << 0)
        
        /// The destination is off the edge of the map (into the void or water).
        static var edge        = MovementObstacle(rawValue: 1 << 1)
        
        /// The destination is occupied by another actor or blocking object.
        static var occupied    = MovementObstacle(rawValue: 1 << 2)
        
        /// The destination is lower than the start blocking movement.
        static var loweredTile = MovementObstacle(rawValue: 1 << 3)
        
        /// The destination is higher than the start blocking movement.
        static var raisedTile  = MovementObstacle(rawValue: 1 << 4)
        
        let rawValue: UInt
        
        var isFallingHazard: Bool {
            return isIntersecting(with: [.loweredTile, .edge])
        }
        
        var isCollisionHazard: Bool {
            return isIntersecting(with: [.wall, .raisedTile, .occupied])
        }
    }
    
    /// Determines if an actor can move forward in the given direction from the starting position.
    func isValidActorTranslation(heading: Direction, from start: SCNVector3) -> Bool {
        return movementObstacle(heading: heading, from: start).isEmpty
    }
    
    /// Provides all the obstacles preventing actor movement.
    func movementObstacle(heading: Direction, from start: SCNVector3) -> MovementObstacle {
        let startCoordinate = Coordinate(start)
        let endCoordinate = startCoordinate.neighbor(inDirection: heading)
        
        var result = MovementObstacle()
        
        if isWall(heading, from: startCoordinate) {
            result.insert(.wall)
        }
        
        let top = topItem(at: endCoordinate)
        if top == nil || top is Water {
            result.insert(.edge)
        }
        
        if isActor(at: endCoordinate) || isLock(at: endCoordinate) {
            result.insert(.occupied)
        }
        
        // Look for a height difference between the start and end coordinates.
        let startY = nodeHeight(at: startCoordinate)
        let endY = nodeHeight(at: endCoordinate)
        let isHeightDifference = !endY.isClose(to: startY, epiValue: WorldConfiguration.heightTolerance)
        
        // If there is a height difference, check if there are stairs.
        if isHeightDifference
            && !isValidStairApproach(from: startCoordinate, to: endCoordinate, heightDelta: endY - startY) {
            if endY > startY {
                result.insert(.raisedTile)
            }
            else {
                result.insert(.loweredTile)
            }
        }
    
        return result
    }
    
    // Helper
    
    /// Checks for the existence of a wall between the two adjacent coordinates.
    func isWall(_ heading: Direction, from startCoordinate: Coordinate) -> Bool {
        let endCoordinate = startCoordinate.neighbor(inDirection: heading)
        
        let adjacentCoordinates = [
            startCoordinate,
            endCoordinate
        ]
        
        let walls = existingItems(ofType: Wall.self, at: adjacentCoordinates)
        return walls.contains { wall in
            wall.blocksMovement(from: startCoordinate, to: endCoordinate)
        }
    }
    
    func isObstacle(at coordinate: Coordinate) -> Bool {
        return existingItem(ofType: Water.self, at: coordinate) != nil
    }
    
    func isLock(at coordinate: Coordinate) -> Bool {
        return existingItem(ofType: PlatformLock.self, at: coordinate) != nil
    }
    
    /// Checks if another actor is currently occupying the same position.
    func isActor(at coordinate: Coordinate) -> Bool {
        return existingItem(ofType: Actor.self, at: coordinate) != nil
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
        if heightDelta > 0, let stair = existingItem(ofType: Stair.self, at: endCoordinate) {
            // Moving onto a stairway.
            return stair.heading.isOpposite(of: angleOfApproach)
        }
        else if let stair = existingItem(ofType: Stair.self, at: startCoordinate) {
            // Moving off of a stairway.
            return stair.heading == angleOfApproach
        }
        
        return false
    }
}
