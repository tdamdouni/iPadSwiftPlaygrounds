// 
//  RoundedVisualEffectView.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//

import UIKit

@objc(RoundedVisualEffectView)
class RoundedVisualEffectView: UIVisualEffectView {
    
    var cornerRadius: CGFloat = 22
        
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = cornerRadius
        clipsToBounds = true
    }
}
