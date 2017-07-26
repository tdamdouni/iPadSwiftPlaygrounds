//
//  RoundedButton.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//

import UIKit

@objc(RoundedButton)
class RoundedButton: UIButton {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        layer.cornerRadius = 8.0
        layer.masksToBounds = true
    }
}
