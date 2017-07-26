//#-hidden-code
//
//  Contents.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//
//#-end-hidden-code
/*:#localized(key: "FirstProseBlock")
 **Goal:** Write an algorithm to win the game in fewer than 75 turns, on average.
 
 In this exercise, you’ll write code that gives the next coordinate to fire at. As you play the game, your next target appears on the grid, to help you understand and debug your algorithm. Tap the grid to fire and step through the game.
 
 The current algorithm fires at random coordinates. When it hits a ship, it fires to the right of that tile until it misses or is at the edge of the grid, and then it goes back to firing randomly. To see how it performs, run the code and then tap Play 1x to watch it play a game. You’ll notice that this is *not* a good strategy for winning a battle!
 
 One way to improve the algorithm is to focus on sinking a ship after it's discovered:
 1. When you hit a ship, target the neighboring tiles.
 2. Keep firing at nearby tiles until you sink the ship and any neighboring ships; then go back to random firing.
 
 You can tap Play 100x to have your algorithm simulate playing 100 games and determine the average number of turns needed to win the game.
 
 Using targeting mode, it's possible to win in under 75 turns when you play 100 games. How fast can *your* algorithm win?
 */
//#-hidden-code
//#-code-completion(everything, hide)
//#-code-completion(identifier, show, game, grid, return)
//#-code-completion(currentmodule, show)
//#-code-completion(bookauxiliarymodule, show)
//#-code-completion(identifier, show, if, func, var, let, ., =, <=, >=, <, >, ==, !=, +, -, true, false, &&, ||, !, *, /, while, for, (, ), ())

import PlaygroundSupport
import UIKit

class MyAI: GameAI {
    weak var game: Game!
    
    var grid: Grid {
        return game.grid
    }
    
    init() {}

//#-end-hidden-code
//#-copy-source(id1)
//#-editable-code
// This function is called to determine the first coordinate to fire at.
func firstCoordinate() -> Coordinate {
    return grid.randomCoordinate()
}

// This function returns the coordinate to fire at for each turn after the first.
func nextCoordinate(previousTile: Tile) -> Coordinate {
    
    // Was the previous guess a hit?
    if previousTile.state == .hit {
        // Write code here to target the neighboring tiles to sink this ship.
        let neighborCoordinate = previousTile.coordinate.advanced(by: 1, inDirection: .east)
        let neighborTile = grid.tileAt(neighborCoordinate)
     
        // Only fire at an unexplored coordinate.
        if neighborTile.state == .unexplored {
            return neighborCoordinate
        }
    }
    
    return grid.randomCoordinate()
}
//#-end-editable-code
//#-end-copy-source
//#-hidden-code
}

let viewController = GameViewController.instantiateFromStoryboard()

viewController.createGameAI = {
    return MyAI()
}

viewController.assessment = (averageTurnCount: 75, passMessage: NSLocalizedString("Well done! You've made great improvements to your algorithm! When you're ready, move on to the next page to improve how you locate ships.", comment: "Success message"))

PlaygroundPage.current.liveView = viewController

//#-end-hidden-code
