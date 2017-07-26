//
//  ActionCollectionViewCell.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//

import UIKit

class ActionCollectionViewCell: UICollectionViewCell {
    
    let actionView = ActionView(frame: CGRect.zero)
    
    var action = Action() {
        didSet {
            actionView.action = action
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(actionView)
        actionView.translatesAutoresizingMaskIntoConstraints = false
        actionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        actionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        actionView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        actionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("\(#function) has not been implemented.")
    }
}
