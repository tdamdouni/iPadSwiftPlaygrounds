//
//  Game+ShipPlacement.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//

import Foundation

extension Game {
    // MARK: Methods for placing ships
    
    internal func placeShips() -> [Ship] {
        let ships: [Ship] = ShipClassification.all.map { classification in
            let ship = Ship(ofClassification: classification)
            placeShip(ship)
            return ship
        }
        
        return ships
    }
    
    ///Handles the random placement of ships.
    private func placeShip(_ ship: Ship) {
        let orientation = Orientation.random()
        var start: Coordinate
        var end: Coordinate
        
        switch orientation {
        case .horizontal:
            // Picks a random coordinate and checks if ships fits at the coordinate.
            repeat {
                start = Coordinate(column: Int(arc4random() % UInt32(grid.columnCount)), row: Int(arc4random() % UInt32(grid.rowCount)))
                end = Coordinate(column: start.column + (ship.classification.length - 1), row: start.row)
            } while !isShipPlaceable(from: start, to: end)
            
            // Places the ship on the grid.
            for column in start.column...end.column {
                grid.tileAt(row: start.row, column: column).ship = ship
            }
            
        case .vertical:
            // Picks a random coordinate and checks if ships fits at the coordinate.
            repeat {
                start = Coordinate(column: Int(arc4random() % UInt32(grid.columnCount)), row: Int(arc4random() % UInt32(grid.rowCount)))
                end = Coordinate(column: start.column, row: start.row + (ship.classification.length - 1))
            } while !isShipPlaceable(from: start, to: end)
            
            // Places the ship on the grid.
            for row in start.row...end.row {
                grid.tileAt(row: row, column: start.column).ship = ship
            }
        }
    }
    
    /// Checks tiles between starts and ends to ensure no overlap.
    private func isShipPlaceable(from: Coordinate, to: Coordinate) -> Bool {
        switch Orientation(from: from, to: to) {
        case .horizontal:
            for column in min(from.column, to.column)...max(from.column, to.column) {
                let coordinate = Coordinate(column: column, row: from.row)
                if !grid.coordinateIsValid(coordinate) || isShipAt(coordinate) {
                    return false
                }
            }
            
        case .vertical:
            for row in min(from.row, to.row)...max(from.row, to.row) {
                let coordinate = Coordinate(column: from.column, row: row)
                if !grid.coordinateIsValid(coordinate) || isShipAt(coordinate) {
                    return false
                }
            }
        }
        
        return true
    }
    
    /// Returns true if the coordinate contains a ship.
    private func isShipAt(_ coordinate: Coordinate) -> Bool {
        return grid.tileAt(coordinate).ship != nil
    }
}
