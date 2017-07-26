//
//  FoldedNoteViewController.swift
//
//  Copyright © 2017 Apple Inc. All rights reserved.
//

import UIKit
import PlaygroundSupport

@objc(FoldedNoteViewController)
public class FoldedNoteViewController: UIViewController, PlaygroundLiveViewMessageHandler, PlaygroundLiveViewSafeAreaContainer {

    // MARK: Strings for the "Substitution Ciphers" page
    
    let titleText = NSLocalizedString("Substitution Ciphers", comment: "Title label")
    
    // MARK: Properties
    
    @IBOutlet weak var unfoldedNoteView: UIView!
    @IBOutlet weak var paragraphOneLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: Constraints
    
    // Substitution Page Constraints
    @IBOutlet weak var textLabelLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var textLabelTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var noteBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var noteHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var diagramHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var diagramToTitleConstraint: NSLayoutConstraint!
    @IBOutlet weak var textToDiagramConstraint: NSLayoutConstraint!
    // Note Constraints
    @IBOutlet weak var noteLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var noteTrailingConstraint: NSLayoutConstraint!
    
    // MARK: View Controller Lifecycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAttributedStrings()
        titleLabel.text = titleText
    }
    
    public override func updateViewConstraints() {
        resetConstraintsForViewSize()
        super.updateViewConstraints()
    }
    
    public override func viewDidLayoutSubviews() {
        resetConstraintsForViewSize()
    }
    
    // MARK: Custom Methods
    
    private func setupAttributedStrings() {
        let textSize = paragraphOneLabel.font.pointSize
        let attributeBold = [NSFontAttributeName: UIFont.boldSystemFont(ofSize: textSize)]
        
        // Attributed words
        let boldSubstituted = NSAttributedString(string: "substituted", attributes: attributeBold)
        let boldShift = NSAttributedString(string: "shift", attributes: attributeBold)
        let boldBed = NSAttributedString(string: "BED", attributes: attributeBold)
        let boldEhg = NSAttributedString(string: "EHG", attributes: attributeBold)
        let boldB = NSAttributedString(string: "B", attributes: attributeBold)
        let boldE = NSAttributedString(string: "E", attributes: attributeBold)
        let boldD = NSAttributedString(string: "D", attributes: attributeBold)
        let boldH = NSAttributedString(string: "H", attributes: attributeBold)
        let boldG = NSAttributedString(string: "G", attributes: attributeBold)
        let boldKey = NSAttributedString(string: "key", attributes: attributeBold)
        let boldBackward = NSAttributedString(string: "backward", attributes: attributeBold)
        
        // Building the attributed string
        let finalString = NSMutableAttributedString(string: "A substitution cipher is one in which each letter of the message is ")
        finalString.append(boldSubstituted)
        finalString.append(NSAttributedString(string: " (or exchanged) for a different letter to hide the original meaning.\n\nTo encrypt a message, you choose a number from 1 to 26, and "))
        finalString.append(boldShift)
        finalString.append(NSAttributedString(string: " (or move) every letter in the message over in the alphabet by that number of places. For example, with a shift of 3, "))
        finalString.append(boldBed)
        finalString.append(NSAttributedString(string: " becomes "))
        finalString.append(boldEhg)
        finalString.append(NSAttributedString(string: ".\n\n"))
        finalString.append(boldB)
        finalString.append(NSAttributedString(string: " ➝ "))
        finalString.append(boldE)
        finalString.append(NSAttributedString(string: "\n"))
        finalString.append(boldE)
        finalString.append(NSAttributedString(string: " ➝ "))
        finalString.append(boldH)
        finalString.append(NSAttributedString(string: "\n"))
        finalString.append(boldD)
        finalString.append(NSAttributedString(string: " ➝ "))
        finalString.append(boldG)
        finalString.append(NSAttributedString(string: "\n\nTo decrypt the message, you take the shift value (sometimes called the "))
        finalString.append(boldKey)
        finalString.append(NSAttributedString(string: ") used to  encrypt the message, and count "))
        finalString.append(boldBackward)
        finalString.append(NSAttributedString(string: " through the alphabet by that number of letters."))
        
        paragraphOneLabel.attributedText = finalString
    }

    private func resetConstraintsForViewSize() {
        let currentWidth = liveViewSafeAreaGuide.layoutFrame.width
        let currentHeight = liveViewSafeAreaGuide.layoutFrame.height
        // Substitution Page
        let originalNoteHeight: CGFloat = 225
        let originalDiagramHeight: CGFloat = 162
        var originalLeading: CGFloat = 0
        var originalTrailing: CGFloat = 0
        var originalHeight: CGFloat = 0
        var originalWidth: CGFloat = 0
        var originalBottom: CGFloat = 0
        var heightScaleFactor: CGFloat = 1
        var widthScaleFactor: CGFloat = 1
        let originalTitleTop: CGFloat = 50
        let originalDiagramToTitle: CGFloat = 12
        let originalTextToDiagram: CGFloat = 12
        // Note 
        var originalNoteLeading: CGFloat = 0
        var originalNoteTrailing: CGFloat = 0
        
        // Portrait
        if currentHeight > currentWidth {
            originalHeight = 1366
            originalWidth = 1024
            originalBottom = 230
            originalLeading = 150
            originalTrailing = 135
            originalNoteLeading = 125
            originalNoteTrailing = 125
        } else {
        // Landscape
            originalHeight = 1024
            originalWidth = 1366
            originalBottom = 158
            originalLeading = 175
            originalTrailing = 175
            originalNoteLeading = 150
            originalNoteTrailing = 150
        }
        
        heightScaleFactor = currentHeight / originalHeight
        widthScaleFactor = currentWidth / originalWidth
        
        textLabelLeadingConstraint.constant = originalLeading * widthScaleFactor
        textLabelTrailingConstraint.constant = originalTrailing * widthScaleFactor
        noteHeightConstraint.constant = originalNoteHeight * heightScaleFactor
        noteBottomConstraint.constant = originalBottom * heightScaleFactor
        diagramHeightConstraint.constant = originalDiagramHeight * heightScaleFactor
        titleTopConstraint.constant = liveViewSafeAreaGuide.layoutFrame.minY == 0 ? 70 : liveViewSafeAreaGuide.layoutFrame.minY
        diagramToTitleConstraint.constant = originalDiagramToTitle * heightScaleFactor
        textToDiagramConstraint.constant = originalTextToDiagram * heightScaleFactor
        noteLeadingConstraint.constant = originalNoteLeading * widthScaleFactor
        noteTrailingConstraint.constant = originalNoteTrailing * widthScaleFactor
        
        view.setNeedsUpdateConstraints()
    }
    
    // MARK: IBAction Methods

    @IBAction func openNote() {
        unfoldedNoteView.isHidden = false
        // Send it back to the Contents.swift class so it can correctly register assessment
        send(.string(Constants.playgroundMessageKeyOpenNote))
    }
    
    @IBAction func backToBook(_ sender: UIButton) {
        unfoldedNoteView.isHidden = true
    }
}
