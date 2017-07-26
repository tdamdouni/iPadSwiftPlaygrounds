// 
//  WorldConfiguration.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
import CoreGraphics

enum WorldConfiguration {
    static let introPanDuration: CFTimeInterval = 1.25
    
    static let controlsFadeDuration = 0.5

    static let sceneCompletionActionKey = "SceneComplete"

    /// The vertical displacement of each level.
    static let levelHeight: SCNFloat = 0.5
    
    /// The tolerance for the height delta between levels.
    /// This value can be pretty loose because we only deal in half-unit increments.
    static let heightTolerance: SCNFloat = 1E-3
    
    static let coordinateLength: SCNFloat = 1.0
    
    static let gemDisplacement: SCNFloat = 2
    
    static let shadowBitMask: Int = 1 << 2
    static let characterLightBitMask: Int = 1 << 5
    
    /// This is the bitmask of the floor, put this on nodes you don't want reflected
    static let reflectsBitMask: Int = 1 << 7
    
    /// Constants which affect Scene properties
    enum Scene {
        static let actorPause = 0.0
        
        static let resetDuration = 0.5
        
        static let warmupFrameCount = 1
        
        /// The standard volume of the waterfall audio.
        static let waterfallVolume: Float = 75
        
        static let audioRolloffFactor: Float = 5
        
        /// The scale that the labels become when matching the expected count.
        static let counterPopScale: CGFloat = 1.25
        
        static let possibleSpeeds: [Float] = [2, 15, 50]
    }
    
    enum Actor {
        static let walkRunSpeed: Float = 2.5
        
        static let animationFadeDuration: CGFloat = 0.3
        
        /// The time delay before marking actor audio as complete.
        static let audioDelay = 1.5

        static let idleSpeed: Float = 1
        
        static let possibleSpeeds: [Float] = [1.2, 2.5, 5]
        
        /// The `AVSpeechUtterance` rates used to correspond with the different actor
        /// command speeds.
        static let speechRates: [Float] = [0.5, 0.75, 1.0]
    }
}
