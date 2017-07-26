//
//  Direction.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//

import Foundation

/// Enum for indicating direction on the grid (North, South, East, and West).
public enum Direction {
    case north, south, east, west
    
    /// All the valid directions (North, South, East, and West).
    public static let all: [Direction] = [.north, .east, .south, .west]
}
