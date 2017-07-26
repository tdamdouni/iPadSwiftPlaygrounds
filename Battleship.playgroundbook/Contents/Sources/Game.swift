//
//  Game.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//

import Foundation
import SpriteKit
import GameplayKit

/**
 Represents a single game. This also handles all action taken by the AI
 as well as the SceneKit aspects of the UI.
 */
public class Game: GridDelegate {
    // MARK: Internal properties
    
    private var placedShips: [Ship]!
    
    public var sunkShips: [Ship] {
        return placedShips.filter { $0.isSunk }
    }
    
    public var unsunkShips: [Ship] {
        return placedShips.filter { !($0.isSunk) }
    }
    
    private var mode: GameMode = .interactive {
        didSet {
            if mode == .completed {
                delegate?.gameDidComplete(self)
            }
        }
    }
    
    private let gameAI: GameAI?
    
    private var targettedCoordinate: Coordinate?
    
    private let shootDelay: TimeInterval
    
    // MARK: Public properties
    
    public let grid: Grid

    public private(set) var turnCount = 0 {
        didSet {
            delegate?.gameDidTakeTurn(self)
        }
    }
    
    weak var delegate: GameDelegate?
    
    // MARK: Initialization
    
    public init(coordinateSize: Int, gameAI: GameAI? = nil, shootDelay: TimeInterval = 0.0) {
        self.shootDelay = shootDelay
        grid = Grid(coordinateSize: coordinateSize)
        self.gameAI = gameAI
        
        self.gameAI?.game = self

        // Place ships on the grid.
        placedShips = placeShips()

        // Register for as a delegate for user interactions with the grid.
        grid.gridDelegate = self
    }
    
    // MARK:
    
    func complete() {
        guard mode == .interactive else { return }

        guard let target = targettedCoordinate else { return }

        mode = .simulating
        shoot(at: target)
    }
    
    func markNextSuggestedTarget() -> Coordinate? {
        guard let gameAI = gameAI else { return nil }
        
        // Clear any previously suggested target.
        if let previousTarget = targettedCoordinate {
            let tile = grid.tileAt(previousTarget)
            if tile.state == .suggested {
                tile.state = .unexplored
            }
        }
        
        var nextSuggestion: Coordinate
        
        if let previousCoordinate = targettedCoordinate, grid.coordinateIsValid(previousCoordinate) {
            // Use the targetting function to determine where to shoot next.
            let previousTile = grid.tileAt(previousCoordinate)
            nextSuggestion = gameAI.nextCoordinate(previousTile: previousTile)
        }
        else {
            nextSuggestion = gameAI.firstCoordinate()
        }

        // Mark the associated tile as suggested.
        let tile = grid.tileAt(nextSuggestion)
        if tile.state == .unexplored {
            tile.state = .suggested
        }

        targettedCoordinate = nextSuggestion
        return nextSuggestion
    }
    
    private func shoot(at target: Coordinate) {
        guard grid.coordinateIsValid(target) else { return }
        
        let tile = grid.tileAt(target)
        
        if tile.state == .unexplored || tile.state == .suggested {
            // Increment the turn count.
            turnCount += 1
            
            // Check if the coordinate hits a ship.
            let tile = grid.tileAt(target)
            if let ship = tile.ship {
                tile.state = .hit
                ship.damage += 1
            }
            else {
                tile.state = .miss
            }

            // Check if all ships have been sunk and the game is complete.
            if sunkShips.count == placedShips.count {
                mode = .completed
                return
            }
        }
        
        // Mark the next suggested target.
        if let nextTarget = markNextSuggestedTarget() {
            // If the current mode is `simulating`, shoot at the suggested target.
            if mode == .simulating {
                if shootDelay < 0.1 {
                    shoot(at: nextTarget)
                }
                else {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                        self.shoot(at: nextTarget)
                    }
                }
            }
        }
    }
    
    // MARK: GridDelegate
    
    func baord(_ grid: Grid, didTap coordinate: Coordinate) { // TODO: Spelling
        if let suggestion = grid.coordinates(withState: .suggested).first {
            // If targets are being suggested, shoot at the suggestion
            shoot(at: suggestion)
        }
        else {
            // The user is deciding where to shoot, shoot at the tile they tapped.
            shoot(at: coordinate)
        }
    }
}

protocol GameDelegate: class {
    func gameDidComplete(_ game: Game)
    func gameDidTakeTurn(_ game: Game)
}
