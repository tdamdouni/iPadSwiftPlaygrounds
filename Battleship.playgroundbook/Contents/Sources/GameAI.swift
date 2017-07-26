//
//  GameAI.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//

import Foundation

public protocol GameAI: class {
    weak var game: Game! { get set }

    func firstCoordinate() -> Coordinate

    func nextCoordinate(previousTile: Tile) -> Coordinate
}

public typealias CreateGameAI = () -> GameAI
