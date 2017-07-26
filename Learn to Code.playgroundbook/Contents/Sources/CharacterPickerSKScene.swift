// 
//  CharacterPickerSKScene.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//

import Foundation
import SpriteKit


class CharacterPickerSKScene : SKScene {
    
    let cardTextureNames = ["zon_bg_island_a_CARDS.1.png",
                            "zon_bg_island_a_CARDS.2.png"]
    var loopingNodes = [SKSpriteNode]()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    required override init(size: CGSize) {
        super.init(size:size)
    }
    
    override func didMove(to view: SKView) {
        for textureName in cardTextureNames {
            let node = SKSpriteNode()
            loopingNodes.append(node)
            node.texture = SKTexture(imageNamed: "WorldResources.scnassets/textures/\(textureName)")
            node.size = node.texture!.size()
            addChild(node)
            let randomHeight = CGFloat(TimeInterval(arc4random_uniform(350)))
            let x = CGFloat(arc4random_uniform(UInt32(self.size.width)))
            let sequence = SKAction.sequence([SKAction.run( {
                
                node.position = CGPoint(x:x, y:self.size.height + (node.size.height * 0.5) + randomHeight)}),
                                              SKAction.moveTo(y:-node.size.height + node.size.height * 0.5, duration: 4)])
            node.run(SKAction.repeatForever(sequence))
        }
    }
}
