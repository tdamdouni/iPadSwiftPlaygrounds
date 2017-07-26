//
//  SubstitutionCipherPageViewController.swift
//
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import UIKit
import PlaygroundSupport

@objc(SubstitutionCipherPageViewController)
class SubstitutionCipherPageViewController: UIViewController {

    // MARK: Properties
    
    @IBOutlet weak var plaintextLabel: UILabel!
    @IBOutlet weak var shiftLabel: UILabel!
    var plaintext = ""
    var pageIndex = 0
    var shiftUsed = 0
    
    // MARK: View Controller LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        plaintextLabel.text = plaintext
        let shiftString = NSLocalizedString("Shift", comment: "Shift string")
        shiftLabel.text = "\(shiftString) \(shiftUsed)"
    }

}
