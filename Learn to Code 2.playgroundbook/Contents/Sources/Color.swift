//
//  Color.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//

#if os(iOS)
import UIKit
typealias _Color = UIColor
#elseif os(OSX)
import AppKit
typealias _Color = NSColor
#endif

public final class Color: _ExpressibleByColorLiteral, Equatable {
    // MARK: Properties
    
    let rawValue: _Color
    
    public static let clear:Color = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
    
    public static let white:Color = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    public static let gray:Color = #colorLiteral(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
    public static let black:Color = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    
    public static let orange:Color = #colorLiteral(red: 0.9, green: 0.47, blue: 0.09, alpha: 1)
    public static let blue:Color = #colorLiteral(red: 0.26, green: 0.58, blue: 0.97, alpha: 1)
    public static let green:Color = #colorLiteral(red: 0.37, green: 0.72, blue: 0.2, alpha: 1)
    public static let yellow:Color = #colorLiteral(red: 0.95, green: 0.8, blue: 0.12, alpha: 1)
    public static let red:Color = #colorLiteral(red: 0.73, green: 0.071, blue: 0.04, alpha: 1)
    public static let purple:Color = #colorLiteral(red: 0.38, green: 0.16, blue: 0.54, alpha: 1)
    public static let pink:Color = #colorLiteral(red: 1, green: 0, blue: 1, alpha: 1)
    
    var cgColor: CGColor {
        return rawValue.cgColor
    }
    
    // MARK: Initialization
    
    init(_ color: _Color) {
        self.rawValue = color
    }

    public init(white: CGFloat, alpha: CGFloat = 1.0) {
        rawValue = _Color(white: white, alpha: alpha)
    }
    
    public init(hue: Double, saturation: Double, brightness: Double, alpha: Double = 1.0) {
        rawValue = _Color(hue: CGFloat(hue), saturation: CGFloat(saturation), brightness: CGFloat(brightness), alpha: CGFloat(alpha))
    }
    
    public init(red: Double, green: Double, blue: Double, alpha: Double = 1.0) {
        rawValue = _Color(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: CGFloat(alpha))
    }
    
    public convenience required init(colorLiteralRed red: Float, green: Float, blue: Float, alpha: Float) {
        self.init(red: Double(red), green: Double(green), blue: Double(blue), alpha: Double(alpha))
    }
 
    public func lighter(_ percent: Double = 0.2) -> Color {
        return colorByAdjustingBrightness(1 + percent)
    }
    
    public func darker(_ percent: Double = 0.2) -> Color {
        return colorByAdjustingBrightness(1 - percent)
    }
    
    private func colorByAdjustingBrightness(_ percent: Double) -> Color {
        var cappedPercent = min(percent, 1.0)
        cappedPercent = max(0.0, percent)
        
        var hue: CGFloat = 0.0
        var saturation: CGFloat = 0.0
        var brightness: CGFloat = 0.0
        var alpha: CGFloat = 0.0
        self.rawValue.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        
        return Color(hue: Double(hue), saturation: Double(saturation), brightness: Double(brightness) * cappedPercent, alpha: Double(alpha))
    }
    
    public static func random() -> Color {
        let uint32MaxAsFloat = Float(UInt32.max)
        let red = Double(Float(arc4random()) / uint32MaxAsFloat)
        let blue = Double(Float(arc4random()) / uint32MaxAsFloat)
        let green = Double(Float(arc4random()) / uint32MaxAsFloat)
        
        return Color(red: red, green: green, blue: blue, alpha: 1.0)
    }
}

public func ==(left: Color, right: Color) -> Bool {
    return left.rawValue == right.rawValue
}
