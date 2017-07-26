//
//  Coordinate.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//

import Foundation

/// A brick coordinate in level space.
public struct Coordinate: Equatable {
    public var column: Int
    public var row: Int
    
    public init(column: Int, row: Int) {
        self.column = column
        self.row = row
    }

    public static func ==(lhs: Coordinate, rhs: Coordinate) -> Bool {
        return lhs.row == rhs.row && lhs.column == rhs.column
    }
}
