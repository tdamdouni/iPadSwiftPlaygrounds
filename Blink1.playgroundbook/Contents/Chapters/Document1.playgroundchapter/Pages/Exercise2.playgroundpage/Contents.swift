//#-hidden-code
//
//  Contents.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
//#-end-hidden-code
/*:
 **Goal:** Modify the code below to create your own set of rules for the cell simulator.

 To get started, run the code and observe what happens when you tap the live view to add living cells. The live view is initially filled with idle cells, but as the simulation runs these change to living or dead cells depending on the rules.
 
 Try modifying the rules of the simulation in the configureCell function. Experiment with different values to see what happens.
 
 When you're ready, move on to the next page to explore a more complex set of rules for the cell simulator.
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

// Try changing glider to pulsar.
simulation.placePattern(Pattern.glider, atColumn: 3, row: 3)

// Try adjusting the speed to a number from 1 to 60.
simulation.speed = 2

// Personalize your cells with your own images, text, or emojis.
simulation.set("😀", forState: .alive)
simulation.set(#colorLiteral(red: 0.4784313725, green: 0.7647058824, blue: 0.7568627451, alpha: 1), forState: .alive)
simulation.set("👻", forState: .dead)
simulation.set(#colorLiteral(red: 0.4784313725, green: 0.7647058824, blue: 0.7568627451, alpha: 1), forState: .dead)
simulation.set(#colorLiteral(red: 0.4784313725, green: 0.7647058824, blue: 0.7568627451, alpha: 1), forState: .idle)

//#-end-editable-code
func configureCell(cell: Cell) {
    //#-editable-code
    switch cell.state {
    // Create rules for when your cells live or die.
    case .alive:
        if cell.numberOfAliveNeighbors < 2 {
            cell.state = .dead
        }
        else if cell.numberOfAliveNeighbors > 3 {
            cell.state = .dead
        }
    case .dead:
        // Try changing this value to >= 3 and see what happens.
        if cell.numberOfAliveNeighbors == 3 {
            cell.state = .alive
        }
    case .idle:
        if cell.numberOfAliveNeighbors == 3 {
            cell.state = .alive
        }
    }
    //#-end-editable-code
}
//#-hidden-code
simulation.configureCell = configureCell

viewController.simulation = simulation
//#-end-hidden-code
