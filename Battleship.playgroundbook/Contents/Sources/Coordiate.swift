//
//  Coordiate.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//

import Foundation

public struct Coordinate {
    public let row: Int
    public let column: Int
    
    init() {
        row = 0
        column = 0
    }
    
    public static let invalid = Coordinate(column: -1, row: -1)
    
    public init(column: Int, row: Int) {
        self.column = column
        self.row = row
    }
    
    public func neighbor(inDirection direction: Direction) -> Coordinate {
        return advanced(by: 1, inDirection: direction)
    }
    
    public func advanced(by displacement: Int, inDirection direction: Direction) -> Coordinate {
        switch direction {
        case .north:
            return Coordinate(column: column, row: row + displacement)
        case .south:
            return Coordinate(column: column, row: row - displacement)
        case .east:
            return Coordinate(column: column + displacement, row: row)
        case .west:
            return Coordinate(column: column - displacement, row: row)
        }
    }
}

extension Coordinate: CustomStringConvertible {
    
    public var description: String {
        return "column \(column), row \(row)"
    }
}

extension Coordinate: Equatable {}

public func ==(c1: Coordinate, c2: Coordinate) -> Bool {
    return c1.row == c2.row && c1.column == c2.column
}
