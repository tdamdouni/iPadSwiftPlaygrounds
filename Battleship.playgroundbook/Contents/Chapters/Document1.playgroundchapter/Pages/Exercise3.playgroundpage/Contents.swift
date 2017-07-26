//#-hidden-code
//
//  Contents.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
//#-end-hidden-code
/*:
 **Goal:** Minimize the number of turns needed for your algorithm to win.
 
 You can further improve your algorithm by making better guesses at finding undiscovered ships. There are a few ways to do this.
 
 **Consider ship size**
 1. Keep track of the smallest ship, which takes up two tiles.
 2. Fire at every other tile across the grid, targeting only spaces where the ship could fit.
 3. If you sink the ship, modify your algorithm to target areas where the next smallest ship (three tiles) can fit.
 4. Fire at every third tile, targeting only spaces where the ship could be.
 
 **Determine probability of a ship existing at a tile**
 1. Calculate the number of remaining ships that can be placed on each tile and their possible orientations (horizontal or vertical). The sum of the number of ships and their possible orientations is the score for a tile. When the game starts, every tile has a score of 10, because all 5 ships can fit vertically or horizontally on it.
 2. Fire at the tile with the highest score.
 3. For each turn, recalculate each tile's score and repeat until you hit a ship.
 
 Try using one of these methods, or experiment on your own to see what else works better. Simulate your algorithm and see how much you can improve it!
 */

//#-hidden-code
//#-code-completion(everything, hide)
//#-code-completion(identifier, show, game, grid, return)
//#-code-completion(module, show, Swift)
//#-code-completion(currentmodule, show)
//#-code-completion(bookauxiliarymodule, show)
//#-code-completion(identifier, show, if, func, var, let, ., =, <=, >=, <, >, ==, !=, +, -, true, false, &&, ||, !, *, /)

import PlaygroundSupport

class MyAI: GameAI {
    weak var game: Game!
    
    var grid: Grid {
        return game.grid
    }
    
    init() {}
    
//#-end-hidden-code
//#-editable-code
//#-copy-destination("Sinking a Ship", id1)
// A coordinate that represents the origin of a targeted search.
var tileToFollowFrom = Tile()

// The directions to follow to search for a ship.
var directionsToFollow = [Direction]()

func firstCoordinate() -> Coordinate {
    return grid.randomCoordinate()
}

func nextCoordinate(previousTile: Tile) -> Coordinate {
    // Check if we're following in a direction from a hit tile.
    if directionsToFollow.isEmpty {
        // We're not following in any direction; if the previous target wasn't a hit, return a random coordinate.
        if previousTile.state != .hit {
            return grid.randomCoordinate()
        }
        
        // Start following the neighbors of the hit tile in all directions.
        tileToFollowFrom = previousTile
        directionsToFollow = [.north, .south, .east, .west]
    }
    
    // Determine which neighboring tile we should target next.
    var tileToCheck = previousTile
    while !directionsToFollow.isEmpty {
        // Get the current direction we're following.
        let directionToFollow = directionsToFollow[0]
        
        // If the previous target was a hit, try to target the next tile in the same direction.
        if tileToCheck.state == .hit {
            let neighborCoordinate = tileToCheck.coordinate.advanced(by: 1, inDirection: directionToFollow)
            let neighborTile = grid.tileAt(neighborCoordinate)
            
            // If the tile hasn't been targeted previously, target it next.
            if neighborTile.state == .unexplored {
                return neighborCoordinate
            }
        }
        
        // We've exhausted the tiles in the current direction; remove it from the array and move on to the next direction.
        directionsToFollow.removeFirst()
        tileToCheck = tileToFollowFrom
    }
    
    // No target was found in any direction; return a random coordinate.
    return grid.randomCoordinate()
}
//#-end-copy-destination
//#-end-editable-code
//#-hidden-code
}

let viewController = GameViewController.instantiateFromStoryboard()
viewController.createGameAI = {
    return MyAI()
}

PlaygroundPage.current.liveView = viewController
//#-end-hidden-code
