//
//  SimulateGameOperation.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//

import Foundation

internal class SimulateGameOperation: Operation {
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
