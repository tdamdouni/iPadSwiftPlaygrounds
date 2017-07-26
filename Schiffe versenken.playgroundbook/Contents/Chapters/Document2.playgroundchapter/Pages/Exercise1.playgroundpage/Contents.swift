//#-hidden-code
//
//  Contents.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//
//#-end-hidden-code
/*:#localized(key: "FirstProseBlock")
 At the bottom of this page is an example algorithm that distributes its random guesses based on the smallest possible ship sizes (the first method on the previous page). It works in two ways.
 
 **Guess mode (when no ship is found)**
 1. Keep track of the smallest ship, which takes up two tiles.
 2. Fire at every other tile across the ship, targeting only spaces where the ship could fit.
 3. If you sink the ship, modify your algorithm to target areas where the next smallest ship (three tiles) can fit.
 4. Fire at every third tile, targeting only spaces where the ship could be.
 
 **Target mode (when a ship is found)**
 1. Fire at the tiles around where the ship was hit.
 2. After all of the nearby tiles are targeted and the ship and any neighboring ships are destroyed, return to guess mode.
 
 Keep in mind that this is just one option for writing an algorithm for Battleship; many other options exist. Explore and try to improve your algorithm so you can win in even fewer turns!
 */
//#-hidden-code
//#-code-completion(everything, hide)
//#-code-completion(identifier, show, game, grid, return )
//#-code-completion(currentmodule, show)
//#-code-completion(bookauxiliarymodule, show)
//#-code-completion(identifier, show, if, func, var, let, ., =, <=, >=, <, >, ==, !=, +, -, true, false, &&, ||, !, *, /, while, for, (, ), ())
import PlaygroundSupport

class MyAI: GameAI {
    weak var game: Game!
    
    var grid: Grid {
        return game.grid
    }
    
    init() {}
    
//#-end-hidden-code
//#-editable-code
// A coordinate that represents the origin of a targeted search.
var tileToFollowFrom = Tile()

// The directions to search for a ship from coordinateToFollowFrom.
var directionsToFollow = [Direction]()

func firstCoordinate() -> Coordinate {
    return Coordinate(column: 0, row: 0)
}

func nextCoordinate(previousTile: Tile) -> Coordinate {

    // Check if we're following in a direction from a hit tile.
    if directionsToFollow.isEmpty {
        // We're not following in any direction; if the previous target wasn't a hit, return a random coordinate.
        if previousTile.state != .hit {
            return nextGuessCoordinate(previousTile: previousTile)
        }
        
        // Start following the neighbors of the hit tile in all directions.
        tileToFollowFrom = previousTile
        directionsToFollow = Direction.all
    }
    
    // Determine which neighboring tile to target next.
    var tileToCheck = previousTile
    while !directionsToFollow.isEmpty {
        // If the previous target was a hit, try to target the next tile in the direction we're following.
        if tileToCheck.state == .hit {
            let directionToFollow = directionsToFollow[0]
            let neighborCoordinate = tileToCheck.coordinate.advanced(by: 1, inDirection: directionToFollow)
            let neighborTile = grid.tileAt(neighborCoordinate)
            
            // If the tile hasn't been targeted previously, target it next.
            if neighborTile.state == .unexplored {
                return neighborCoordinate
            }
        }
        
        // The tiles in the current direction have been exhausted; remove that direction from the array, and move on to the next one.
        directionsToFollow.removeFirst()
        tileToCheck = tileToFollowFrom
    }
    
    // No target was found in any direction; return a random coordinate.
    return nextGuessCoordinate(previousTile: previousTile)
}

// This function is called when the previous targeted tile wasn't a hit.
func nextGuessCoordinate(previousTile: Tile) -> Coordinate {
    // Determine the shortest ship that is still afloat.
    let smallestUnsunkShip = getSmallestUnsunkShip()
    
    // Loop through all rows, starting at the row of the previous tile.
    for row in previousTile.coordinate.row ..< grid.rowCount {
        // Determine which column to start checking from.
        var column: Int
        if row == previousTile.coordinate.row {
            // This is the same row as the previous tile; start after the previous tile's column.
            column = previousTile.coordinate.column + smallestUnsunkShip.length
        } else {
            column = startingColumnForRow(row: row)
        }
        
        // Loop through the coordinates for each column in the current row.
        while column < grid.columnCount {
            // Get the coordinate and its tile.
            let coordinate = Coordinate(column: column, row: row)
            let tile = grid.tileAt(coordinate)
            
            if tile.state == .unexplored {
                // Check all directions to see if there's space for the shortest unsunk ship.
                for direction in Direction.all {
                    // If there's room for the shortest unsunk ship, return the coordinate.
                    let tileCount = possibleHitCountFrom(coordinate: coordinate, inDirection: direction)
                    if tileCount >= smallestUnsunkShip.length {
                        return coordinate
                    }
                }
                
                // Skip the length of the shortest unsunk ship before checking again.
                column += smallestUnsunkShip.length
            } else {
                // Move on to the next column.
                column += 1
            }
            
        }
    }
    
    // The last column was reached; return the first unexplored tile in the grid.
    for tile in grid.allTiles {
        if tile.state == .unexplored {
            return tile.coordinate
        }
    }
    
    // We should never reach this point, so return an invalid tile.
    return Coordinate.invalid
}

// Checks each class of ship against the array of sunk ships to determine the shortest type of ship that hasn't been sunk.
func getSmallestUnsunkShip() -> ShipClassification {
    // Loop through all classes of ship.
    for shipClass in ShipClassification.all {
        // Check for a sunk ship that matches the current ship class.
        var shipClassIsSunk = false
        for sunkShip in game.sunkShips {
            if sunkShip.classification == shipClass {
                shipClassIsSunk = true
            }
        }
        
        // If there isn't a sunken ship of this class, return the class.
        if !shipClassIsSunk {
            return shipClass
        }
    }
    
    // Return the first class of ship.
    return ShipClassification.all[0]
}

// Returns the number of neighboring tiles in a given direction that are or could possibly be hits.
func possibleHitCountFrom(coordinate: Coordinate, inDirection direction: Direction) -> Int {
    var coordinateToCheck = coordinate
    var count = 0
    
    while true {
        let tile = grid.tileAt(coordinateToCheck)
        if tile.state != .unexplored && tile.state != .hit {
            break
        }
        
        count += 1
        coordinateToCheck = coordinateToCheck.neighbor(inDirection: direction)
    }
    
    return count
}

func startingColumnForRow(row: Int) -> Int {
    if row.isEven {
        return 0
    } else {
        return 1
    }
}
//#-end-editable-code
//#-hidden-code
}

let viewController = GameViewController.instantiateFromStoryboard()
viewController.createGameAI = {
    return MyAI()
}

PlaygroundPage.current.liveView = viewController
//#-end-hidden-code
