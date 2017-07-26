//
//  SimulateViewController.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//

import UIKit

@objc(SimulateViewController)
class SimulateViewController: UIViewController {
    // MARK: Properties
    
    @IBOutlet weak var progressView: UIProgressView!
    
    @IBOutlet weak var resultsView: UIView!
    
    @IBOutlet weak var gameCountDescriptionLabel: UILabel!

    @IBOutlet weak var averageTurnCountDescriptionLabel: UILabel!

    @IBOutlet weak var gameCountLabel: UILabel!
    
    @IBOutlet weak var averageTurnCountLabel: UILabel!
    
    weak var delegate: SimulateViewControllerDelegate?
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        gameCountDescriptionLabel.text = NSLocalizedString("Number of games played:", comment: "Label for how many simulated runs of the game have been completed so far")
        averageTurnCountDescriptionLabel.text = NSLocalizedString("Average number of turns per game:", comment: "Label for how many turns on average your algorithm takes to win the game")
    }
    
    private var simulationProgress: Progress? {
        didSet {
            progressView.observedProgress = simulationProgress
            progressView.isHidden = simulationProgress == nil
        }
    }
    
    private var gameResults = [Int]() {
        didSet {
            let gameCount = gameResults.count
            let totalTurnCount = gameResults.reduce(0, +)
            let averageTurnCount: Int
            if gameCount > 0 {
                averageTurnCount = Int(Double(totalTurnCount) / Double(gameCount))
            }
            else {
                averageTurnCount = 0
            }
            
            gameCountLabel.text = "\(gameCount)"
            averageTurnCountLabel.text = "\(averageTurnCount)"
        }
    }
    
    // MARK: Convenience
    
    /// Starts simulating a number of games.
    func simulate(_ gameCount: Int, createGameAI: CreateGameAI) {
        guard simulationProgress == nil else { return }
        
        gameResults.removeAll()
        simulationProgress = Progress(totalUnitCount: Int64(gameCount))
        
        let simulationQueue = OperationQueue()
        simulationQueue.maxConcurrentOperationCount = 5
        
        // Create an operation to notify the delegate when all games have been simulated.
        let simulationCompleted = BlockOperation {
            guard !self.gameResults.isEmpty else { return }
            
            self.delegate?.simulateViewController(self, didCompleteSimulation: self.gameResults)
            self.simulationProgress = nil
        }
        
        for _ in 0 ..< gameCount {
            // Create the operation to simulate a single game.
            let playGameOperation = SimulateGameOperation(gameAI: createGameAI())
            playGameOperation.qualityOfService = .background
            simulationProgress!.addChild(playGameOperation.progress, withPendingUnitCount: 1)
            
            // Create an operation to update the results after a game has been simulated.
            let gameCompletedOperation = BlockOperation {
                guard let completedTurnCount = playGameOperation.completedTurnCount else { return }
                self.gameResults.append(completedTurnCount)
            }

            // Update inter-operation dependencies.
            gameCompletedOperation.addDependency(playGameOperation)
            simulationCompleted.addDependency(gameCompletedOperation)

            // Add the operations to their relevant queues.
            simulationQueue.addOperation(playGameOperation)
            OperationQueue.main.addOperation(gameCompletedOperation)
        }
        
        OperationQueue.main.addOperation(simulationCompleted)
    }
}

protocol SimulateViewControllerDelegate: class {
    func simulateViewController(_ controller: SimulateViewController, didCompleteSimulation results: [Int])
}
