// 
//  MessageEncoder.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//

import Foundation
import UIKit
import PlaygroundSupport
import SpriteKit


public struct MessageEncoder {
    
    private var encodedInfo =  [MessageKey : PlaygroundValue]()
    
    var playgroundValue: PlaygroundValue {
       
        var returnInfo = [String : PlaygroundValue]()
        
        for (key, value) in encodedInfo {
            returnInfo[key.rawValue] = value
        }
        return .dictionary(returnInfo)
    }
    
    
    var isRegistered: Bool? {
        
        didSet {
            encodedInfo[.registered] = isRegistered?.playgroundValue
        }
    }

    var isPrintable: Bool? {
        
        didSet {
            encodedInfo[.isPrintable] = isPrintable?.playgroundValue
        }
    }
    
    var isHidden: Bool? {
       
        didSet {
            encodedInfo[.hidden] = isHidden?.playgroundValue
        }
    }

    var includeSystemTools: Bool? {
        
        didSet {
            encodedInfo[.includeSystemTools] = includeSystemTools?.playgroundValue
        }
    }

    
    var color: UIColor? {
        
        didSet {
            encodedInfo[.color] = color?.playgroundValue
        }
    }
    
    var path: String? {
       
        didSet {
            encodedInfo[.path] = path?.playgroundValue
        }
    }
    
    var point: CGPoint? {
       
        didSet {
            encodedInfo[.point] = point?.playgroundValue
        }
    }

    var position: CGPoint? {
        
        didSet {
            encodedInfo[.position] = position?.playgroundValue
        }
    }

    
    var id: String? {
       
        didSet {
            encodedInfo[.id] = id?.playgroundValue
        }
    }
    
    var messageType: MessageName? {
        
        didSet {
            encodedInfo[.messageType] = messageType?.playgroundValue
        }
    }
    
    var name: String? {
       
        didSet {
            encodedInfo[.name] = name?.playgroundValue
        }
    }
    
    var rotations: Double? {
        
        didSet {
            encodedInfo[.rotations] = rotations?.playgroundValue
        }
    }

    var duration: Double? {
       
        didSet {
            encodedInfo[.duration] = duration?.playgroundValue
        }
    }

    var key: String? {
        
        didSet {
            encodedInfo[.key] = key?.playgroundValue
        }
    }
    
    var limit: Int? {
       
        didSet {
            encodedInfo[.limit] = limit?.playgroundValue
        }
    }

    var icon: UIImage? {
       
        didSet {
            encodedInfo[.icon] = icon?.playgroundValue
        }
    }
    
    var image: Image? {
       
        didSet {
            encodedInfo[.image] = image?.playgroundValue
        }
    }
    
    var text: String? {
        didSet {
            encodedInfo[.text] = text?.playgroundValue
        }
    }
    
    var textColor: UIColor? {
        
        didSet {
            encodedInfo[.textColor] = textColor?.playgroundValue
        }
    }
    
    var fontSize: Int? {
        
        didSet {
            encodedInfo[.fontSize] = fontSize?.playgroundValue
        }
    }
    
    var fontName: String? {
        
        didSet {
            encodedInfo[.fontName] = fontName?.playgroundValue
        }
    }
    
    var array: [PlaygroundValue]? {
       
        didSet {
            if let array = array {
                encodedInfo[.array] = .array(array)
            }
            else {
                encodedInfo[.array] = nil
            }
        }
    }
    
    var dictionary: [String : PlaygroundValue]? {
       
        didSet {
            if let dictionary = dictionary {
                encodedInfo[.dictionary] = .dictionary(dictionary)
            }
            else {
                encodedInfo[.dictionary] = nil
            }
        }
    }
    
    var tool: Tool? {
        
        didSet {
            if let value = tool?.playgroundValue {
                encodedInfo[.tool] = .array([value])
            }
            else if tool == nil{
                encodedInfo[.tool] = nil
            }
        }
    }
    
    var tools: [Tool]? {
        
        didSet {
            encodedInfo[.tools] = tools?.playgroundValue
        }
    }
    
    var graphics: [Graphic]? {
        
        didSet {
            encodedInfo[.graphics] = graphics?.playgroundValue
        }
    }
    
    var assessmentStatus: PlaygroundPage.AssessmentStatus? {
      
        didSet {
            encodedInfo[.assessmentStatus] = assessmentStatus?.playgroundValue
        }
    }
    
    var action: SKAction? {
        
        didSet {
            encodedInfo[.action] = action?.playgroundValue
        }
    }
    
    var touch: Touch? {
        
        didSet {
            encodedInfo[.touch] = touch?.playgroundValue
        }
    }
    
    var assessmentTrigger: AssessmentTrigger? {
        
        didSet {
            encodedInfo[.assessmentTrigger] = assessmentTrigger?.rawValue.playgroundValue
        }
    }
    
    var graphic: Graphic? {
        didSet {
            encodedInfo[.graphic] = graphic?.playgroundValue
        }
    }
    
    var overlay: Overlay? {
        didSet {
            encodedInfo[.overlay] = overlay?.playgroundValue
        }
    }
}

