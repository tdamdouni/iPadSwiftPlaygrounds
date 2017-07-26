// 
//  LiveViewGraphic.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//

import Foundation
import UIKit
import SpriteKit
import PlaygroundSupport




enum TextureType {
    
    case background
    case graphic
    
    var maximumSize: CGSize {
        switch self {
        case .background:
            return CGSize(width: 2000, height: 2000)
            
        case .graphic:
            return CGSize(width: 500, height: 500)
        }
    }
    
    static var backgroundMaxSize = CGSize(width: 2000, height: 2000)
    static var graphicMaxSize = CGSize(width: 500, height: 500)
}



/*
    The LiveViewGraphic structure implements the live view process's implementation of the Graphic Protocol.
    It is what actually carries out the animations and UI driven actions from the user process.
*/

public class LiveViewGraphic {
    
    static var cachedTextures = [Image : SKTexture]()
    

    public let id: String
    
    
    var fontName: String? = nil {
        
        didSet {
            updateTextImage()
        }
    }
    
    var fontSize: Int? = nil {
        
        didSet {
            updateTextImage()
        }
    }
    
    var textColor: UIColor? = nil {
        
        didSet {
            updateTextImage()
        }
    }

    var text: String? = nil {

        didSet {
            updateTextImage()
        }
    }
    
    let backingNode = SKSpriteNode()
    
    public var alpha: CGFloat {
        get {
            return backingNode.alpha
        }
        
        set {
            backingNode.alpha = alpha
        }
    }

    // Defaults to no rotation applied. Implied zero.
    public var rotation: CGFloat {
        get {
            return backingNode.zRotation
        }
        
        set {
            backingNode.zRotation = rotation
        }
        
    }
    
    
    public var isHidden: Bool {
        get {
            return backingNode.isHidden
        }
        
        set {
            backingNode.isHidden = isHidden
        }
    }
    
    public var position: CGPoint {
        get {
            return backingNode.position
        }
        
        set {
            backingNode.position = position
        }
        
    }
    
    public var scale: Double {
        get {
            return Double(backingNode.xScale)
        }
        
        set {
            backingNode.setScale(CGFloat(scale))
        }
    }
    
    public var tintColor: UIColor? = nil {
        didSet {
            if let color = tintColor {
                backingNode.color = color
                backingNode.colorBlendFactor = 0.5
            }
            backingNode.colorBlendFactor = 1
        }
    }
    
    public var image: Image? {
        didSet {
            guard let image = image else {
                backingNode.texture = nil
                return
            }
            if let texture = LiveViewGraphic.texture(for: image) {
                backingNode.texture = texture
                backingNode.size = texture.size()
            }
        }
    }
    
    class func texture(for image: Image , type: TextureType = .graphic) -> SKTexture? {
        
        if let texture = LiveViewGraphic.cachedTextures[image] {
            return texture
        }
        
        guard var uiImage = UIImage(named: image.path) else {
            return nil
        }
        // clamp image to maxTextureSize
        let maxSize = type.maximumSize
        if (uiImage.size.width > maxSize.width ||
            uiImage.size.height  > maxSize.height) {
            uiImage = uiImage.resized(to: uiImage.size.fit(within: maxSize))
        }
        
        let texture = SKTexture(image: uiImage)
        LiveViewGraphic.cachedTextures[image] = texture
        
        return texture
    }
    
    var graphic: Graphic {
        
        let _graphic = Graphic(id: id)
        _graphic.suppressMessageSending = true
        _graphic.text = text ?? ""
        _graphic.alpha = Double(alpha)
        _graphic.position = Point(position)
        _graphic.isHidden = isHidden
        _graphic.rotationRadians = rotation
        _graphic.scale = scale
        _graphic.image = image
        
        if let color = textColor {
            _graphic.textColor = color
        }
        
        if let name = fontName, let liveGraphicFontName = FontName(rawValue: name) {
            _graphic.fontName = liveGraphicFontName
        }
        
        return _graphic
    }


    public required init(id: String) {
        self.id = id
    }
       

    public func remove() {
        backingNode.removeFromParent()
    }
    
    func updateTextImage() {
        guard
            let text = text,
            let textColor = textColor,
            let fontName = fontName,
            let fontSize = fontSize,
            let font = UIFont(name: fontName, size: CGFloat(fontSize)),
            let image = type(of: self).image(from: text, textColor: textColor, font: font)
            else { return }
        
        let texture = SKTexture(image: image)
        backingNode.texture = texture
        backingNode.size = texture.size()
    }

    class func image(from text: String, textColor: UIColor, font: UIFont) -> UIImage? {
        let text = text as NSString
        let attributes = [NSFontAttributeName : font,
                          NSForegroundColorAttributeName: textColor] as [String : Any]
        let textSize = text.size(attributes: attributes)
        guard textSize.width > 1 && textSize.height > 1 else { return nil }
        
        UIGraphicsBeginImageContextWithOptions(textSize, false, 0.0)
        
        text.draw(in: CGRect(x:0, y:0, width:textSize.width,  height:textSize.height), withAttributes: attributes)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

    
    // Equatable Conformance
    public static func ==(lhs: LiveViewGraphic, rhs: LiveViewGraphic) -> Bool {
        return lhs.backingNode === rhs.backingNode // Intentionally testing for object identity
    }
    
    
    public func swirlAway(after seconds: Double, rotations: CGFloat) {
        
        backingNode.run(.swirlAway(after: seconds, rotations: rotations, from: backingNode.position))
    }
    
}
