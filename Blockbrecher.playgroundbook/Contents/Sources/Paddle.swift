//
//  Paddle.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//

import SpriteKit

public class Paddle {
    var spriteNode: SKSpriteNode
    
    public init() {
        spriteNode = SKSpriteNode(imageNamed: "Paddle")
        spriteNode.anchorPoint = CGPoint(x: 0.5, y: 0.5)
    }
}
