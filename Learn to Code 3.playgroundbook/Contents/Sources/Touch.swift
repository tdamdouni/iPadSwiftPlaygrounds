// 
//  Touch.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//

import UIKit

/// A touch event for when your finger is moving across the scene.
public struct Touch {
    
    /// The position of this touch on the scene.
    public var position: Point
    
    /// The distance this touch is from the previous object that was placed on the scene.
    public var previousPlaceDistance: Double

    /// The number of graphics that were placed on the scene during this touch event.
    public var numberOfObjectsPlaced: Int
    
    
    var touchedGraphic: Graphic?
    
    public static func ==(lhs: Touch, rhs: Touch) -> Bool {
        return lhs.position == rhs.position &&
                lhs.previousPlaceDistance == rhs.previousPlaceDistance &&
                lhs.numberOfObjectsPlaced == rhs.numberOfObjectsPlaced
    }

}
 
