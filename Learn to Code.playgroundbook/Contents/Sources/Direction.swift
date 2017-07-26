// 
//  Direction.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
import SceneKit

public let north = Direction.north
public let south = Direction.south
public let east = Direction.east
public let west = Direction.west

public enum Direction: String {
    case north, south // -z (with the camera)/ +z direction
    case east, west // +x/ -x direction
    
    public static var all: [Direction] {
        return [.north, .south, .east, .west]
    }
    
    init(from oldPosition: Coordinate, to newPosition: Coordinate) {
        let dx = round(Double(newPosition.column - oldPosition.column) * 10)
        let dy = round(Double(newPosition.row - oldPosition.row) * 10)
        
        if dx > 0 { self = Direction.east }
        else if dx < 0 { self = Direction.west }
        else if dy >= 0 { self = Direction.north }
        else {
            self = Direction.south
        }
    }
    
    /**
     Interpret the resulting x z coordinates as follows:
     - 0: South (+z)
     - π: north (-z)
     - -π/2: West (-x)
     - π/2: East (+x)
     
     Notes:
     First, a default unit circle would have 0 point in the
     +x direction, for this set up it is easier to talk about direction
     if 0 points in the -z direction (The direction the actor is initially
     facing).
     
     Therefore, subtract π / 2 from the direction before passing it to sin()
     and cos().
     */
    init(radians: SCNFloat) {
        let correctRotation = radians - π / 2 // To account for 0 in the +z direction.
        
        let x = cos(correctRotation)
        let y = sin(correctRotation)
        
        if x < 0 && y.isClose(to: 0) { self = Direction.west}
        else if x > 0 && y.isClose(to: 0) { self = Direction.east }
        else if x.isClose(to: x) && y > 0 { self = Direction.north }
        else {
            assert(x.isClose(to: x) && y < 0)
            self = Direction.south
        }
    }
}

extension Direction {
    
    var radians: SCNFloat {
        switch self {
        case .north: return π
        case .south: return 0
        case .east: return π / 2
        case .west: return -π / 2
        }
    }
    
    /// Returns an index matching each of the cardinal directions. (For use with some of the order access coordinate methods. @see `cardinalCoordinatesAround(_:)`
    var index: Int {
        switch self {
        case .north: return 0
        case .south: return 1
        case .east: return 2
        case .west: return 3
        }
    }
    
    var vector: float2 {
        switch self {
        case .north: return [0, 1]
        case .south: return [0, -1]
        case .west: return [-1, 0]
        case .east: return [1, 0]
        }
    }
}

extension Direction {
    func angle(to direction: Direction) -> SCNFloat {
        let angle = angleBetween(self.vector, v2: direction.vector)
        let dir = cross(self.vector, direction.vector)
        return angle * SCNFloat(dir.z == 0 ? 1 : dir.z)
    }
    
    func isOpposite(of direction: Direction) -> Bool {
        switch (self, direction) {
        case (.east, .west), (.west, .east): return true
        case (.north, .south), (.south, .north): return true
        default: return false
        }
    }
}



