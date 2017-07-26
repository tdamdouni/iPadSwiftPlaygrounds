// 
//  Point.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//

import CoreGraphics

/// Specifies a point in the scene with x and y coordinates.
public struct Point {
    
    /// The x coordinate for the point.
    public var x: Double
    
    /// The y coordinate for the point.
    public var y: Double
    
    /// Creates a Point with an x and y coordinate.
    public init(x: Double, y: Double) {
        self.x = x
        self.y = y
    }
}

extension Point {
    /// Creates a Point with an x and y coordinate.
    public init(x: Number, y: Number) {
        self.x = x.double
        self.y = y.double
    }
    
    /// Creates a Point with an x and y coordinate.
    public init(x: Int, y: Int) {
        self.x = Double(x)
        self.y = Double(y)
    }

    /// Creates a Point with an x and y coordinate.
    public init(_ point: CGPoint) {
        self.x = Double(point.x)
        self.y = Double(point.y)
    }
}

extension Point: Hashable, Equatable {
    
    public var hashValue: Int {
        return "\(x) \(y)".hashValue
    }
    
    public static func ==(lhs: Point, rhs: Point) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y
    }
}


extension CGPoint {
    public init(_ point: Point) {
        self.x = CGFloat(point.x)
        self.y = CGFloat(point.y)
    }
}
