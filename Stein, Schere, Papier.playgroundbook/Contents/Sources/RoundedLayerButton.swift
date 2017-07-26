//
//  RoundedLayerButton.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//

import UIKit

class RoundedLayerButton: UIButton {
    
    let backgroundLayer = CAShapeLayer()

    init(type buttonType: UIButtonType) {
        super.init(frame: CGRect.zero)
        
        guard let titleLabel = titleLabel else {
            return
        }
        
        layer.insertSublayer(backgroundLayer, below: titleLabel.layer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("\(#function) has not been implemented.")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        backgroundLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: (bounds.size.height * 0.3)).cgPath
    }
}
