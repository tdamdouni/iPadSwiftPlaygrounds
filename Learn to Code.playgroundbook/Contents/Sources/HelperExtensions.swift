// 
//  HelperExtensions.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//

import SceneKit

#if os(OSX)
public typealias SCNFloat = CGFloat
public typealias Texture = NSImage
#elseif os(iOS)
public typealias SCNFloat = Float
public typealias Texture = UIImage
#endif

// MARK: Radians 

let π = SCNFloat(M_PI) // (Option + p) for convenience when using with SceneKit
let epi = SCNFloat(1e-5) // A global constant for Float comparison.

extension SCNFloat {
    var toRadians: SCNFloat {
        return π / 180.0 * self
    }
    
    var toDegrees: Int {
        return Int(self * 180.0 / π)
    }
    
    func isClose(to: SCNFloat, epiValue: SCNFloat = epi) -> Bool {
        return abs(self - to) < epiValue
    }
    
    /// Caps the phase angle to always return a <= 2π && a > -2π
    func capPhase() -> SCNFloat {
        let twoPi = 2 * π
        
        // If the angle is approximately equal to `twoPi`, return the full angle.
        if (self < twoPi || self.isClose(to: twoPi)) && (self > -twoPi || self.isClose(to: -twoPi)) {
            return self
        }
        
        return (twoPi - (self.truncatingRemainder(dividingBy: twoPi))).truncatingRemainder(dividingBy: twoPi)
    }
}

extension Int {
    var toRadians: SCNFloat {
        return SCNFloat(self).toRadians
    }
}

extension Comparable {
    func clamp(min: Self, max: Self) -> Self {
        return Swift.max(Swift.min(self, max), min)
    }
}

func dispatch_after(seconds: Double, queue: DispatchQueue = DispatchQueue.main, handler: () -> Void) {
    
    let delay = __dispatch_time(0, Int64(seconds *  Double(NSEC_PER_SEC)))
    __dispatch_after(delay, queue, handler)
}

// MARK: SceneKit

extension SCNNode {
    
    func childNodesWithPrefix(_ name: String) -> [SCNNode] {
        return childNodes.filter {
            $0.name?.hasPrefix(name) ?? false
        }
    }
    
    func childNodesWithSuffix(_ name: String) -> [SCNNode] {
        return childNodes.filter {
            $0.name?.hasSuffix(name) ?? false
        }
    }
}

extension SCNNode {
    var firstAnimation: CAAnimation? {
        var animation: CAAnimation?
        enumerateChildNodes { child, stop in
            if child.animationKeys.count > 0 {
                animation = child.animation(forKey: child.animationKeys.first!)
                stop.initialize(with: true)
            }
        }
        
        return animation
    }
    
    var allAnimations: [CAAnimation] {
        var animations = animationKeys.flatMap { animation(forKey: $0) }
        
        enumerateChildNodes { child, _ in
            animations += child.animationKeys.flatMap {
                child.animation(forKey:$0)
            }
        }
        return animations
    }
    
    var firstGeometry: SCNGeometry? {
        var geo: SCNGeometry? = geometry
        enumerateChildNodes { node, stop in
            if geo != nil {
                stop.pointee = true
            }
            else {
                geo = node.geometry
            }
        }
        return geo
    }
    
    func createUniqueFirstGeometry() -> SCNGeometry? {
        return firstGeometry?.copy() as? SCNGeometry
    }
}

extension SCNAction {
    /// Creates an SCNAction around a CAAnimation.
    /// Allows animations to be easily sequenced, repeated, etc.
    ///
    /// Removes the animation upon completion.
    /// If no speed is provided the animation's speed is used.
    class func animate(with animation: CAAnimation, speed: Double? = nil, forKey key: String? = nil) -> SCNAction {
        animation.isRemovedOnCompletion = true
        if let speed = speed {
            animation.speed = Float(speed)
        }
        
        let runDuration = animation.duration / Double(animation.speed)
        
        var didAddAnimation = false
        return customAction(withDuration: runDuration) { node, time in
            guard !didAddAnimation else {
                if SCNFloat(time).isClose(to: SCNFloat(runDuration)) {
                    // Reset the action.
                    didAddAnimation = false
                }
                return
            }
            
            node.add(animation, forKey: key)
            didAddAnimation = true
        }
    }
}

extension SCNMatrix4: CustomDebugStringConvertible {
    public var debugDescription: String { get {
        return "{\n\t{\(m11), \(m12), \(m13), \(m14)},\n\t{\(m21), \(m22), \(m23), \(m24)},\n\t{\(m31), \(m32), \(m33), \(m34)},\n\t{\(m41), \(m42), \(m43), \(m44)}\n}"
        }
    }
}

// MARK: Vector Math

extension SCNVector3: Equatable {
    func length() -> SCNFloat {
        return sqrt(x * x + y * y + z * z)
    }
    
    func cross(_ b: SCNVector3) -> SCNVector3 {
        // |  i | j  | k  |
        // | x1 | y1 | z1 | -> self
        // | x2 | y2 | z2 | -> b
        // cross = (y1 * z2 - z1 * y2)i - (x1 * z2 - z1 * x2)j + (x1 * y2 - y1 * x2)k
        return SCNVector3(x: y * b.z - z * b.y, y: z * b.x - x * b.z, z: x * b.y - y * b.x)
    }
    
    func dot(_ b: SCNVector3) -> SCNFloat {
        return x * b.x + y * b.y + z * b.z
    }
    
    func normalize() -> SCNVector3 {
        let l = length()
        return SCNVector3(x: x / l, y: y / l, z: z / l)
    }
}

public func -(left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x:left.x - right.x, y: left.y - right.y)
}

public func ==(left: SCNVector3, right: SCNVector3) -> Bool {
    let delta: SCNFloat = 0.00001
    if fabs(left.x - right.x) < delta && fabs(left.y - right.y) < delta && fabs(left.z - right.z) < delta {
        return true
    }
    return false
}

public func -(lhs: SCNVector3, rhs: SCNVector3) -> SCNVector3 {
    return SCNVector3Make(lhs.x - rhs.x, lhs.y - rhs.y, lhs.z - rhs.z)
}

public func -(lhs: float3, rhs: float3) -> float3 {
    return float3(lhs.x - rhs.x, lhs.y - rhs.y, lhs.z - rhs.z)
}

/// Use the dot product to determine the angle between the vectors A•B = |A||B|cosø
func angleBetween(_ v1: float2, v2: float2) -> SCNFloat {
    let dotProduct = dot(v1, v2)
    let magnitudes = hypot(v2.x, v2.y) * hypot(v1.x, v1.y)
    return SCNFloat(acos(dotProduct / magnitudes))
}

// MARK: Logging

import asl

/*
 #define ASL_LEVEL_EMERG   0
 #define ASL_LEVEL_ALERT   1
 #define ASL_LEVEL_CRIT    2
 #define ASL_LEVEL_ERR     3
 #define ASL_LEVEL_WARNING 4
 #define ASL_LEVEL_NOTICE  5
 #define ASL_LEVEL_INFO    6
 #define ASL_LEVEL_DEBUG   7
 */

public enum LogLevel: Int32 {
    case emergency = 0
    case alert = 1
    case critical = 2
    case error = 3
    case warning = 4
    case notice = 5
    case info = 6
    case debug = 7
}

private var logCounter = 0
public func log(message: String = "", callerName: String = #function, level: LogLevel = .info) {
    let prefixedString = "MW: <\(logCounter): \(getpid())>-\(callerName)- " + message
    
    // MD 5/23. NSLog is showing in Console.app, asl_vlog is not.
    NSLog(prefixedString)
    
    logCounter += 1
    /*
    prefixedString.withCString { cString in
        withVaList([cString]) { vaList in
            asl_vlog(nil, nil, level.rawValue, "%s", vaList)
        }
    }
    */
}

// MARK: CoreAnimation

extension CAAnimation {
    class func animationWithSceneNamed(_ name: String) -> CAAnimation? {
        if let scene = SCNScene(named: name) {
            return scene.rootNode.firstAnimation
        }
        return nil
    }
    
    class func animationsWithSceneNamed(_ name: String) -> [CAAnimation] {
        return SCNScene(named: name)?.rootNode.allAnimations ?? []
    }
    
    class func spinAnimation() -> CAAnimation {
        let animation = CABasicAnimation(keyPath: "rotation")
        animation.toValue = NSValue(scnVector4: SCNVector4(x: 0, y: SCNFloat(1), z: 0, w: π * 2))
        animation.duration = 10
        
        // Provide some randomness.
//        animation.beginTime = Double(random() % 5)
        animation.repeatCount = Float.infinity
        
        return animation
    }
    
    func setDefaultAnimationValues() {
        usesSceneTimeBase = false
        repeatCount = 0
        isRemovedOnCompletion = false
        fillMode = kCAFillModeForwards
        
//        fadeInDuration = 0.3
//        fadeOutDuration = 0.1
    }
}

// MARK: Random

func random() -> Int {
    return Int(arc4random())
}

extension Array {
    public var randomIndex: Int {
        return Int(arc4random_uniform(UInt32(count)))
    }
    
    public var randomElement: Element? {
        guard indices.contains(randomIndex) else { return nil }
        return self[randomIndex]
    }
}

public var randomBool: Bool {
    return arc4random_uniform(2) == 0
}

#if os(iOS)
// MARK: UIView 

extension UIView {
    
    var gesturesEnabled: Bool {
        get {
            var enabled = true
            for recognizer in gestureRecognizers ?? [] {
                enabled = enabled && recognizer.isEnabled
            }
            return enabled
        }
        set {
            for recognizer in gestureRecognizers ?? [] {
                recognizer.isEnabled = newValue
            }
        }
    }
}
#endif

