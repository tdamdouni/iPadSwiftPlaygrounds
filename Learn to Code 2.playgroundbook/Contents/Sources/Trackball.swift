// 
//  Trackball.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
import SceneKit
import UIKit

// A 3D scene behind glass is manipulated by moving your finger around on the glass.
// This is kind of like a trackball.
// The center of the world is relative to the glass. So if the glass is 'in front' of the world specify the center as 'inside' the glass by the depth desired.
// The screen is x positive to the right, y positive down, z positive into the screen
// So a center that's 10 into the glass in the center of the glass is (0,0,10).
//
// When the users finger goes down we make a vector from the point you touched on the glass to the center of the scene.
// When the users finger moves we make a new vector from the new location to the center of the scene.
// We use the cross product to find the perpendicular vector to the plane formed by these two vectors.
//
// We don't want gymbal lock so rather than the arccos of (||A.B|| / ||A|| * ||B||)
// We use atan2
// cos(a) = (A . B) / (||A|| * ||B||)
// sin(a) = (||A X B||) / (||A|| * ||B||)
// a = atan2(sin(a), cos(a))

struct Trackball {
    var startingPoint: CGPoint = CGPoint(x: 0.0, y: 0.0) { // where the finger went down
        didSet {
            let translatedLocation = startingPoint - CGPoint(x: viewSize.width / 2.0, y: viewSize.height / 2.0)
            let startingLocation = SCNVector3(x: Float(translatedLocation.x) * scaleFactor, y: Float(translatedLocation.y) * scaleFactor, z: radius)
            startingVector = startingLocation - center
        }
    }
    var startingVector: SCNVector3 = SCNVector3(x: 0.0, y: 0.0, z: 0.0)
    var transform: SCNMatrix4
    var center: SCNVector3 // the center of the trackball
    var radius: Float // the radius of the trackball, the center plus this specifies the sphere
    var viewSize: CGSize // the size of the view the 3d space is in, radius is scaled to match min(width, height)
    var scaleFactor: Float // the scale from radius to min(width, height)
    var multiplier: Float = 1.0

    init(center: SCNVector3, radius: Float, multiplier: Float, inRect bounds: CGRect, transform: SCNMatrix4) {
        viewSize = bounds.size
        self.center = center
        self.radius = radius
        self.multiplier = multiplier
        scaleFactor = radius / min(Float(viewSize.width), Float(viewSize.height))
        self.transform = transform
    }
    
    mutating func finish(_ location: CGPoint) {
        transform = transformFor(location)
    }
    
    // call this during touchesMoved to get the latest rotation vector
    func transformFor(_ location: CGPoint) -> SCNMatrix4 {
        // translate location into the center
        let translatedLocation = location - CGPoint(x: viewSize.width / 2.0, y: viewSize.height / 2.0)
        let currentLocation = SCNVector3(x: Float(translatedLocation.x) * scaleFactor, y: Float(translatedLocation.y) * scaleFactor, z: radius)
        let currentVector = currentLocation - center
        let currentLength = currentVector.length()
        let startingLength = startingVector.length()
        
        let cross = currentVector.cross(startingVector)
        let crossLength = cross.length()
        
        if fabs(crossLength) < 0.00001 {
            // if the cross product is zero lenght the two vectors are parallel
            return transform
        }
        let crossNormalized = cross.normalize()
        
        // cos(a) = (A . B) / (||A|| * ||B||)
        // sin(a) = (||A X B||) / (||A|| * ||B||)
        // a = atan2(sin(a), cos(a))
        
        let cosine = (startingVector.dot(currentVector)) / (startingLength * currentLength)
        let sine = crossLength / (startingLength * currentLength)
        let angle = atan2(sine, cosine)

        // scale the angle to match the y component
        let scaledYAngle = multiplier * angle * crossNormalized.y
        let yRot = SCNMatrix4MakeRotation(scaledYAngle, 0.0, 1.0, 0.0)
        
        return SCNMatrix4Mult(transform, yRot)
    }
}
