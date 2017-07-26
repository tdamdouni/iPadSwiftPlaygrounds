//
//  UIViewController+StoryboardInit.swift
//
//  Copyright © 2017 Apple Inc. All rights reserved.
//

import UIKit

extension UIViewController {
    
    public static func instantiateFromMainStoryboard<T>() -> T {
        let bundle = Bundle(for: T.self as! AnyClass)
        let storyboard = UIStoryboard(name: "Cipher", bundle: bundle)
        let identifier = String(describing: self)
        
        return storyboard.instantiateViewController(withIdentifier: identifier) as! T
    }
    
}
