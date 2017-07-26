//
//  PageSupport.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//

import PlaygroundSupport

// Use a typealias to refer to the Actor type as Character.
public typealias Character = Actor

// MARK: Alerts

#if os(iOS)
import UIKit

func presentAlert(title: String, message: String) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .`default`, handler: nil))
    
    let vc = UIViewController()
    PlaygroundPage.current.liveView = vc
    vc.present(alert, animated: true, completion: nil)
}
#elseif os(OSX)
import AppKit

func presentAlert(title: String, message: String) {
    let alert = NSAlert()
    alert.addButton(withTitle: "OK")
    alert.messageText = title + "\n" + message
    alert.runModal()
}
#endif
