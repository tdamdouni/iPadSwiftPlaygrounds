// 
//  SKActionExtension.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//

import Foundation
import SpriteKit


extension SKAction {
    
    public class func orbitAction(x: CGFloat, y: CGFloat, period: Double = 4.0) -> SKAction {
        // x, y
        let center = CGPoint(x: 0, y: 0)
        let rect = CGRect(x: center.x - x, y: center.y - y, width: x * 2.0, height: y * 2.0)
        let ovalPath = UIBezierPath(ovalIn: rect)
        let reversed = randomInt(from: 0, to: 1) == 1
        
        var orbitAction = SKAction.follow(ovalPath.cgPath,
                                          asOffset: false ,
                                          orientToPath: true,
                                          duration: period)
        if reversed {
            orbitAction = orbitAction.reversed()
        }
        
        return .repeatForever(orbitAction)
    }

    /// Pulsate node by increasing and decreasing its scale over period seconds. Repeat count times or indefinitely if count == -1
    public class func pulsate(period: Double = 5.0, count: Int = -1) -> SKAction {
        
        let originalScale: CGFloat = 1
        let scale = originalScale * 1.5
        let pulseOut = SKAction.scale(to: scale, duration: period)
        let pulseIn = SKAction.scale(to: scale, duration: period)
        pulseOut.timingMode = SKActionTimingMode.easeOut
        pulseIn.timingMode = SKActionTimingMode.easeOut
        
        let sequence = SKAction.sequence([pulseOut, pulseIn])
        let action: SKAction
        if count == 0 {
            action = .repeatForever(sequence)
        }
        else {
            action = .repeat(sequence, count: count)
        }
        return action
    }
    
    public class func shake(duration: Double = 2.0) -> SKAction {
        
        let amplitudeX: Float = 10
        let amplitudeY: Float = 6
        let numberOfShakes = duration / 0.04
        var actionsArray:[SKAction] = []
        for _ in 1...Int(numberOfShakes.int) {
            let moveX = Float(arc4random_uniform(UInt32(amplitudeX))) - amplitudeX / 2
            let moveY = Float(arc4random_uniform(UInt32(amplitudeY))) - amplitudeY / 2
            let shakeAction = SKAction.moveBy(x: CGFloat(moveX), y: CGFloat(moveY), duration: 0.02)
            shakeAction.timingMode = SKActionTimingMode.easeOut
            actionsArray.append(shakeAction)
            actionsArray.append(shakeAction.reversed())
        }
        
        return .sequence(actionsArray)
    }
    
    /// Animates the node to spin and pop to remove itself from the scene over the provided number of seconds.
    public class func spinAndPop(after seconds: Double = 2.0) -> SKAction {
        
        let scale: CGFloat = 2.5
        let wait = SKAction.wait(forDuration: 1.0, withRange: 4.0)
        let scaleAction = SKAction.scale(to: scale, duration: seconds)
        scaleAction.timingMode = .easeIn
        let rotateTime = 0.25
        let rotations = Int(seconds / rotateTime) + 1
        let rotate = SKAction.rotate(byAngle: 3.14, duration: rotateTime)
        let spin = SKAction.repeat(rotate, count: Int(rotations))
        let sound = SKAction.playSoundFileNamed("Vox Kit 1 Snare 068.wav", waitForCompletion: true)
        let oneSpin = SKAction.repeat(rotate, count: 1)
        let megaScale = SKAction.scale(to: CGFloat(scale) * 1.5, duration: 0.25)
        megaScale.timingMode = .easeIn
        
        let scaleAndSpin = SKAction.group([scaleAction, spin])
        let soundScaleAndOneSpin = SKAction.group([megaScale, sound, oneSpin])
        
        return .sequence([wait, scaleAndSpin, soundScaleAndOneSpin, .removeFromParent()])
    }
    
    public class func swirlAway(after seconds: Double = 2.0, rotations: CGFloat = 4.0, from: CGPoint) -> SKAction {
        
        let duration = 4.0
        let spiral = SKAction.spiral(startRadius: 5,
                                     endRadius: 25 * rotations,
                                     angle: CGFloat.pi * 2 * rotations,
                                     centerPoint: from,
                                     duration: duration)
        
        let rotate = SKAction.rotate(byAngle: CGFloat.pi * 4 * rotations, duration: duration)
        let fade = SKAction.fadeOut(withDuration: duration)
        let spiralRotateFade = SKAction.group([spiral, rotate, fade])
        
        return .sequence([.wait(forDuration: seconds), spiralRotateFade, .removeFromParent()])
    }
    
    
    fileprivate class func spiral(startRadius: CGFloat, endRadius: CGFloat, angle
        totalAngle: CGFloat, centerPoint: CGPoint, duration: TimeInterval) -> SKAction {
        
        func pointOnCircle(angle: CGFloat, radius: CGFloat, center: CGPoint) -> CGPoint {
            return CGPoint(x: center.x + radius * cos(angle),
                           y: center.y + radius * sin(angle))
        }
        
        // The distance the node will travel away from/towards the
        // center point, per revolution.
        let radiusPerRevolution: CGFloat = 5.0 //(endRadius - startRadius) / totalAngle
        
        let action = SKAction.customAction(withDuration: duration) { node, time in
            // Current angle
            let θ = totalAngle * time / CGFloat(duration)
            
            // The equation, r = a + bθ
            let radius = startRadius + radiusPerRevolution * θ
            
            node.position = pointOnCircle(angle: θ, radius: radius, center: centerPoint)
        }
        
        return action
    }
    
    /// Moves the node to a position animated over duration in seconds.
    public class func moveAndZap(to: CGPoint, duration: Double = 0.0) -> SKAction {
        
        let moveAction = SKAction.move(to: to, duration: duration)
        moveAction.timingMode = .easeIn
        let sound = SKAction.playSoundFileNamed("Warp Engineering 01.wav", waitForCompletion: false)
        let removeAction = SKAction.removeFromParent()
        let action = SKAction.sequence([sound, moveAction, removeAction])
        
        return action
    }
    
    /// Rotate node continuously with one rotation over period in seconds.
    public class func spin(period: Double = 2.0) -> SKAction {
        
        let action = SKAction.rotate(byAngle: CGFloat.pi * 2.0, duration: max(period, 0.1))
        return .repeatForever(action)
        
    }

}

