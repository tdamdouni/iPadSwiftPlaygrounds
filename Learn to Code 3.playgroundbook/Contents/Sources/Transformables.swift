// 
//  Transformables.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//


import Foundation
import UIKit
import SpriteKit
import PlaygroundSupport



public protocol PlaygroundValueTransformable {
    
    var playgroundValue: PlaygroundValue? { get }
    static func from(_ playgroundValue: PlaygroundValue) -> PlaygroundValueTransformable?
    
}


extension String: PlaygroundValueTransformable {
    
    public var playgroundValue: PlaygroundValue? {
        
        return .string(self)
    }
    
    
    public static func from(_ playgroundValue: PlaygroundValue) -> PlaygroundValueTransformable? {
        guard case .string(let string) = playgroundValue else { return nil }

        return string
    }
    
}



extension Bool: PlaygroundValueTransformable {
    
    public var playgroundValue: PlaygroundValue? {
        
        return .boolean(self)
    }

    
    public static func from(_ playgroundValue: PlaygroundValue) -> PlaygroundValueTransformable? {
        guard case .boolean(let boolean) = playgroundValue else { return nil }
        
        return boolean
    }
    
}



extension Int: PlaygroundValueTransformable {
    
    public var playgroundValue: PlaygroundValue? {
        
        return .integer(self)
    }
    
    
    public static func from(_ playgroundValue: PlaygroundValue) -> PlaygroundValueTransformable? {
        guard case .integer(let integer) = playgroundValue else { return nil }
        
        return integer
    }
    
}



extension CGFloat: PlaygroundValueTransformable {
    
    public var playgroundValue: PlaygroundValue? {
        
        return .floatingPoint(Double(self))
    }
    
    
    public static func from(_ playgroundValue: PlaygroundValue) -> PlaygroundValueTransformable? {
        guard case .floatingPoint(let doubleValue) = playgroundValue else { return nil }
        
        return CGFloat(doubleValue)
    }
    
}

extension Double: PlaygroundValueTransformable {
    
    public var playgroundValue: PlaygroundValue? {
        return .floatingPoint(self)
    }
    
    
    public static func from(_ playgroundValue: PlaygroundValue) -> PlaygroundValueTransformable? {
        guard case .floatingPoint(let doubleValue) = playgroundValue else { return nil }
        return doubleValue
    }
    
}



extension MessageName: PlaygroundValueTransformable {
    
    public var playgroundValue: PlaygroundValue? {
        
        return .string(rawValue)
    }
    
    
    public static func from(_ playgroundValue: PlaygroundValue) -> PlaygroundValueTransformable? {
        guard case .string(let name) = playgroundValue else { return nil }
        
        return MessageName(rawValue: name)
    }
    
}



extension UIBezierPath: PlaygroundValueTransformable {
    
    public var playgroundValue: PlaygroundValue? {
        let data = NSKeyedArchiver.archivedData(withRootObject: self)
        return .data(data)
    }
    
    public static func from(_ playgroundValue: PlaygroundValue) -> PlaygroundValueTransformable? {
        guard case .data(let data) = playgroundValue else { return nil }
        return NSKeyedUnarchiver.unarchiveObject(with: data) as? UIBezierPath
    }
}



extension CGPoint: PlaygroundValueTransformable {
    
    public var playgroundValue: PlaygroundValue? {
        return .array([.floatingPoint(Double(x)), .floatingPoint(Double(y))])
    }
    
    public static func from(_ playgroundValue: PlaygroundValue) -> PlaygroundValueTransformable? {
        guard
            case .array(let components) = playgroundValue,
            components.count == 2,
            case .floatingPoint(let x) = components[0],
            case .floatingPoint(let y) = components[1]
            
            else { return nil }
        
        return CGPoint(x: x, y: y)
    }
    
}

extension Point: PlaygroundValueTransformable {
    
    public var playgroundValue: PlaygroundValue? {
        return .array([.floatingPoint(Double(x)), .floatingPoint(Double(y))])
    }
    
    public static func from(_ playgroundValue: PlaygroundValue) -> PlaygroundValueTransformable? {
        guard
            case .array(let components) = playgroundValue,
            components.count == 2,
            case .floatingPoint(let x) = components[0],
            case .floatingPoint(let y) = components[1]
            
            else { return nil }
        return Point(x: x, y: y)
    }
    
}



extension UIColor: PlaygroundValueTransformable {
    
    public var playgroundValue: PlaygroundValue? {
       
        return .array([.floatingPoint(Double(redComponent)),
                       .floatingPoint(Double(greenComponent)),
                       .floatingPoint(Double(blueComponent)),
                       .floatingPoint(Double(alphaComponent))])
    }
    
    public static func from(_ playgroundValue: PlaygroundValue) -> PlaygroundValueTransformable? {
        guard
            case .array(let components) = playgroundValue,
            components.count == 4,
            case .floatingPoint(let red)   = components[0],
            case .floatingPoint(let green) = components[1],
            case .floatingPoint(let blue)  = components[2],
            case .floatingPoint(let alpha) = components[3] else { return nil }
        
        return UIColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: CGFloat(alpha))
    }
    
}



extension UIImage: PlaygroundValueTransformable {
    
    public var playgroundValue: PlaygroundValue? {
        guard let data = (UIImagePNGRepresentation(self)) else { return nil }
      
        return .data(data)
    }
    
    public static func from(_ playgroundValue: PlaygroundValue) -> PlaygroundValueTransformable? {
        guard case .data(let data) = playgroundValue else { return nil }
      
        return UIImage(data: data)
    }
}


extension Image: PlaygroundValueTransformable {
    
    public var playgroundValue: PlaygroundValue? {
        return .string(path)
    }
    
    public static func from(_ playgroundValue: PlaygroundValue) -> PlaygroundValueTransformable? {
        guard case .string(let path) = playgroundValue else { return nil }
        
        return Image(imageLiteralResourceName: path)
    }
}


extension ToolOptions: PlaygroundValueTransformable {
    
    public var playgroundValue: PlaygroundValue? {
     
        return .integer(Int(rawValue))
    }
    
    public static func from(_ playgroundValue: PlaygroundValue) -> PlaygroundValueTransformable? {
        guard case .integer(let intValue) = playgroundValue else { return nil }
    
        return ToolOptions(rawValue: Int8(intValue))
    }
}


extension AssessmentTrigger: PlaygroundValueTransformable {
    
    public var playgroundValue: PlaygroundValue? {
        var array = [PlaygroundValue]()
        array.append(.integer(rawValue[0]))
        if(rawValue.count > 1) {
            array.append(.integer(rawValue[1]))
        }
        
        return .array(array)
    }
    
    public static func from(_ playgroundValue: PlaygroundValue) -> PlaygroundValueTransformable? {
        guard
            case .array(let array) = playgroundValue,
            array.count > 0,
            case .integer(let trigger) = array[0]
            else { return nil }
        
        var returnTrigger: AssessmentTrigger?
       
        switch trigger {
        
        case 0:
            guard
                array.count > 1,
                case .integer(let rawValue) = array[1],
                let context = AssessmentInfo.Context(rawValue: rawValue)
                else { return nil }
            returnTrigger = .start(context: context)
            
        case 1:
            returnTrigger = .stop
            
        case 2:
            returnTrigger = .evaluate
            
        default:
            returnTrigger = nil
        }

        return returnTrigger
    }
}


extension Tool: PlaygroundValueTransformable {
    
    public var playgroundValue: PlaygroundValue? {
        var properties = [String : PlaygroundValue]()
        
        properties["id"]      = id.playgroundValue
        properties["name"]    = name.playgroundValue
        properties["options"] = options.playgroundValue
        properties["emojiIcon"]    = emojiIcon.playgroundValue
        
        return .dictionary(properties)
        
    }
    
    public static func from<T>(_ playgroundValue: PlaygroundValue) ->T? {
        // We may be decoding an array that has one tool, or a dictionary that comprises a single tool.
        if let transformed = decodeFrom(array: playgroundValue) { return transformed as? T}
        if let transformed = decodeFrom(dictionary: playgroundValue) { return transformed  as? T}

        return nil
    }
    
    static func decodeFrom(array: PlaygroundValue) -> PlaygroundValueTransformable? {
        guard case .array(let arrayValue) = array else { return nil }
        guard arrayValue.count > 0, let value = arrayValue.first else { return nil }
        
        return decodeFrom(dictionary: value)
    }
    
    static func decodeFrom(dictionary: PlaygroundValue) -> PlaygroundValueTransformable? {
        guard case .dictionary(let info) = dictionary else { return nil }
        guard let nameValue = info["name"], case .string(let name) = nameValue else { return nil }
        guard let emojiIconValue = info["emojiIcon"], case .string(let emojiIcon) = emojiIconValue else { return nil }

        let tool = Tool(name: name, emojiIcon: emojiIcon)

        if let idOptions = info["options"], case .integer(let options) = idOptions {
            tool.options = ToolOptions(rawValue: Int8(options))
        }
                
        return tool
    }
    
}



extension Array: PlaygroundValueTransformable {
    
    public var playgroundValue: PlaygroundValue? {
        var values = [PlaygroundValue]()
        self.forEach { item in
            if let transformable = item as? PlaygroundValueTransformable,
                let value = transformable.playgroundValue {
                values.append(value)
            }
        }
        guard values.count > 0 else { return nil }
        
        return .array(values)
    }
    
    
    public static func from(_ playgroundValue: PlaygroundValue) -> PlaygroundValueTransformable? {
        guard case .array(let values) = playgroundValue else { return nil }
        var messages = [Message]()
        for value in values {
            if let message = Message(rawValue: value) { messages.append(message) }
        }
        guard messages.count > 0 else { return nil }
        
        return messages
    }
    
}


extension SKAction: PlaygroundValueTransformable {
    
    public var playgroundValue: PlaygroundValue? {
        let data = NSKeyedArchiver.archivedData(withRootObject: self)
        return .data(data)
    }
    
    public static func from(_ playgroundValue: PlaygroundValue) -> PlaygroundValueTransformable? {
        guard case .data(let data) = playgroundValue else { return nil }
        return NSKeyedUnarchiver.unarchiveObject(with: data) as? SKAction
    }
}


extension Touch: PlaygroundValueTransformable {
    
    public var playgroundValue: PlaygroundValue? {
        guard
            let positionValue = CGPoint(position).playgroundValue,
            let distanceValue = previousPlaceDistance.playgroundValue,
            let placedCount = numberOfObjectsPlaced.playgroundValue
        else { return nil }
        
        var array = [positionValue, distanceValue, placedCount]
        
        if let touchedGraphic = touchedGraphic?.playgroundValue {
            array.append(touchedGraphic)
        }

        return .array(array)
        
    }
    
    public static func from(_ playgroundValue: PlaygroundValue) -> PlaygroundValueTransformable? {
        guard
            case .array(let array) = playgroundValue, array.count > 2,
            let touchPosition = CGPoint.from(array[0]) as? CGPoint,
            let touchDistance = Double.from(array[1]) as? Double,
            let placeCount = Int.from(array[2]) as? Int
        else { return nil }
        
        var touchedGraphic: Graphic? = nil
        
        if array.count > 3 {
           touchedGraphic = Graphic.from(array[3])
        }

        return Touch(position: Point(touchPosition),
                     previousPlaceDistance: touchDistance,
                     numberOfObjectsPlaced: placeCount,
                     touchedGraphic: touchedGraphic)

    }
}


extension Graphic: PlaygroundValueTransformable {
    
    public var playgroundValue: PlaygroundValue? {
        var info = [String : PlaygroundValue]()
        info["id"] = id.playgroundValue
        info["position"] = CGPoint(position).playgroundValue
        info["rotation"] = rotationRadians.playgroundValue
        info["scale"] = scale.double.playgroundValue
        info["text"] = text.playgroundValue
        info["alpha"] = alpha.double.playgroundValue
        
        return .dictionary(info)
    }
    
    public static func from<T>(_ playgroundValue: PlaygroundValue) ->T? {
        
        guard case .dictionary(let info) = playgroundValue else { return nil }
        
        var graphic: Graphic? = nil
        
        if let value = info["id"] {
            guard let id = String.from(value) as? String else { return nil }
            graphic = Graphic(id: id)
        }
        graphic?.suppressMessageSending = true
        
        if let value = info["position"], let position = CGPoint.from(value) as? CGPoint {
            graphic?.position = Point(position)
        }

        if let value = info["rotation"], let rotation = CGFloat.from(value) as? CGFloat {
            graphic?.rotationRadians = rotation
        }

        if let value = info["scale"], let scale = Double.from(value) as? Double {
            graphic?.scale = scale
        }

        if let value = info["text"], let text = String.from(value) as? String {
            graphic?.text = text
        }

        if let value = info["alpha"], let alpha = Double.from(value) as? Double {
            graphic?.alpha = alpha.double
        }
        graphic?.suppressMessageSending = false
        
        return graphic as? T
    }
}



// PlaygroundValue is used as the value in the dictionary when the underlying type is a collection type: Array, Dictionary.
extension PlaygroundValue: PlaygroundValueTransformable {
    
    public var playgroundValue: PlaygroundValue? {
     
        return self
    }
    
    
    public static func from(_ playgroundValue: PlaygroundValue) -> PlaygroundValueTransformable? {
        switch playgroundValue {
        case .array(let array):
            return PlaygroundValueArray(array: array)
            
        case .dictionary(let dictionary):
            return PlaygroundValueDictionary(dictionary: dictionary)
            
        default:
            return nil
        }
    }
}



public struct PlaygroundValueArray: PlaygroundValueTransformable {
    
    public var array: [PlaygroundValue]? = nil
    
    
    init(array: [PlaygroundValue]) {
        self.array = array
    }
    
    
    init?(playgroundValue: PlaygroundValue) {
        guard case .array(let playgroundValues) = playgroundValue else { return nil }
        array = playgroundValues
    }
    
    
    public static func from(_ playgroundValue: PlaygroundValue) -> PlaygroundValueTransformable? {
        guard case .array(let playgroundValues) = playgroundValue else { return nil }
        
        return PlaygroundValueArray(array: playgroundValues)
    }
    
    
    public var playgroundValue: PlaygroundValue? {
        guard let values = array else { return nil }
        return .array(values)
    }
    
}



public struct PlaygroundValueDictionary: PlaygroundValueTransformable {
    
    public var dictionary: [String : PlaygroundValue]? = nil
    
    
    init(dictionary: [String : PlaygroundValue]) {
        self.dictionary = dictionary
    }
    
    
    init?(playgroundValue: PlaygroundValue) {
        guard case .dictionary(let dictionary) = playgroundValue else { return nil }
        self.dictionary = dictionary
    }
    
    
    public static func from(_ playgroundValue: PlaygroundValue) -> PlaygroundValueTransformable? {
        guard case .dictionary(let dictionary) = playgroundValue else { return nil }
        
        return PlaygroundValueDictionary(dictionary: dictionary)
    }
    
    
    public var playgroundValue: PlaygroundValue? {
        guard let info = dictionary else { return nil }
        return .dictionary(info)
    }
    
}

extension PlaygroundPage.AssessmentStatus: PlaygroundValueTransformable {
    // MARK: Assessment 
    
    public var playgroundValue: PlaygroundValue? {
        let passed: Bool
        let message: String?
        let hints: [String]
        
        switch self {
        case let .pass(success):
            passed = true
            hints = []
            message = success
            
        case let .fail(failureHints, solution):
            passed = false
            hints = failureHints
            message = solution
        }
        
        let hintValues: [PlaygroundValue] = hints.map {
            return .string($0)
        }
        
        var values: [PlaygroundValue] = [.boolean(passed), .array(hintValues)]
        if let message = message {
            values += [.string(message)]
        }
        
        return .array(values)
    }
    
    public static func from(_ playgroundValue: PlaygroundValue) -> PlaygroundValueTransformable? {
        guard case let .array(arr) = playgroundValue else { return nil }
        guard case let .boolean(passed)? = arr.first else { return nil }
        
        if passed {
            var message: String? = nil
            if case let .string(m)? = arr.last {
                message = m
            }
            
            return PlaygroundPage.AssessmentStatus.pass(message: message)
        }
        else {
            var message: String? = nil
            if case let .string(m)? = arr.last {
                message = m
            }
            
            var hints = [String]()
            if arr.count > 2, case let .array(hintValues) = arr[1] {
                hints = hintValues.flatMap { value in
                    guard case let .string(hint) = value else { return nil }
                    return hint
                }
            }
            
            return PlaygroundPage.AssessmentStatus.fail(hints: hints, solution: message)
        }
    }
    
}

extension Overlay: PlaygroundValueTransformable {

    public var playgroundValue: PlaygroundValue? {
        return .integer(rawValue)
    }

    public static func from(_ playgroundValue: PlaygroundValue) -> PlaygroundValueTransformable? {
        guard case .integer(let intValue) = playgroundValue else { return nil }
        return Overlay(rawValue: intValue)
    }
}




