// 
//  Message.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//

import Foundation
import UIKit
import SpriteKit
import PlaygroundSupport



// MARK: Enum Types
public enum MessageKey: String {
    
    case messageType
    case path
    case id
    case name
    case color
    case registered
    case point
    case position
    case limit
    case tool
    case tools
    case icon
    case array
    case dictionary
    case hidden
    case text
    case image
    case assessmentStatus
    case action
    case key
    case rotations
    case duration
    case touch
    case assessmentTrigger
    case fontName
    case fontSize
    case textColor
    case isPrintable
    case graphic
    case graphics
    case includeSystemTools
    case overlay
}


public enum MessageName: String {
    
    case setSceneBackgroundColor
    case setSceneBackgroundImage
    case clearScene
    case createNode
    case deleteNode
    case getNodes
    case getNodesReply
    case setImage
    case setText
    case setTextColor
    case registerTools
    case toolSelected
    case hideTools
    case registerTouchHandler
    case sceneTouchEvent
    case requestRateLimit
    case replyRateLimit
    case actionButtonTapped
    case spin
    case setAssessment
    case runAction
    case swirlAway
    case trigger
    case placeGraphic
    case removeGraphic
    case setFontSize
    case setFontName
    case setButton
    case getGraphics
    case getGraphicsReply
    case touchEventAcknowledgement
    case includeSystemTools
    case overlay
}

extension MessageKey {
    
    var transformable: PlaygroundValueTransformable.Type {
        switch self {
            
        case .assessmentTrigger:
            return AssessmentTrigger.self
            
        case .image:
            return Image.self
            
        case .messageType:
            return MessageName.self
            
        case .path, .id, .text, .name, .key, .fontName:
            return String.self
            
        case .color, .textColor:
            return UIColor.self
            
        case.hidden, .registered, .isPrintable, .includeSystemTools:
            return Bool.self
            
        case .point, .position:
            return CGPoint.self
            
        case .limit, .fontSize:
            return Int.self
            
        case .icon:
            return UIImage.self
            
        case .tool:
            return Tool.self
            
        case .tools:
            return Array<Tool>.self
            
        case .array:
            return PlaygroundValueArray.self
            
        case .dictionary:
            return PlaygroundValueDictionary.self
                        
        case .assessmentStatus:
            return PlaygroundPage.AssessmentStatus.self

        case .action:
            return SKAction.self
            
        case .rotations, .duration:
            return Double.self
            
        case .touch:
            return Touch.self
            
        case .graphic:
            return Graphic.self
            
        case.graphics:
            return Array<Graphic>.self
            
        case .overlay:
            return Overlay.self
            
        }
    }
    
    func decoded(playgroundValue: PlaygroundValue) -> PlaygroundValueTransformable? {
        return transformable.from(playgroundValue)
    }
    
}

// MARK: Message Definition

public indirect enum Message: RawRepresentable {
    
    public typealias RawValue  = PlaygroundValue
    
    // Scene modification
    case setSceneBackgroundColor(UIColor)
    case setSceneBackgroundImage(Image?)
    case clearScene
    case placeGraphic(id: String, position: CGPoint, isPrintable: Bool)
    case removeGraphic(id: String)
    
    // Node Lifetime Management
    case createNode(id: String)
    case deleteNode(id: String)
    case getGraphics
    case getGraphicsReply(graphics: [Graphic])
    
    // Image
    case setImage (id: String, image: Image?)
    
    // Text related
    case setText        (id: String, text: String?)
    case setTextColor   (id: String, color: UIColor)
    case setFontSize    (id: String, size: Int)
    case setFontName    (id: String, name: String)
    
    // Toolbar Management
    case registerTools([Tool]?)
    case toolSelected(Tool)
    case hideTools(Bool)
    case includeSystemTools(Bool)
    
    // Touch handling
    case registerTouchHandler(Bool)
    case sceneTouchEvent(Touch)
    case touchEventAcknowledgement
    
    // Button Handling
    case actionButtonTapped
    case setButton(name: String)

    // SpriteKit Action handling
    case runAction(id: String, action: SKAction, key: String?)
    case swirlAway(id: String, after: Double, rotations: Double)

    
    // These are control related messages. They inform the User process how many messages it may send.
    case requestRateLimit
    case replyRateLimit(limit: Int)
    
    // Assessment
    case setAssessment(PlaygroundPage.AssessmentStatus)
    case trigger(AssessmentTrigger)
    
    // Overlays
    case useOverlay(Overlay)
    
    public init?(rawValue: RawValue) {
        guard case .dictionary(let info) = rawValue else { return nil }
        let decoder = MessageDecoder(from: info)
        guard let messageType = decoder.messageType else { return nil }
        
        switch messageType {
            
            
        case .setSceneBackgroundColor:
            
            if let color = decoder.color {
                self = .setSceneBackgroundColor(color)
                return
            }
            
        case .setSceneBackgroundImage:
            if let image = decoder.image {
                self = .setSceneBackgroundImage(image)
                return
            }
            
        case .clearScene:
            self = .clearScene
            return
            
        case .registerTouchHandler:
            if let registered = decoder.isRegistered {
                self = .registerTouchHandler(registered)
                return
            }
            
        case .sceneTouchEvent:
            if  let touch = decoder.touch {
                self = .sceneTouchEvent(touch)
                return
            }
            
        case .createNode:
            if let id = decoder.id {
                self = .createNode(id: id)
                return
            }
            
        case .deleteNode:
            if let id = decoder.id {
                self = .deleteNode(id: id)
                return
            }
            
        case .registerTools:
            if let tools = decoder.tools {
                self = .registerTools(tools)
                return
            }
        
        case .toolSelected:
            if let tool = decoder.tool {
                self = .toolSelected(tool)
                return
            }
            
        case .hideTools:
            if let hidden = decoder.isHidden {
                self = .hideTools(hidden)
                return
            }
            
        case .includeSystemTools:
            if let includeTools = decoder.includeSystemTools {
                self = .includeSystemTools(includeTools)
                return
            }
                   
        case .setImage:
            if let id = decoder.id, let image = decoder.image {
                self = .setImage(id: id, image: image)
                return
            }
            
        case .runAction:
            if let id = decoder.id, let action = decoder.action {
                self = .runAction(id: id, action: action, key: decoder.key)
                return
            }

        case .setAssessment:
            guard let status = decoder.assessmentStatus else { return nil }
            self = .setAssessment(status)
            return
            
        case .swirlAway:
            if
                let id = decoder.id,
                let duration = decoder.duration,
                let rotations = decoder.rotations {
                self = .swirlAway(id: id, after: duration, rotations: rotations)
                return
            }
            
        case .trigger:
            if let assessmentTrigger = decoder.assessmentTrigger {
                self = .trigger(assessmentTrigger)
                return
            }

        case .placeGraphic:
            if let id = decoder.id, let position = decoder.position, let isPrintable = decoder.isPrintable {
                self = .placeGraphic(id: id, position: position, isPrintable: isPrintable)
                return
            }

        case .removeGraphic:
            if let id = decoder.id {
                self = .removeGraphic(id: id)
                return
            }

        case .setText:
            if let id = decoder.id {
                self = .setText(id: id, text: decoder.text)
                return
            }
            
        case .setTextColor:
            if let id = decoder.id, let color = decoder.textColor {
                self = .setTextColor(id: id, color: color)
                return
            }
            
        case .setFontName:
            if let id = decoder.id, let fontName = decoder.fontName {
                self = .setFontName(id: id, name: fontName)
                return
            }
            
        case .setFontSize:
            if let id = decoder.id, let fontSize = decoder.fontSize {
                self = .setFontSize(id: id, size: fontSize)
                return
            }
            
        case .actionButtonTapped:
            self = .actionButtonTapped
            return
            
        case .setButton:
            if let name = decoder.name {
                self = .setButton(name: name)
                return
            }
            
        case .getGraphics:
            self = .getGraphics
            return
            
        case .getGraphicsReply:
            if let graphics = decoder.graphics {
                self = .getGraphicsReply(graphics: graphics)
                return
            }
            
        case .touchEventAcknowledgement:
            self = .touchEventAcknowledgement
            return
            
        case .overlay:
            if let overlay = decoder.overlay {
                self = .useOverlay(overlay)
                return
            }

            
        default:
            ()
        }
        
        return nil
    }
    
    
    public var rawValue: PlaygroundValue {
        
        var encoder = MessageEncoder()
        
        switch self {
            
        case .setSceneBackgroundColor(let color):
            encoder.messageType =  .setSceneBackgroundColor
            encoder.color = color
            
        case .setSceneBackgroundImage(let image?):
                encoder.messageType = .setSceneBackgroundImage
                encoder.image = image
            
        case .clearScene:
            encoder.messageType = .clearScene
            
        case .registerTouchHandler(let registered):
            encoder.messageType = .registerTouchHandler
            encoder.isRegistered = registered
            
        case .sceneTouchEvent(let touch):
            encoder.messageType = .sceneTouchEvent
            encoder.touch = touch
            
        case .registerTools(let tools):
            encoder.messageType = .registerTools
            encoder.tools = tools
            
        case .toolSelected(let tool):
            encoder.messageType = .toolSelected
            encoder.tool = tool
            
        case .createNode(let id):
            encoder.messageType = .createNode
            encoder.id = id
            
        case .deleteNode(let id):
            encoder.messageType = .deleteNode
            encoder.id = id
            
        case .requestRateLimit:
            encoder.messageType = .requestRateLimit
            
        case .replyRateLimit(let limit):
            encoder.messageType = .replyRateLimit
            encoder.limit = limit

        case .setImage( let id, image: let image):
            encoder.messageType = .setImage
            encoder.id = id
            encoder.image = image
         
        case .hideTools(let hidden):
            encoder.messageType = .hideTools
            encoder.isHidden = hidden

        case .includeSystemTools(let includesTools):
            encoder.messageType = .includeSystemTools
            encoder.includeSystemTools = includesTools
            
        case .runAction(let id, let action, let key):
            encoder.messageType = .runAction
            encoder.id = id
            encoder.action = action
            encoder.key = key
            
        case .setAssessment(let status):
            encoder.messageType = .setAssessment
            encoder.assessmentStatus = status
            
        case .swirlAway(let id, let duration, let rotations):
            encoder.messageType = .swirlAway
            encoder.id = id
            encoder.duration = duration
            encoder.rotations = rotations
            
        case .trigger(let assessmentTrigger):
            encoder.messageType = .trigger
            encoder.assessmentTrigger = assessmentTrigger
           
        case .placeGraphic(let id, let position, let isPrintable):
            encoder.messageType = .placeGraphic
            encoder.id = id
            encoder.position = position
            encoder.isPrintable = isPrintable
            
        case .removeGraphic(let id):
            encoder.messageType = .removeGraphic
            encoder.id = id
            
        case .setText(let id, let text):
            encoder.messageType = .setText
            encoder.id = id
            encoder.text = text
        
        case .setTextColor(let id, let color):
            encoder.messageType = .setTextColor
            encoder.id = id
            encoder.textColor = color
            
        case .setFontName(let id, let name):
            encoder.messageType = .setFontName
            encoder.id = id
            encoder.fontName = name
            
        case .setFontSize(let id, let size):
            encoder.messageType = .setFontSize
            encoder.id = id
            encoder.fontSize = size
            
        case .actionButtonTapped:
            encoder.messageType = .actionButtonTapped
            
        case .setButton(let name):
            encoder.messageType = .setButton
            encoder.name = name
            
        case .getGraphics:
            encoder.messageType = .getGraphics
         
        case .getGraphicsReply(let graphics):
            encoder.messageType = .getGraphicsReply
            encoder.graphics = graphics
            
        case .touchEventAcknowledgement:
            encoder.messageType = .touchEventAcknowledgement
            
        case .useOverlay(let overlay):
            encoder.messageType = .overlay
            encoder.overlay = overlay

        default:
            ()
        }
        
        precondition(encoder.messageType != nil, "[error] messageType must be set on an MessageEncoder to be in a valid state.")
        return encoder.playgroundValue
    }
    
}


// MARK: Message Sending

public typealias MessageDestination = Environment


public extension Message {
    
    public func send(to: MessageDestination = .live) {
        
        switch to {
        case .live:
            guard let proxy = PlaygroundPage.current.liveView as? PlaygroundRemoteLiveViewProxy else { return }
            proxy.send(rawValue)
            
        case .user:
            guard let liveViewMessageHandler = PlaygroundPage.current.liveView as? PlaygroundLiveViewMessageHandler else { return }
            liveViewMessageHandler.send(rawValue)
        }
    }
}



protocol MessageControl {
    
    var suppressMessageSending: Bool { get set }
}


