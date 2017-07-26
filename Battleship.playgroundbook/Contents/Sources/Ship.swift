//
//  Ship.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//

import Foundation

///Represents a single ship.
public class Ship {
    // MARK: Properties
    
    public let classification: ShipClassification
    
    public internal(set) var damage = 0
    
    public var isSunk: Bool {
        return damage == classification.length
    }
    
    // MARK: Initialization
    
    init(ofClassification classification: ShipClassification) {
        self.classification = classification
    }
}

public enum ShipClassification {
    case destroyer, submarine, cruiser, battleship, aircraftCarrier
    
    public var length: Int {
        switch self {
        case .destroyer:
            return 2
            
        case .submarine:
            return 3
            
        case .cruiser:
            return 3
            
        case .battleship:
            return 4
            
        case .aircraftCarrier:
            return 5
        }
    }
    
    public static let all: [ShipClassification] = [.destroyer, .submarine, .cruiser, .battleship, .aircraftCarrier]
}
