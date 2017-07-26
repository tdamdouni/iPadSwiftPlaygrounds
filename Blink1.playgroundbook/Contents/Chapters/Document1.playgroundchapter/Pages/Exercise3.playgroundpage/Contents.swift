//#-hidden-code
//
//  Contents.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
//#-end-hidden-code
/*:
 In the previous page, a cell with 4 neighbors would die regardless if those neighbors were alive or dead. In this new version, the algorithm checks the number of neighbors in each state (alive, dead, or idle) to determine what happens. Under certain conditions, the algorithm also changes cells to the idle state, resulting in some interesting patterns.
 
 Play with the rules in the algorithm to see what kinds of complex simulations you can create.
 */
//#-hidden-code
//#-code-completion(everything, hide)
//#-code-completion(currentmodule, show)
//#-code-completion(module, show, Swift)
//#-code-completion(module, show, Blink_Sources)
//#-code-completion(identifier, show, if, func, var, let, ., =, <=, >=, <, >, ==, !=, +, -, true, false, &&, ||, !, *, /)
//#-code-completion(identifier, hide, configureCell(cell:), BlinkViewController, viewController, Coordinate, InitialStatePreset, Simulation, Cell, storyBoard)

import UIKit
import PlaygroundSupport

let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
let viewController = storyBoard.instantiateInitialViewController() as! BlinkViewController

PlaygroundPage.current.liveView = viewController
//#-end-hidden-code
let simulation = Simulation()
//#-editable-code
simulation.cellDimension = 32

simulation.placePattern(Pattern.pulsar, atColumn: 1, row: 1)

simulation.speed = 2

simulation.set("🌹", forState: .alive)
simulation.set(#colorLiteral(red: 0.6352941176, green: 0.8470588235, blue: 0.7176470588, alpha: 1), forState: .alive)
simulation.set(#imageLiteral(resourceName:"plant.png"), forState: .dead)
simulation.set(#colorLiteral(red: 0.6352941176, green: 0.8470588235, blue: 0.7176470588, alpha: 1), forState: .dead)
simulation.set(#colorLiteral(red: 0.2352941176, green: 0.7215686275, blue: 0.4705882353, alpha: 1), forState: .idle)

simulation.gridLineThickness = 4
simulation.gridColor = #colorLiteral(red: 0.6352941176, green: 0.8470588235, blue: 0.7176470588, alpha: 1)

//#-end-editable-code
func configureCell(cell: Cell) {
    //#-editable-code
    switch cell.state {

    case .alive:
        if cell.numberOfAliveNeighbors > 6 {
            cell.state = .idle
        }
        else if cell.numberOfAliveNeighbors < 2 && cell.numberOfIdleNeighbors > 5 {
            cell.state = .dead
        }
    case .dead:
        if cell.numberOfAliveNeighbors == 3 {
            cell.state = .alive
        }
        else if cell.numberOfIdleNeighbors > 5 {
            cell.state = .idle
        }
    case .idle:
        // Try changing this value to == 1 and see what happens.
        if cell.numberOfIdleNeighbors > 7 {
            cell.state = .alive
        }
        else if cell.numberOfAliveNeighbors > 3 {
            cell.state = .dead
        }
        else if cell.numberOfDeadNeighbors > 3 {
            cell.state = .dead
        }
    }
    //#-end-editable-code
}
//#-hidden-code
simulation.configureCell = configureCell

viewController.simulation = simulation
//#-end-hidden-code
