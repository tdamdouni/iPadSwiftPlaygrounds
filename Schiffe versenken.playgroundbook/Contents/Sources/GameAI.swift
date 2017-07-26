//
//  GameAI.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//

import Foundation

public protocol GameAI: class {
    weak var game: Game! { get set }

    /// This function is called to determine the first coordinate to fire at.
    func firstCoordinate() -> Coordinate

    /// This function returns the coordinate to fire at for each turn after the first.
    func nextCoordinate(previousTile: Tile) -> Coordinate
}

public typealias CreateGameAI = () -> GameAI
