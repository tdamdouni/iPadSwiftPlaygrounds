//
//  Int+OddEven.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//

import Foundation

public extension Int {
    public var isOdd: Bool {
        return (self % 2) == 1
    }
    
    public var isEven: Bool {
        return !isOdd
    }
}
