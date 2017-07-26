// 
//  BlinkViewController.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//

import UIKit
import SpriteKit
import PlaygroundSupport

@objc(BlinkViewController)
public class BlinkViewController: UIViewController, PlaygroundLiveViewSafeAreaContainer {
    
    let scene = BlinkScene()
    
    enum ButtonTitles {
        static let resumeSimulation = NSLocalizedString("Resume Simulation", comment:"Make the simulation become active again")
        static let pauseSimulation = NSLocalizedString("Pause Simulation", comment:"Make the simulation become inactive")
        static let step = NSLocalizedString("Step", comment: "Perform one iteration or 'step' in the simulation")
        static let reset = NSLocalizedString("Reset", comment: "Reset the simulation to the initial state")
    }
    
    @IBOutlet weak var skView: SKView!
    
    @IBOutlet weak var stepButton: UIButton!
    
    @IBOutlet weak var playPauseButton: UIButton!
    
    @IBOutlet weak var resetButton: UIButton!
    
    @IBOutlet weak var playPauseWidthConstraint: NSLayoutConstraint!
    
    public var simulation: Simulation? {
        get {
            return scene.simulation
        }
        set(newValue) {
            scene.simulation = newValue
            if let simulation = simulation, simulation.isPaused {
                pauseSimulation()
            }
            else {
                resumeSimulation()
            }
        }
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        scene.backgroundColor = SKColor.clear
        scene.scaleMode = .resizeFill
        
        skView.preferredFramesPerSecond = 60
        skView.presentScene(scene)
        
        stepButton.setTitle(ButtonTitles.step, for: [])
        resetButton.setTitle(ButtonTitles.reset, for: [])
        playPauseButton.setTitle(ButtonTitles.pauseSimulation, for: [])

        
        NSLayoutConstraint.activate([
            resetButton.topAnchor.constraint(equalTo: liveViewSafeAreaGuide.topAnchor, constant: 15.0),
            playPauseButton.topAnchor.constraint(equalTo: liveViewSafeAreaGuide.topAnchor, constant: 15.0),
            stepButton.topAnchor.constraint(equalTo: liveViewSafeAreaGuide.topAnchor, constant: 15.0),
        ])
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // For testing as an iPad app.
        #if DEBUG
            simulation = makeSimulation()
        #endif
    }
    
    @IBAction func stepTapped(_ sender: AnyObject) {
        pauseSimulation()
        scene.updateSimulationCycle()
    }
    
    @IBAction func playPauseTapped(_ sender: AnyObject) {
        if let simulation = simulation, simulation.isPaused {
            resumeSimulation()
        }
        else {
            pauseSimulation()
        }
    }
    
    func resumeSimulation() {
        if let simulation = simulation {
            simulation.isPaused = false
        }
        playPauseButton.setTitle(ButtonTitles.pauseSimulation, for: [])
    }
    
    func pauseSimulation() {
        if let simulation = simulation {
            simulation.isPaused = true
        }
        playPauseButton.setTitle(ButtonTitles.resumeSimulation, for: [])
    }
    
    @IBAction func resetTapped(_ sender: AnyObject) {
        scene.resetToInitialState()
    }
    
    // MARK: User Code Simulation
    
    // This is simulating the user code that is in the playground page for testing.
    func makeSimulation() -> Simulation {
        
        let simulation = Simulation()
        simulation.cellDimension = 36
        simulation.placePattern(.pulsar, atColumn: 3, row: 3)
        simulation.speed = 2
        
        simulation.set("😀", forState: .alive)
        simulation.set("👻", forState: .dead)
        simulation.set(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), forState: .idle)
        
        simulation.configureCell = configureCell
        
        return simulation
    }
    
    func configureCell(_ cell: Cell) {
        
        switch cell.state {
        case .alive:
            if cell.numberOfAliveNeighbors < 2 {
                cell.state = .dead
            } else if cell.numberOfAliveNeighbors > 3 {
                cell.state = .dead
            }
        case .dead:
            if cell.numberOfAliveNeighbors == 3 {
                cell.state = .alive
            }
        case .idle:
            if cell.numberOfAliveNeighbors == 3 {
                cell.state = .alive
            }
        }
    }
    // End User Code Simulation
}


