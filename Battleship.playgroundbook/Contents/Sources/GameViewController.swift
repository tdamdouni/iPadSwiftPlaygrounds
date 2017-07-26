//
//  GameViewController.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//

import UIKit
import SpriteKit
import PlaygroundSupport

@objc(GameViewController)
public class GameViewController: UIViewController, PlaygroundLiveViewSafeAreaContainer {
    // MARK: Types
    
    private enum State {
        case playingGame(GameAI?)
        case simulating
        case completingGame
        case completed
    }
    
    // MARK: IBOutlets
    
    @IBOutlet weak var infoView: UIView!
    
    @IBOutlet weak var countLabel: UILabel!
    
    @IBOutlet weak var completeButton: UIButton!
    
    @IBOutlet weak var simulateButton: UIButton!
    
    @IBOutlet weak var resetButton: UIButton!
    
    @IBOutlet weak var waterView: GradientView!
    
    @IBOutlet weak var gameContainer: SKView!
    
    @IBOutlet weak var simulationContainerView: UIView!
    
    // MARK: Properties
    
    public var assessment: (averageTurnCount: Int, passMessage: String)?
    
    private var gradientView: GradientView {
        return view as! GradientView
    }
    
    private weak var simulateViewController: SimulateViewController?
    
    /// Called to create new instances of `GameAI` to suggest targets to a user or to determine where to shoot during simulations.
    public var createGameAI: CreateGameAI?
    
    /// The currently displayed `Game` and the `GameAI` suggesting moves.
    private var presentedGame: (game: Game, gameAI: GameAI?)?
    
    fileprivate var state: State = .playingGame(nil) {
        didSet {
            switch state {
            case .playingGame(nil):
                countLabel.text = "0"
                completeButton.isHidden = true
                simulateButton.isHidden = true
                resetButton.isHidden = true
                gameContainer.isUserInteractionEnabled = true
                gameContainer.isHidden = false
                simulationContainerView.isHidden = true
                
            case .playingGame(_):
                countLabel.text = "0"
                completeButton.isHidden = false
                simulateButton.isHidden = false
                resetButton.isHidden = true
                gameContainer.isUserInteractionEnabled = true
                gameContainer.isHidden = false
                simulationContainerView.isHidden = true
                
            case .completed:
                completeButton.isHidden = true
                simulateButton.isHidden = true
                resetButton.isHidden = false
                gameContainer.isUserInteractionEnabled = false
                
            case .completingGame:
                completeButton.isHidden = true
                simulateButton.isHidden = true
                resetButton.isHidden = true
                gameContainer.isUserInteractionEnabled = false
                gameContainer.isHidden = false
                simulationContainerView.isHidden = true
                
            case .simulating:
                countLabel.text = "0"
                completeButton.isHidden = true
                simulateButton.isHidden = true
                resetButton.isHidden = true
                gameContainer.isUserInteractionEnabled = false
                gameContainer.isHidden = true
                simulationContainerView.isHidden = false
            }
        }
    }

    // MARK: Initialization
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: UIViewController
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        gradientView.gradient = .clouds
        waterView.gradient = .water

        gameContainer.allowsTransparency = true
        gameContainer.isUserInteractionEnabled = true
        gameContainer.preferredFramesPerSecond = 60
        
        present(createGameAI?())
        
        NSLayoutConstraint.activate([
            infoView.topAnchor.constraint(equalTo: liveViewSafeAreaGuide.topAnchor),
            gameContainer.bottomAnchor.constraint(equalTo: liveViewSafeAreaGuide.bottomAnchor)
        ])
    }
    
    public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if let controller = segue.destination as? SimulateViewController {
            simulateViewController = controller
            simulateViewController?.delegate = self
        }
    }
    
    // MARK: Convenience
    
    /// Presents a new game using an optional `GameAI` to suggest targets.
    func present(_ gameAI: GameAI?) {
        let game = Game(coordinateSize: 10, gameAI: gameAI, shootDelay: 0.2)
        presentedGame = (game, gameAI)

        game.delegate = self
        game.grid.scaleMode = .resizeFill
        gameAI?.game = game
        gameContainer.presentScene(game.grid)
        
        _ = game.markNextSuggestedTarget()
        
        state = .playingGame(gameAI)
    }

    @IBAction func completeButtonTapped(_ sender: AnyObject) {
        state = .completingGame
        presentedGame?.game.complete()
    }
    
    @IBAction func simulateButtonTapped(_ sender: AnyObject) {
        guard let simulateViewController = simulateViewController else { fatalError("SimulateViewController hasn't been embedded") }
        guard let createGameAI = createGameAI else { fatalError("No createGameAI callback has been set") }
        
        simulateViewController.simulate(100, createGameAI: createGameAI)
        state = .simulating
    }
    
    @IBAction func resetButtonTapped(_ sender: AnyObject) {
        let gameAI = createGameAI?()
        present(gameAI)
    }
    
    @IBAction func unwindToGameViewController(segue: UIStoryboardSegue) {}
}

extension GameViewController: GameDelegate {
    func gameDidTakeTurn(_ game: Game) {
        countLabel.text = "\(game.turnCount)"
    }
    
    func gameDidComplete(_ game: Game) {
        state = .completed
    }
}

extension GameViewController: SimulateViewControllerDelegate {
    func simulateViewController(_ controller: SimulateViewController, didCompleteSimulation results: [Int]) {
        state = .completed
        
        guard let assessment = assessment else { return }
        
        let totalTurnCount = results.reduce(0, +)
        let averageTurnCount = Int(Double(totalTurnCount) / Double(results.count))

        if averageTurnCount <= assessment.averageTurnCount {
            PlaygroundPage.current.assessmentStatus = .pass(message: assessment.passMessage)
        }
    }
}

public extension GameViewController {
    public class func instantiateFromStoryboard() -> GameViewController {
        let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let viewController = storyBoard.instantiateInitialViewController() as! GameViewController
        
        return viewController
    }
}
