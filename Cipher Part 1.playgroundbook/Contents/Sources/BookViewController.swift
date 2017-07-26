//
//  BookViewController.swift
//
//  Copyright © 2017 Apple Inc. All rights reserved.
//

import UIKit
import PlaygroundSupport

@objc(BookViewController)
public class BookViewController: UIViewController, PlaygroundLiveViewSafeAreaContainer {
    
    // MARK: Strings for the "Cryptography Intro" Live View
    
    private let titleText = NSLocalizedString("Introduction to Cryptography", comment: "Intro title")
    
    // MARK: Properties
    
    @IBOutlet weak var libraryImageView: UIImageView!
    @IBOutlet weak var paragraphOneLabel: UILabel!
    @IBOutlet weak var textContainerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bookImageView: UIImageView!
    
    // MARK: Constraints
    
    @IBOutlet weak var textLabelLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var textLabelTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var textLabelBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var textToTitleConstraint: NSLayoutConstraint!
    
    // MARK: View Controller Lifecycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = titleText
        setupAttributedStrings()
    }
    
    public override func viewDidLayoutSubviews() {
        resetConstraintsForViewSize()
    }
    
    public override func updateViewConstraints() {
        resetConstraintsForViewSize()
        super.updateViewConstraints()
    }
    
    // MARK: Custom Methods
    
    fileprivate func showOpenBook() {
        libraryImageView.isHidden = true
    }
    
    private func setupAttributedStrings() {
        let textSize = paragraphOneLabel.font.pointSize
        let attributeBold = [NSFontAttributeName: UIFont.boldSystemFont(ofSize: textSize)]
        let attributeItalic = [NSFontAttributeName: UIFont.italicSystemFont(ofSize: textSize)]
        
        // Attributed words
        let boldCrypto = NSAttributedString(string: "cryptography", attributes: attributeBold)
        let italicKrypto = NSAttributedString(string: "κρψπτο", attributes: attributeItalic)
        let boldSecret = NSAttributedString(string: "secret", attributes: attributeBold)
        let boldHidden = NSAttributedString(string: "hidden", attributes: attributeBold)
        let italicGraphe = NSAttributedString(string: "γραφη", attributes: attributeItalic)
        let boldWriting = NSAttributedString(string: "writing", attributes: attributeBold)
        
        // Building the attributed string
        let finalString = NSMutableAttributedString(string: "The word ")
        finalString.append(boldCrypto)
        finalString.append(NSAttributedString(string: " comes from the Greek words "))
        finalString.append(italicKrypto)
        finalString.append(NSAttributedString(string: " (krypto), meaning "))
        finalString.append(boldSecret)
        finalString.append(NSAttributedString(string: " or "))
        finalString.append(boldHidden)
        finalString.append(NSAttributedString(string: ", and "))
        finalString.append(italicGraphe)
        finalString.append(NSAttributedString(string: " (graphe), meaning "))
        finalString.append(boldWriting)
        finalString.append(NSAttributedString(string: ". Cryptography is the practice of concealing messages so they can’t be read by anyone who doesn’t have the key.\n\nCryptography has been used throughout history to create secret messages, especially during wartime. The Roman general Julius Caesar was famous for using a substitution cipher with a shift of 3 to keep his important messages secret.\n\nMuch later, in the Second World War, the Germans used the Enigma machine to create ciphers. It took a team of mathematicians, cryptographers, and scientists many years to break Enigma's encryptions.\n\nWith the rise of computers that can do thousands of computations and encryptions in seconds, most of the earliest ciphers are no longer in active use. However, it’s still important to learn them, because many represent the basic building blocks of today’s cryptosystems."))
        
        paragraphOneLabel.attributedText = finalString
    }
    
    private func resetConstraintsForViewSize() {
        let currentWidth = liveViewSafeAreaGuide.layoutFrame.width
        let currentHeight = liveViewSafeAreaGuide.layoutFrame.height
        var originalLeading: CGFloat = 0
        var originalTrailing: CGFloat = 0
        var originalHeight: CGFloat = 0
        var originalWidth: CGFloat = 0
        var heightScaleFactor: CGFloat = 1
        var widthScaleFactor: CGFloat = 1
        var originalTextLabelBottom: CGFloat = 0
        let originalTextToTitle: CGFloat = 4
        
        // Portrait
        if currentHeight > currentWidth {
            originalHeight = 1366
            originalWidth = 1024
            originalTextLabelBottom = 375
            originalLeading = 135
            originalTrailing = 150
        } else {
            // Landscape
            originalHeight = 1024
            originalWidth = 1366
            originalTextLabelBottom = 290
            originalLeading = 175
            originalTrailing = 175
        }
        
        heightScaleFactor = currentHeight / originalHeight
        widthScaleFactor = currentWidth / originalWidth
        
        textLabelLeadingConstraint.constant = originalLeading * widthScaleFactor
        textLabelTrailingConstraint.constant = originalTrailing * widthScaleFactor
        textLabelBottomConstraint.constant = originalTextLabelBottom * heightScaleFactor
        titleTopConstraint.constant = liveViewSafeAreaGuide.layoutFrame.minY == 0 ? 70 : liveViewSafeAreaGuide.layoutFrame.minY
        textToTitleConstraint.constant = originalTextToTitle * heightScaleFactor
        
        view.setNeedsUpdateConstraints()
    }
}

extension BookViewController: PlaygroundLiveViewMessageHandler {
    public func receive(_ message: PlaygroundValue) {
        switch message {
        case .string(let messageString):
            if messageString == Constants.playgroundMessageKeyOpenBook {
                showOpenBook()
            }
        default:
            return
        }
    }
}
