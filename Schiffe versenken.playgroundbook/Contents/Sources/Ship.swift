//
//  Ship.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//

import Foundation

/// Represents a single ship.
public class Ship {
    // MARK: Properties
    
    /// The ship's type (patrol boat, submarine, destroyer, battleship, or aircraft carrier).
    public let classification: ShipClassification
    
    /// The amount of times the ship has been hit. A ship is considered sunk when the amount of damage equals its length.
    public internal(set) var damage = 0
    
    /// Returns ``true`` is the ship is sunk.
    public var isSunk: Bool {
        return damage == classification.length
    }
    
    // MARK: Initialization
    
    init(ofClassification classification: ShipClassification) {
        self.classification = classification
    }
}

/// Represents a type of ship (patrol boat, submarine, destroyer, battleship, or aircraft carrier).
public enum ShipClassification {
    /// A two tile long ship
    case patrolBoat
    /// A three tile long ship
    case submarine
    /// A three tile long ship
    case destroyer
    /// A four tile long ship
    case battleship
    /// A five tile long ship
    case aircraftCarrier
    
    /// The length in titles of the ship.
    public var length: Int {
        switch self {
        case .patrolBoat:
            return 2
            
        case .submarine:
            return 3
            
        case .destroyer:
            return 3
            
        case .battleship:
            return 4
            
        case .aircraftCarrier:
            return 5
        }
    }
    
    /// All the ships types in the game.
    public static let all: [ShipClassification] = [.patrolBoat, .submarine, .destroyer, .battleship, .aircraftCarrier]
}
