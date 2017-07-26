// 
//  Edge.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//

import Foundation

public struct Edge: OptionSet {
    public let rawValue: UInt
    
    public init(rawValue: UInt) {
        self.rawValue = rawValue
    }
    
    public static var top = Edge(rawValue: 1 << 0)
    public static var left = Edge(rawValue: 1 << 1)
    public static var bottom = Edge(rawValue: 1 << 2)
    public static var right = Edge(rawValue: 1 << 3)
    public static var all = Edge(rawValue: 15) // 1 | 2 | 4 | 8
}
