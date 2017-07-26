// 
//  AssessmentInfo.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//

import Foundation
import CoreGraphics
import UIKit



public enum AssessmentTrigger {
    case start(context: AssessmentInfo.Context)
    case stop
    case evaluate
}


extension AssessmentTrigger: RawRepresentable {
    public typealias RawValue = [Int]

    public init?(rawValue: RawValue) {
        guard rawValue.count > 0 else { return nil }
        
        switch rawValue[0] {
        case 0:
            guard
                rawValue.count > 1,
                let context = AssessmentInfo.Context(rawValue: rawValue[1])
                else { return nil }
            self = .start(context: context)
            
        case 1:
            self = .stop
            
        case 2:
            self = .evaluate
            
        default:
            return nil
        }
    }
    
    
    public var rawValue: RawValue {
        var value = [Int]()
        switch self {
        case .start(let context):
            value.append(0)
            value.append(context.rawValue)
            
        case .stop:
            value.append(1)
            
        case .evaluate:
            value.append(2)
        }

        return value
    }

}

public enum AssessmentEvent {
    
    // Graphic
    case setFontName(graphic: Graphic, name:String)
    case setFontSize(graphic: Graphic, size:Number)
    case setTextColor(graphic: Graphic, color: Color)
    case createStringGraphic(graphic: Graphic, String)
    case createImageGraphic(graphic: Graphic, Image)
    case setHidden(graphic: Graphic, Bool)
    case setAlpha(graphic: Graphic, alpha: Number)
    case setRotation(graphic: Graphic, angle: Number)
    case moveTo(graphic: Graphic, position: Point)
    case moveBy(graphic: Graphic, x: Number, y: Number)
    case setImage(graphic: Graphic, Image)
    case remove(graphic: Graphic)
    case orbit(graphic: Graphic, x: Number, y: Number, period: Number)
    case spin(graphic: Graphic, period: Number)
    case pulsate(graphic: Graphic, period: Number, count: Number)
    case moveAndZap(graphic: Graphic, position: Point)
    case swirlAway(graphic: Graphic, after: Number)
    
    // Audio
    case speak(text: String)
    case playSound(sound: Sound, volume: Number)
    case playInstrument(instrumentKind: Instrument.Kind, note: Number, volume: Number)

    // Scene
    case setSceneBackgroundImage(Image?)
    case print(graphic: Graphic)
    case placeAt(graphic: Graphic, position: Point)

}


public struct AssessmentInfo {
    
    public enum Context: Int {
        case tool
        case button
        case discrete
    }

    public let events: [AssessmentEvent]
    public let context: Context
    public let customInfo: [AnyHashable : Any]
    
    public subscript(key: AnyHashable) -> Any? {
         return customInfo[key]
    }

}


