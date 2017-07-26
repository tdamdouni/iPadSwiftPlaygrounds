//
//  TileState.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//

import Foundation

/// Enum for determining the state of a tile on the grid (unexplored, hit, miss, suggested, or invalid).
public enum TileState {
    case unexplored
    case hit
    case miss
    case suggested
    case invalid
}

extension TileState: CustomDebugStringConvertible {
    public var debugDescription: String {
        let description: String
        
        switch self {
        case .unexplored:
            description = "Unexplored"
        case .hit:
            description = "Hit"
        case .miss:
            description = "Miss"
        case .suggested:
            description = "Suggested"
        case .invalid:
            description = "Invalid"
        }
        
        return "TileState.\(description)"
    }
}
