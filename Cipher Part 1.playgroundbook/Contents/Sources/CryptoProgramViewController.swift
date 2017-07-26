//
//  CryptoProgramViewController.swift
//
//  Copyright © 2017 Apple Inc. All rights reserved.
//

import UIKit
import PlaygroundSupport

@objc(CryptoProgramViewController)
public class CryptoProgramViewController: UIViewController, PlaygroundLiveViewSafeAreaContainer {

    // MARK: Properties
    
    @IBOutlet weak var topTextViewLabel: UILabel!
    @IBOutlet weak var topTextView: UITextView!
    
    @IBOutlet weak var shiftTextField: UITextField!
    @IBOutlet weak var bottomTextViewLabel: UILabel!
    @IBOutlet weak var bottomTextView: UITextView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    fileprivate var currentShift: Int = 0 {
        didSet {
            bottomTextView.text = shiftText(inputText: topTextView.text, by: currentShift)
        }
    }
    private var encrypting = true
    private let plaintextString = NSLocalizedString("Plaintext", comment:"Plaintext segmented control title")
    private let ciphertextString = NSLocalizedString("Ciphertext", comment:"Ciphertext segmented control title")
    
    // Constraints
    @IBOutlet weak var segmentedControlTopConstraint: NSLayoutConstraint!
    
    // MARK: View Controller Lifecycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        topTextView.delegate = self
        shiftTextField.delegate = self
        
        topTextView.layer.borderColor = UIColor.gray.cgColor
        topTextView.layer.borderWidth = 2
        bottomTextView.layer.borderColor = UIColor.gray.cgColor
        bottomTextView.layer.borderWidth = 2
        
        // Take bottom layoutGuide into account
        NSLayoutConstraint.activate([
            bottomTextView.bottomAnchor.constraint(equalTo: liveViewSafeAreaGuide.bottomAnchor),
        ])
    }
    
    public override func updateViewConstraints() {
        resetConstraintsForViewSize()
        super.updateViewConstraints()
    }
    
    public override func viewDidLayoutSubviews() {
        resetConstraintsForViewSize()
    }
    
    // MARK: IBAction Methods
    
    // 0 = Encrypt
    // 1 = Decrypt
    @IBAction func encrypterToggled(_ sender: UISegmentedControl) {
        // Switch the text in each box
        let topText = topTextView.text
        let bottomText = bottomTextView.text
        topTextView.text = bottomText
        bottomTextView.text = topText
        
        switch sender.selectedSegmentIndex {
        case 0:
            encrypting = true
            // Switch the box labels
            topTextViewLabel.text = plaintextString
            bottomTextViewLabel.text = ciphertextString
            // Switch the entered text
        case 1:
            encrypting = false
            // Switch the box labels
            topTextViewLabel.text = ciphertextString
            bottomTextViewLabel.text = plaintextString
        default:
            break
        }
    }
    
    // MARK: Custom Methods
    
    private func resetConstraintsForViewSize() {
        segmentedControlTopConstraint.constant = liveViewSafeAreaGuide.layoutFrame.minY + 12
        
        view.setNeedsUpdateConstraints()
    }
    
    fileprivate func shiftText(inputText: String, by: Int) -> String {
        if encrypting {
            return CipherContent.shift(inputText: inputText, by: currentShift)
        } else {
            return CipherContent.shift(inputText: inputText, by: -currentShift)
        }
    }
}

extension CryptoProgramViewController: UITextFieldDelegate {
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard textField == shiftTextField else { return true }
        let currentText = textField.text ?? ""
        let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
        if let shift = Int(newText) {
            currentShift = shift
            return true
        } else if newText.characters.count == 0 || (newText.characters.count == 1 && newText.contains("-")) {
            currentShift = 0
            return true
        } else {
            return false
        }
    }
}

extension CryptoProgramViewController: UITextViewDelegate {
    public func textViewDidChange(_ textView: UITextView) {
        if textView == topTextView {
            bottomTextView.text = shiftText(inputText: topTextView.text, by: currentShift)
        }
    }
}
