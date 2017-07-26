
// https://gist.github.com/ThereIsOnlyZuul/ccf07dd39f75eaccb337a3388b7a526b
//  Alignable.swift
//  
//
//  Created by Derek Klinge on 8/4/16.
//
//

/*
 
 This API is designed to work with Apple's Shapes API provided
 in the Shapes playground (Swift Playgrounds for iOS)
 
 Alignable is a protocol to allow objects to align their edges
 
 A free function is provided to allow objects to align themselves
 with other Alignable objects
 The default version centers the object alignment, this can
 be changed by setting the parameter centered to false
 
 Default implementation is provided for AbstractDrawable objects
 
 */

public protocol Alignable {
    var center: Point { get set }
    var topEdge: Double { get set }
    var bottomEdge: Double { get set }
    var leftEdge: Double { get set }
    var rightEdge: Double { get set }
}

public enum Edge: Int {
    case top, right, bottom, left
}

public extension Alignable {
    public mutating func align(on edge: Edge, of object : Alignable, centered: Bool = true) {
        if centered { self.center = object.center }
        switch edge {
        case .top:
            self.bottomEdge = object.topEdge
        case .bottom:
            self.topEdge = object.bottomEdge
        case .left:
            self.rightEdge = object.leftEdge
        case .right:
            self.leftEdge = object.rightEdge
        }
    }
}

extension AbstractDrawable: Alignable {
    public var topEdge: Double {
        get { return self.center.y + Double(self.backingView.bounds.size.height) / 2 / Canvas.shared.numPointsPerUnit }
        set { self.center = Point(x: self.center.x,y: newValue - Double(self.backingView.bounds.height) / 2 / Canvas.shared.numPointsPerUnit) }
    }
    public var bottomEdge: Double {
        get { return self.center.y - Double(self.backingView.bounds.size.height) / 2 / Canvas.shared.numPointsPerUnit }
        set { self.center = Point(x: self.center.x,y: newValue + Double(self.backingView.bounds.height) / 2 / Canvas.shared.numPointsPerUnit) }
    }
    public var leftEdge: Double {
        get { return self.center.x - Double(self.backingView.bounds.size.width) / 2 / Canvas.shared.numPointsPerUnit }
        set { self.center = Point(x: newValue + Double(self.backingView.bounds.width) / 2 / Canvas.shared.numPointsPerUnit,y: self.center.y) }
    }
    public var rightEdge: Double {
        get { return self.center.x + Double(self.backingView.bounds.size.width) / 2 / Canvas.shared.numPointsPerUnit }
        set { self.center = Point(x: newValue - Double(self.backingView.bounds.width) / 2 / Canvas.shared.numPointsPerUnit,y: self.center.y) }
    }
}
