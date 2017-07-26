//
//  GradientView.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//

import UIKit

@objc(GradientView)
class GradientView: UIView {
    // MARK: Types
    
    enum Gradient {
        case water, clouds
        
        var colors: [UIColor] {
            switch self {
            case .water:
                return [UIColor(colorLiteralRed: 29.0/255.0, green: 193.0/255.0, blue: 243.0/255.0, alpha: 1.0),
                        UIColor(colorLiteralRed: 14.0/255.0, green: 118.0/255.0, blue: 188.0/255.0, alpha: 1.0)]
                
            case .clouds:
                return [UIColor(colorLiteralRed: 227.0/255.0, green: 183.0/255.0, blue: 213.0/255.0, alpha: 1.0),
                        UIColor(colorLiteralRed: 92.0/255.0, green: 202.0/255.0, blue: 239.0/255.0, alpha: 1.0)]
                    
            }
        }
        
        var startPoint: CGPoint {
            switch self {
            case .water:
                return .zero
                
            case .clouds:
                return .zero
            }
        }
        
        var endPoint: CGPoint {
            switch self {
            case .water:
                return CGPoint(x: 1.0, y: 1.0)
                
            case .clouds:
                return CGPoint(x: 1.0, y: 0.0)
            }
        }
    }
    
    // MARK: Properties
    
    var gradient: Gradient = .water {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        let colors = gradient.colors.map { $0.cgColor }
        let colorSpace = CGColorSpace(name: CGColorSpace.sRGB)!
        let cgGradient = CGGradient(colorsSpace: colorSpace, colors: colors as NSArray as CFArray, locations: [0, 1])!
        
        let startPoint = CGPoint(x: bounds.size.width * gradient.startPoint.x, y: bounds.size.height * gradient.startPoint.y)
        let endPoint = CGPoint(x: bounds.size.width * gradient.endPoint.x, y: bounds.size.height * gradient.endPoint.y)
        
        context.drawLinearGradient(cgGradient, start: startPoint, end: endPoint, options: [])
    }
}
