// 
//  TransformUtils.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//

import Foundation
import SceneKit

extension CATransform3D {
    var scnMatrix4 : SCNMatrix4  {
        var m = SCNMatrix4Identity
        m.m11 = Float(self.m11)
        m.m12 = Float(self.m12)
        m.m13 = Float(self.m13)
        m.m14 = Float(self.m14)
        m.m21 = Float(self.m21)
        m.m22 = Float(self.m22)
        m.m23 = Float(self.m23)
        m.m24 = Float(self.m24)
        m.m31 = Float(self.m31)
        m.m32 = Float(self.m32)
        m.m33 = Float(self.m33)
        m.m34 = Float(self.m34)
        m.m41 = Float(self.m41)
        m.m42 = Float(self.m42)
        m.m43 = Float(self.m43)
        m.m44 = Float(self.m44)
        return m
    }
}

extension SCNMatrix4 {
    var caTransform3D : CATransform3D  {
        var m = CATransform3DIdentity
        m.m11 = CGFloat(self.m11)
        m.m12 = CGFloat(self.m12)
        m.m13 = CGFloat(self.m13)
        m.m14 = CGFloat(self.m14)
        m.m21 = CGFloat(self.m21)
        m.m22 = CGFloat(self.m22)
        m.m23 = CGFloat(self.m23)
        m.m24 = CGFloat(self.m24)
        m.m31 = CGFloat(self.m31)
        m.m32 = CGFloat(self.m32)
        m.m33 = CGFloat(self.m33)
        m.m34 = CGFloat(self.m34)
        m.m41 = CGFloat(self.m41)
        m.m42 = CGFloat(self.m42)
        m.m43 = CGFloat(self.m43)
        m.m44 = CGFloat(self.m44)
        return m
    }
}

extension CGFloat {
    var degrees: CGFloat { return self * CGFloat(π)/180 }
}

extension Float {
    var degrees: Float { return self * π/180 }
}

extension Int {
    var cgFloat: CGFloat { return CGFloat(self) }
}

extension Float {
    var cgFloat: CGFloat { return CGFloat(self) }
}

extension Double {
    var cgFloat: CGFloat { return CGFloat(self) }
}
