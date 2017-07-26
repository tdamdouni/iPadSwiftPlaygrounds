//
//  Orientation.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//

import Foundation

/// An enum representing possible ship orientations.
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
