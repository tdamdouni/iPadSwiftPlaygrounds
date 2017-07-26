//
//  SimulateGameOperation.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//

import Foundation

class SimulateGameOperation: Operation {
    // MARK: Properties
    let progress: Progress
    
    private(set) var completedTurnCount: Int?
    
    private let gameAI: GameAI
    
    // MARK: Intitialization
    
    init(gameAI: GameAI) {
        self.progress = Progress(totalUnitCount: 1)
        self.gameAI = gameAI
    }
    
    // MARK: Operation methods
    
    override func main() {
        let game = Game(coordinateSize: 10, gameAI: gameAI)
        
        gameAI.game = game
        _ = game.markNextSuggestedTarget()
        game.complete()
        
        completedTurnCount = game.turnCount
        
        progress.completedUnitCount = 1
    }
}
