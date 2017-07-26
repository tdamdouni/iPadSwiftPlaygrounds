// 
//  Number.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
import CoreGraphics

public protocol Number {
    var value: Float { get }
}

extension Number {
    public var int: Int {
        return Int(value)
    }
    
    public var double: Double {
        return Double(value)
    }
    
}

// MARK: Retroactive Modeling

extension Int: Number {
    public var value: Float {
        return Float(self)
    }
}

extension Double: Number {
    public var value: Float {
        return Float(self)
    }
}

// MARK: Number Operators

/// Add addition operator with Number type.
public func +(lhs: Number, rhs: Number) -> Number {
    return Double(lhs.value + rhs.value)
}

public func +=(lhs: inout Number, rhs: Number) {
    lhs = lhs + rhs
}

/// Add subtract operator with Number type.
public func -(lhs: Number, rhs: Number) -> Number {
    return Double(lhs.value - rhs.value)
}

public func -=(lhs: inout Number, rhs: Number) {
    lhs = lhs - rhs
}

/// Add multiplication operator with Number type.
public func *(lhs: Number, rhs: Number) -> Number {
    return Double(lhs.value * rhs.value)
}

public func *=(lhs: inout Number, rhs: Number) {
    lhs = lhs * rhs
}

/// Add divide operator with Number type.
public func /(lhs: Number, rhs: Number) -> Number {
    return Double(lhs.value / rhs.value)
}

public func /=(lhs: inout Number, rhs: Number) {
    lhs = lhs / rhs
}

/// Add modulo operator with Number type.
public func %(lhs: Number, rhs: Number) -> Number {
    return lhs.int % rhs.int
}

public func ==(lhs: Number, rhs: Number) -> Bool {
    return lhs.value == rhs.value
}

public func !=(lhs: Number, rhs: Number) -> Bool {
    return lhs.value != rhs.value
}

prefix public func -(base: Number) -> Number {
    return Double(-base.value)
}

// MARK: Comparision Operators

public func <(lhs: Number, rhs: Number) -> Bool {
    return lhs.value < rhs.value
}

public func >(lhs: Number, rhs: Number) -> Bool {
    return lhs.value > rhs.value
}

public func <=(lhs: Number, rhs: Number) -> Bool {
    return lhs.value <= rhs.value
}

public func >=(lhs: Number, rhs: Number) -> Bool {
    return lhs.value >= rhs.value
}

// MARK: Array Extensions

extension Array {
    subscript(index: Number) -> Element {
        let i = Int(index.value)
        return self[i]
    }
}

// MARK: Trigonometric functions

public func cos(_ n: Number) -> Number {
    return Double(cos(n.value))
}

public func sin(_ n: Number) -> Number {
    return Double(sin(n.value))
}

// MARK: Constants 

// Pi goes global (to avoid having to use Double.pi)
public let pi: Number = Double.pi

