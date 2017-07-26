//
//  Int+OddEven.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//

import Foundation

public extension Int {
    /// Returns ``true`` if the Int is odd.
    public var isOdd: Bool {
        return (self % 2) == 1
    }
    /// Returns ``true`` if the Int is even.
    public var isEven: Bool {
        return !isOdd
    }
}
