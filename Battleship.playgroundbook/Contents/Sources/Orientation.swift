//
//  Orientation.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//

import Foundation

/// An enumeration representing the possible ship orientations.
public enum Orientation: Int {
    case horizontal
    case vertical
    
    static func random() -> Orientation {
        return Orientation(rawValue: Int(arc4random()) % 2)!
    }
    
    init(from: Coordinate, to: Coordinate) {
        if from.row == to.row {
            self = .horizontal
        }
        else if from.column == to.column {
            self = .vertical
        }
        else {
            fatalError("Diagonal orientaions not supported")
        }
    }
}
