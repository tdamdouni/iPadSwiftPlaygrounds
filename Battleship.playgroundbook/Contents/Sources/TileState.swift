//
//  TileState.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//

import Foundation

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
