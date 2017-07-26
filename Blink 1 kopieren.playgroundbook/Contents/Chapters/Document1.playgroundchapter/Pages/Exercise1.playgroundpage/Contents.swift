//#-hidden-code
//
//  Contents.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//
//#-end-hidden-code
/*:#localized(key: "FirstProseBlock")
 # Blink: A Cell Simulator
 Blink is a simulation that explores how a living cell reproduces or dies given a certain set of rules. Your goal is to understand the algorithms that run the simulation so that you can create your own version, with your own rules.
 
 This playground is running a modified version of Conway's Game of Life, which presents cells reproducing and dying based upon the status of the 8 neighboring cells. You will see this simulation in the **live view** when you run the code.
 
 The rules for this simulation are:
 * Any living cell with fewer than two living neighbors dies.
 * Any living cell with two or three living neighbors lives on.
 * Any living cell with more than three living neighbors dies.
 * Any dead cell with exactly three living neighbors becomes a living cell.
 
 The cell simulator uses a loop to evaluate all cells on the grid. For each iteration of the loop, the rules are applied and a new generation of cells is created. Experiment with stepping through the simulation to watch this happen. On the next page, you'll explore modifying this algorithm.
 */ 
//#-hidden-code
import UIKit
import PlaygroundSupport

let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
let viewController = storyBoard.instantiateInitialViewController() as! BlinkViewController

PlaygroundPage.current.liveView = viewController

let simulation = Simulation()
simulation.cellDimension = 32

simulation.placePattern(.capitalL, atColumn: 5, row: 6)

let aliveColor = #colorLiteral(red: 0.9882352941, green: 1, blue: 0, alpha: 1)
let otherColor = #colorLiteral(red: 0.3254901961, green: 0.737254902, blue: 0.8274509804, alpha: 1)
simulation.set(aliveColor, forState: .alive)
simulation.set(otherColor, forState: .dead)
simulation.set(otherColor, forState: .idle)
simulation.gridLineThickness = 4
simulation.gridColor = #colorLiteral(red: 0.7960784314, green: 0.7647058824, blue: 0.8039215686, alpha: 1)

simulation.speed = 1

func configureCell(cell: Cell) {
    switch cell.state {
    case .alive:
        if cell.numberOfAliveNeighbors < 2 {
            cell.state = .dead
        }
        else if cell.numberOfAliveNeighbors > 3 {
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

simulation.configureCell = configureCell

viewController.simulation = simulation
//#-end-hidden-code
