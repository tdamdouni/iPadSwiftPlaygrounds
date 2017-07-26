// 
//  Button.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//

import UIKit

/// A button that can execute your code when tapped.
public class Button {
    
    /// The display name of the button.
    public var name: String
    
    /// The function that will be called when you tap the button.
    public var onTap: (() -> Void)?

    /// Creates a button with a name and an optional one character emoji icon.
    public init(name:  String) {
        self.name = name        
    }

}
