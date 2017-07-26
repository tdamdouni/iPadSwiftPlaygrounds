// 
//  Coordinate.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//

import SceneKit

/// Specifies a 2D location in a grid (column, row) -> (x, y)
public struct Coordinate {
    public let column, row: Int
    
    public init(column: Int, row: Int) {
        self.column = column
        self.row = row
    }
}

/// World Positioning
extension Coordinate {
    
    /// Provides the 2D position (0 y component) for a Coordinate.
    var position: SCNVector3 {
        let scaledX = SCNFloat(column) * WorldConfiguration.coordinateLength
        let scaledZ = -SCNFloat(row) * WorldConfiguration.coordinateLength
        return SCNVector3(Float(scaledX), 0, Float(scaledZ))
    }
    
    init(_ position: SCNVector3) {
        self.column = Int(round(position.x / WorldConfiguration.coordinateLength))
        self.row = Int(round(-position.z / WorldConfiguration.coordinateLength))
    }
}

extension Coordinate: CustomStringConvertible {
    
    public var description: String {
        return "column \(column), row \(row)"
    }
}

extension Coordinate {
    
    /**
     Provides the coordinates surrounding the coordinate in each of the
     four cardinal directions (N, S, E, W).
     */
    public var neighboringCoordinates: [Coordinate] {
        return [
                   neighbor(inDirection: .north),
                   neighbor(inDirection: .south),
                   neighbor(inDirection: .east),
                   neighbor(inDirection: .west)
        ]
    }
    
    /// Calculates the number of coordinates between the receiver and the provided coordinate (non-diagonal movement).
    public func distance(to coordinate: Coordinate) -> Int {
        let col: Int = column - coordinate.column
        let colAbs: Int = abs(col)
        let ro: Int = row - coordinate.row
        let roAbs: Int = abs(ro)
        
        return colAbs + roAbs
    }
    
    public func neighbor(inDirection direction: Direction) -> Coordinate {
        return advanced(by: 1, inDirection: direction)
    }
    
    public func advanced(by displacement: Int, inDirection direction: Direction) -> Coordinate {
        // -M_PI_2 to calibrate for 0 in the +z direction (Normally it would be in the +x).
        let dx = Int(round(cos(direction.radians - π / 2))) * displacement
        let dy = Int(round(sin(direction.radians - π / 2))) * displacement
        
        return Coordinate(column: column + dx, row: row + dy)
    }
}

extension Coordinate: Hashable {
    public var hashValue: Int {
        // Pairing function: https://en.wikipedia.org/wiki/Pairing_function
        return (((row + column) * (row + column + 1)) / 2) + column
    }
}

public func ==(c1: Coordinate, c2: Coordinate) -> Bool {
    return c1.row == c2.row && c1.column == c2.column
}
