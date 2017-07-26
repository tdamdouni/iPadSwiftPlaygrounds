//
//  LiveView.swift
//
//  Copyright (c) 2017 Apple Inc. All Rights Reserved.
//

import PlaygroundSupport
import UIKit

let page = PlaygroundPage.current
let bookViewController: BookViewController = BookViewController.instantiateFromMainStoryboard()
page.liveView = bookViewController
    
