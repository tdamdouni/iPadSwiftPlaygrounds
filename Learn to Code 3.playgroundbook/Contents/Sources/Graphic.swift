// 
//  Graphic.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//

import Foundation
import UIKit
import PlaygroundSupport
import SpriteKit

/*
    The Graphic structure implements the user process's implemenation of the Graphic protocol.
    It works by sending messages to the live view when appropriate, where the real actions are enacted.
    It is a proxy, that causes it's remote counterpart to invoke actions that affect the live view.
 */

/// A graphic object, made from an image or string, that can be placed on the scene.
public class Graphic: MessageControl {
    
    let id: String
    
    let defaultAnimationTime = 0.5
    
    var suppressMessageSending: Bool = false
    
    /// The font used to render the text.
    public var fontName: FontName = .avenirNext {
       
        didSet {
            guard !suppressMessageSending else { return }
            Message.setFontName(id: id, name: fontName.rawValue).send()
        }
    }
    
    /// How big the text is.
    public var fontSize: Number = 32  {
       
        didSet {
            guard !suppressMessageSending else { return }
            Message.setFontSize(id: id, size: fontSize.int).send()
        }
    }
    
    /// The text (if any) that is displayed by the graphic. Setting a new text will update the display.
    public var text: String = "" {
       
        didSet {
            guard !suppressMessageSending else { return }
            Message.setText(id: id, text: text).send()
        }
    }
    

    /// The color for the text of the graphic.
    public var textColor: Color = .black {
      
        didSet {
            guard !suppressMessageSending else { return }
            let color = textColor
            Message.setTextColor(id: id, color: color).send()
        }
    }
    
    
    /// No arg initializer must create identifier.
    init() {
        id = UUID().uuidString
        Message.createNode(id: id).send()
    }
    
    
    /// Initializer for when the id is known (reconstructing a node)
    public required init(id: String) {
        
        self.id = id
    }

    convenience init(named: String) {
       
        self.init(image: Image(imageLiteralResourceName: named)) // We  need an id generated
        
    }
    
        
    /// Creates a graphic from the provided Image type.
    public convenience init(image: Image) {
      
        self.init() //call no-arg initializer on self so that we get an id.
        self.image = image
        /*
            Manually sending a message here, as setting a property on a struct
            from within one of it's own initializers will not trigger the didSet property.
        */
        Message.setImage(id: id, image: image).send()
    }
    
    
    /// Creates a graphic from the provided text.
    public convenience init(text: String) {
       
        self.init() //call no-arg initializer on self so that we get an id.
        textColor = .white
        self.text = text
        Message.setFontSize(id: id, size: fontSize.int).send()
        Message.setFontName(id: id, name: fontName.rawValue).send()
        Message.setTextColor(id: id, color: textColor).send()
        Message.setText(id: id, text: text).send()
    }
    
       
    func send(_ action: SKAction, withKey: String? = nil) {
       
        guard !suppressMessageSending else { return }
        Message.runAction(id: id, action: action, key: withKey).send()
    }
    
    var isHidden: Bool = false {
      
        didSet {
            
            guard !suppressMessageSending else { return }
            if isHidden {
                send(.hide(), withKey: "hide")
            }
            else {
                send(.unhide(), withKey: "unhide")
            }
        }
    }
    
    /// How transparent the view is, between 0.0 (totally transparent) and 1.0 (totally opaque).
    public var alpha: Number = 1.0 {
       
        didSet {
            guard !suppressMessageSending else { return }
            send(.fadeAlpha(to: CGFloat(alpha.double), duration: 0), withKey: "fadeAlpha")
            assessmentController?.append(.setAlpha(graphic: self, alpha: alpha.double))
        }
    }
    
    
    /// The angle in degrees to rotate this object. Changing this rotates the object counter clockwise about it's center. A value of 0.0 (the default) means no rotation. A value 180 will rotate the object 180° and flip it.
    public var rotation: Number {
        get {
            return Double(rotationRadians / CGFloat.pi) * 180.0
        }
        set(newRotation) {
            rotationRadians = (CGFloat(newRotation.double) / 180.0) * CGFloat.pi
        }
    }
    
    // Internal only representation of the rotation in radians.
    var rotationRadians: CGFloat = 0 {
       
        didSet {
            
            guard !suppressMessageSending else { return }
            send(.rotate(toAngle: rotationRadians, duration: defaultAnimationTime, shortestUnitArc: false), withKey: "rotateTo")
        }
    }
    
    /// The position that the center of the graphic is placed at.
    public var position: Point = Point(x: 0, y: 0) {
        
        didSet {
            
            guard !suppressMessageSending else { return }
            send(.move(to: CGPoint(position), duration: 0), withKey: "moveTo")
        }
    }
    
    
    /// Moves the node to a position animated over duration in seconds.
    public func move(to: Point, duration: Number = 0.0) {
        
        let moveAction = SKAction.move(to: CGPoint(to), duration: duration.double)
        moveAction.timingMode = .easeInEaseOut
       send(moveAction, withKey: "moveTo")
        assessmentController?.append(.moveTo(graphic: self, position: to))
    }
    
    /// Moves the node by dx, dy animated over duration in seconds.
    public func moveBy(x: Number, y: Number, duration: Number = 0.0) {
       
        let vector = CGVector(dx: CGFloat(x.double), dy: CGFloat(y.double))
        let moveAction = SKAction.move(by: vector, duration: duration.double)
        moveAction.timingMode = .easeInEaseOut
        send(moveAction, withKey: "moveBy")
    }
    
    /// The scale of the graphic's size: 1.0 is normal, 0.5 is half the size and 2.0 is twice the normal size.
    public var scale: Number  = 1.0 {
        
        didSet {
            
            guard !suppressMessageSending else { return }
            send(.scale(to: CGFloat(scale.double), duration: defaultAnimationTime), withKey: "scaleTo")
        }
    }
    
    
    /// The image being displayed by the graphic.
    public var image: Image? = nil {
        didSet {
            
            guard !suppressMessageSending else { return }
            Message.setImage(id: id, image: image).send()
        }
    }

    /// Removes the graphic from the scene.
    public func remove() {
        Message.deleteNode(id: id).send()
        assessmentController?.append(.remove(graphic: self))

    }
    
    /// Moves the graphic around the center point in a ellipitical orbit defined by x, y and with period in seconds. Direction is randomly chosen.
    public func orbit(x: Number, y: Number, period: Number = 4.0) {
        let orbitAction = SKAction.orbitAction(x: CGFloat(x.double), y: CGFloat(y.double), period: period.double)
        send(orbitAction, withKey: "orbit")
        assessmentController?.append(.orbit(graphic: self, x: x.double, y: y.double, period: period.double))

    }
    
    /// Rotate node continuously with one rotation over period in seconds.
    public func spin(period: Double = 2.0) {
        
        Message.runAction(id: id, action: .spin(period: period), key: "spin").send()
        assessmentController?.append(.spin(graphic: self, period: period.double))
    }
    
    /// Pulsate graphic by increasing and decreasing its scale over period seconds. Repeat count times or indefinitely if count == -1
    public func pulsate(period: Number = 5.0, count: Number = -1) {
        send(.pulsate(period: period.double, count: count.int), withKey: "pulsate")
        assessmentController?.append(.pulsate(graphic: self, period: period.double, count: count.int))
    }

    /// Animates the graphic to fade out of the scene after the provided number of seconds.
    public func fadeOut(after seconds: Number) {
        Message.runAction(id: id, action: .fadeOut(withDuration: seconds.double), key: "fadeOut").send()
        
    }
    
    /// Shakes the graphic for the provided number of seconds.
    public func shake(duration: Number = 2.0) {

        Message.runAction(id: id, action: .shake(duration: duration.double), key: "shake").send()
    }

    /// Animates the graphic to spin and pop to remove itself from the scene over the provided number of seconds.
    public func spinAndPop(after seconds: Number = 2.0) {
        
        Message.runAction(id: id, action: .spinAndPop(after: seconds.double), key: "spinAndPop").send()
    }
    
    /// Animate the node away using a swirling motion with several rotations over the provided number of seconds.
    public func swirlAway(after seconds: Number = 2.0) {
       Message.swirlAway(id: id, after: seconds.double, rotations: 4.0).send()
        assessmentController?.append(.swirlAway(graphic: self, after: seconds))
    }
    
    
    /// Moves the node to a position animated over duration in seconds.
    public func moveAndZap(to: Point, duration: Number = 0.0) {

        Message.runAction(id: id, action: .moveAndZap(to: CGPoint(to), duration: duration.double), key: "moveAndZap").send()
        assessmentController?.append(.moveAndZap(graphic: self, position: to))
    }
    

    /// The distance that the graphic is from the provided point.
    public func distance(from: Point) -> Number {
        
        return position.distance(from: from)
        
    }
    
}


extension Graphic: Hashable, Equatable {
    
    public var hashValue: Int {
        return id.hashValue
    }

    public static func ==(lhs: Graphic, rhs: Graphic) -> Bool {
        
        return lhs.id == rhs.id
    }
    
}



