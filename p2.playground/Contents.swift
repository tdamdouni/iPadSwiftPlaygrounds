// https://gist.github.com/fbernardo/9ca8390655392d089c94

import Foundation
import CoreGraphics

// Int & Double

func +(a : Double, b : Int) -> Double {
    return a + Double(b)
}

func +(a : Int, b : Double) -> Double {
    return b + a
}

func *(a : Double, b : Int) -> Double {
    return a * Double(b)
}

func *(a : Int, b : Double) -> Double {
    return b * a
}

func /(a : Double, b : Int) -> Double {
    return a / Double(b)
}

func /(a : Int, b : Double) -> Double {
    return Double(a) / b
}

func -(a : Double, b : Int) -> Double {
    return a - Double(b)
}

func -(a : Int, b : Double) -> Double {
    return Double(a) - b
}

// Int & CGFloat

func +(a : Int, b : CGFloat) -> CGFloat {
    return CGFloat(a) + b
}

func +(a : CGFloat, b : Int) -> CGFloat {
    return a + CGFloat(b)
}

func *(a : CGFloat, b : Int) -> CGFloat {
    return a * CGFloat(b)
}

func *(a : Int, b : CGFloat) -> CGFloat {
    return b * a
}

func /(a : CGFloat, b : Int) -> CGFloat {
    return a / CGFloat(b)
}

func /(a : Int, b : CGFloat) -> CGFloat {
    return CGFloat(a) / b
}

func -(a : CGFloat, b : Int) -> CGFloat {
    return a - CGFloat(b)
}

func -(a : Int, b : CGFloat) -> CGFloat {
    return CGFloat(a) - b
}

// CGFloat & Double

func +(a : Double, b : CGFloat) -> CGFloat {
    return CGFloat(a) + b
}

func +(a : CGFloat, b : Double) -> CGFloat {
    return a + CGFloat(b)
}

func *(a : CGFloat, b : Double) -> CGFloat {
    return a * CGFloat(b)
}

func *(a : Double, b : CGFloat) -> CGFloat {
    return b * a
}

func /(a : CGFloat, b : Double) -> CGFloat {
    return a / CGFloat(b)
}

func /(a : Double, b : CGFloat) -> CGFloat {
    return CGFloat(a) / b
}

func -(a : CGFloat, b : Double) -> CGFloat {
    return a - CGFloat(b)
}

func -(a : Double, b : CGFloat) -> CGFloat {
    return CGFloat(a) - b
}







let aFloat : CGFloat = 3
let aDouble : Double = 3
let anInt : Int = 3

let result = anInt + aFloat + aDouble // 9 : CGFloat
