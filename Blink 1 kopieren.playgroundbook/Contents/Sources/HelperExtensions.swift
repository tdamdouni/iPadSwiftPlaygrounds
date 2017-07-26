// 
//  HelperExtensions.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//

extension Int {
    func clamped(to range: ClosedRange<Int>) -> Int {
        return clamped(min: range.lowerBound, max: range.upperBound)
    }
    
    func clamped(min: Int, max: Int) -> Int {
        return Swift.max(min, Swift.min(max, self))
    }
}
