// 
//  Tool.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//

import UIKit
import Foundation



struct ToolOptions: OptionSet {
    
    public let rawValue: Int8
    
    static let draggable            = ToolOptions(rawValue: 1 << 0)
    static let fingerMoveEvents     = ToolOptions(rawValue: 1 << 1)
    static let touchGraphicEvents   = ToolOptions(rawValue: 1 << 2)
    
    public init(rawValue: Int8) {
        self.rawValue = rawValue
    }
}


/// A tool that you can use to modify the scene by having your code respond to events, such as moving your finger across the scene or touching a graphic.
public class Tool: Equatable {
    
    /// The name of the tool that will be displayed on the toolbar.
    public var name: String

    /// The emoji icon that will be displayed with the Tool. Any text beyond the first character is ignored.
    public var emojiIcon: String
    
    let id: String

    static let move = SystemTool(name: NSLocalizedString("Move", comment: "Title for tool that moves graphics around the scene"), icon: Image(imageLiteralResourceName: "LtC3_Move"))
    static let erase = SystemTool(name: NSLocalizedString("Erase", comment: "Title for tool that erases graphics from the scene"), icon: Image(imageLiteralResourceName: "LtC3_Erase"))

    var options: ToolOptions = []
    
    
    var shouldDragGraphics: Bool  {
        get {
            return options.contains(.draggable)
        }
        
        set {
            if newValue {
                options.insert(.draggable)
            }
            else {
                options.remove(.draggable)
            }
        }
    }
    
    /// The event handler function that will handle the “finger moved” events.
    public var onFingerMoved: ((Touch) -> Void)? {
        didSet {
            if let _ = onFingerMoved  {
                options.insert(.fingerMoveEvents)
            }
            else {
                options.remove(.fingerMoveEvents)
            }
        }
    }
    
    /// The event handler function that will handle the “graphic touched” events.
    public var onGraphicTouched: ((Graphic) -> Void)?  {
        didSet {
            if let _ = onGraphicTouched {
                options.insert(.touchGraphicEvents)
            }
            else {
                options.remove(.touchGraphicEvents)
            }
        }
    }
    
    
    init() {
        id = UUID().uuidString
        Message.createNode(id: id).send()
        name = ""
        emojiIcon = ""
    }
    
    
    public required init(id: String) {
        self.id = id
        name = ""
        emojiIcon = ""
    }
    
    
    /// Creates a tool with a name and an optional one character emoji icon.
    public convenience init(name: String, emojiIcon: String) {
        
        self.init()
        self.name = name
        guard emojiIcon.characters.count > 0 else { return }
        self.emojiIcon = String(emojiIcon[emojiIcon.startIndex])
    }
    
    public static func ==(lhs: Tool, rhs: Tool) -> Bool {
        return lhs.name == rhs.name
    }

}

internal class SystemTool : Tool {
    internal var icon: Image?

    required init(id: String) {
        super.init(id: id)
        self.icon = nil
    }

    internal init(name: String, emojiIcon: String = "", icon: Image) {
        super.init()
        self.name = name
        self.icon = icon
        guard emojiIcon.characters.count > 0 else { return }
        self.emojiIcon = String(emojiIcon[emojiIcon.startIndex])
    }
}


