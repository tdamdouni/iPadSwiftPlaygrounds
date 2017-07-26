//
//  CGPathExtensions.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//

import CoreGraphics

struct PathElement {
    var type : CGPathElementType
    var points : Array<CGPoint>
}

extension CGPath {
    typealias BodyType = @convention(block) (CGPathElement) -> Void
    
    // Get the actual points in the path
    func points() -> Array<CGPoint> {
        var bezierPoints = Array<CGPoint>()
        self.forEach{ (element: CGPathElement) in
            let numberOfPoints: Int = {
                switch element.type {
                case .moveToPoint, .addLineToPoint:
                    return 1
                case .addQuadCurveToPoint:
                    return 2
                case .addCurveToPoint:
                    return 3
                case .closeSubpath:
                    return 0
                }
            }()
            for index in 0..<numberOfPoints {
                let point = element.points[index]
                bezierPoints.append(point)
            }
        }
        
        return bezierPoints
    }
    
    // Get just the elements, preserves path element type
    func pathElements() -> Array<PathElement> {
        var elements = Array<PathElement>()
        self.forEach { (element: CGPathElement) in
            // CGPathElements are only valid in the context of the apply() function. We need to exfiltrate their values to properly access them later.
            let pe = PathElement(type: element.type, points: Array<CGPoint>(arrayLiteral:element.points[0]))
            elements.append(pe)
        }
        return elements
    }
    
    private func forEach(_ body: BodyType) {
        func callback(info: UnsafeMutableRawPointer?, element: UnsafePointer<CGPathElement>) {
            let body = unsafeBitCast(info, to: BodyType.self)
            body(element.pointee)
        }
        let unsafeBody = unsafeBitCast(body, to: UnsafeMutableRawPointer.self)
        self.apply(info: unsafeBody, function: callback)
    }
}

extension CGPoint : Hashable {
    public var hashValue: Int {
        get {
            return "{\(self.x),\(self.y)}".hashValue
        }
    }
}
