// 
//  WorldConfiguration.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
import CoreGraphics

struct WorldConfiguration {
    static let charactersDir = "Characters.scnassets/"
    
    static let resourcesDir = "WorldResources.scnassets/"
    static let scenesDir = WorldConfiguration.resourcesDir + "_Scenes/"
    static let texturesDir = WorldConfiguration.resourcesDir + "textures/"
    static let audioDir = WorldConfiguration.resourcesDir + "Audio/"
    static let propsDir = WorldConfiguration.resourcesDir + "props/"
    
    static let customDir = WorldConfiguration.resourcesDir + "Custom/"

    static let zippy = WorldConfiguration.resourcesDir + "items/"

    static let gemDir = WorldConfiguration.zippy + "Gem/"
    static let keysDir = WorldConfiguration.zippy + "Keys/"
    static let lockDir = WorldConfiguration.zippy + "Lock/"
    static let portalDir = WorldConfiguration.zippy + "Portal/"
    static let switchDir = WorldConfiguration.zippy + "Switch/"
    static let platformDir = WorldConfiguration.zippy + "Platform/"
    static let randomElementsDir = WorldConfiguration.zippy + "RandomItems/"


    /// The vertical displacement of each level.
    static let levelHeight: SCNFloat = 0.5
    
    /// The tolerance for the height delta between levels.
    /// This value can be pretty loose because we only deal in half-unit increments.
    static let heightTolerance: SCNFloat = 1E-3
    
    static let coordinateLength: SCNFloat = 1.0
    
    static let gemDisplacement: SCNFloat = 2
    
    static let shadowBitMask: Int = 1 << 2
    static let characterLightBitMask: Int = 1 << 5
    static let reflectsBitMask: Int = 1 << 7 // this is what I set the floor to, put this on nodes you don't want reflected
    
    /// Constants which affect Scene properties
    struct Scene {
        static let actorPause = 0.0
        
        static let warmupFrameCount = 1
    }
    
    struct Actor {
        static let walkRunSpeed: Float = 2.5
        
        static let animationFadeDuration: CGFloat = 0.3
    }
}
