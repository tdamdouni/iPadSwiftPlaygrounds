// 
//  MessageDecoder.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//

import Foundation
import UIKit
import PlaygroundSupport
import SpriteKit


public struct MessageDecoder {
    
    var info: [MessageKey : PlaygroundValue]
    
    public init(from: [String : PlaygroundValue]) {
        info = [MessageKey : PlaygroundValue]()
        
        for (key, playgroundValue) in from {
            if let messageKey = MessageKey(rawValue: key) {
                info[messageKey] = playgroundValue
            }
        }
    }
    
    func value<T>(forKey key: MessageKey) -> T? {
        guard let value = info[key] else { return nil }
        return key.decoded(playgroundValue: value) as? T
    }
    
    var isRegistered: Bool? {
        return value(forKey: .registered)
    }
    
    var isHidden: Bool? {
        return value(forKey: .hidden)
    }
    
    var isPrintable: Bool? {
        return value(forKey: .isPrintable)
    }
    
    var includeSystemTools: Bool? {
        return value(forKey: .includeSystemTools)
    }
    
    var color: UIColor? {
        return value(forKey: .color)
    }
    
    var path: String? {
        return value(forKey: .path)
    }
    
    
    var point: CGPoint? {
        return value(forKey: .point)
    }

    var position: CGPoint? {
        return value(forKey: .position)
    }

    
    var id: String? {
        return value(forKey: .id)
    }
    
    var messageType: MessageName? {
        return value(forKey: .messageType)
    }
    
    var name: String? {
        return value(forKey: .name)
    }
    
    var rotations: Double? {
        return value(forKey: .rotations)
    }

    var duration: Double? {
        return value(forKey: .duration)
    }

    var key: String? {
        return value(forKey: .key)
    }
    
    var limit: Int? {
        return value(forKey: .limit)
    }
    
    var icon: UIImage? {
        return value(forKey: .icon)
    }
    
    var image: Image? {
        return value(forKey: .image)
    }
    
    var text: String? {
        return value(forKey: .text)
    }
    
    var textColor: UIColor? {
        let returnColor: UIColor? = value(forKey: .textColor) //Direct the type inferencing
        return returnColor
    }
    
    var fontSize: Int? {
        return value(forKey: .fontSize)
    }
    
    var fontName: String? {
        return value(forKey: .fontName)
    }
    
    var array: [PlaygroundValue]? {
        return value(forKey: .array)
    }
    
    var dictionary: [String : PlaygroundValue]? {
        return value(forKey: .dictionary)
    }
    
    var tool: Tool? {
        return value(forKey: .tool)
    }
    
    var tools: [Tool]? {
        
        guard
            let playgroundArray: PlaygroundValue = info[.tools],
            case .array(let array) = playgroundArray else { return nil }
                
        var returnTools = [Tool]()
       
        for toolValue in array {
            if let tool: Tool = Tool.from(toolValue) {
                returnTools.append(tool)
            }
        }
        
        return returnTools.count > 0 ? returnTools : nil
    }
    
    var graphics: [Graphic]? {
        
        guard
            let playgroundArray: PlaygroundValue = info[.graphics],
            case .array(let array) = playgroundArray else { return nil }
        
        var returnGraphics = [Graphic]()
        
        for graphicValue in array {
            if let graphic: Graphic = Graphic.from(graphicValue) {
                returnGraphics.append(graphic)
            }
        }
        
        return returnGraphics.count > 0 ? returnGraphics : nil
    }
    
    var assessmentStatus: PlaygroundPage.AssessmentStatus? {
        return value(forKey: .assessmentStatus)
    }

    var action: SKAction? {
        return value(forKey: .action)
    }
    
    var touch: Touch? {
        return value(forKey: .touch)
    }
    
    var assessmentTrigger: AssessmentTrigger? {
        return value(forKey: MessageKey.assessmentTrigger)
    }
    
    var graphic: Graphic? {
        return value(forKey: .graphic)
    }
    
    var overlay: Overlay? {
        return value(forKey: .overlay)
    }
}


