//
//  UnicodeScalar+Alphabetical.swift
//
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import UIKit

public extension UnicodeScalar {
    public var isAlphabetical: Bool {
        if (self.value >= 65 && self.value <= 90) || (self.value >= 97 && self.value <= 122) {
            return true
        } else {
            return false
        }
    }
    
    public var isLowercase: Bool {
        if (self.value >= 97 && self.value <= 122) {
            return true
        } else {
            return false
        }
    }
}
