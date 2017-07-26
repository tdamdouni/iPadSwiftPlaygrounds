//
//  ShiftingPracticeViewController.swift
//
//  Copyright © 2017 Apple Inc. All rights reserved.
//

import UIKit
import PlaygroundSupport

@objc(ShiftingPracticeViewController)
public class ShiftingPracticeViewController: UIViewController, PlaygroundLiveViewSafeAreaContainer {
    
    // MARK: Properties
    
    @IBOutlet weak var inputLabel: UILabel!
    @IBOutlet weak var shiftLabel: UILabel!
    @IBOutlet weak var outputLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noteView: UIView!
    
    fileprivate let cellId = "basicCell"
    fileprivate var currentShift = 0
    fileprivate var currentWord = ""
    fileprivate let tableHeaderHeight: CGFloat = 32
    
    // Constraints
    @IBOutlet weak var noteLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var noteTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var inputLabelTopConstraint: NSLayoutConstraint!
    
    // MARK: View Controller Lifecycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        // Removes lines in empty cells at the bottom of the tableView
        tableView.tableFooterView = UIView()
    }
    
    public override func updateViewConstraints() {
        resetConstraintsForViewSize()
        super.updateViewConstraints()
    }
    
    public override func viewDidLayoutSubviews() {
        resetConstraintsForViewSize()
    }
    
    // MARK: Custom Methods
    
    private func resetConstraintsForViewSize() {
        let currentWidth = liveViewSafeAreaGuide.layoutFrame.width
        let currentHeight = liveViewSafeAreaGuide.layoutFrame.height
        var originalNoteLeading: CGFloat = 0
        var originalNoteTrailing: CGFloat = 0
        var widthScaleFactor: CGFloat = 1
        var heightScaleFactor: CGFloat = 1
        var originalWidth: CGFloat = 0
        var originalHeight: CGFloat = 0
        var originalTableHeight: CGFloat = 0
        
        // Portrait
        if currentHeight > currentWidth {
            originalWidth = 1024
            originalHeight = 1366
            originalTableHeight = 900
            originalNoteLeading = 125
            originalNoteTrailing = 125
        } else {
            // Landscape
            originalWidth = 1366
            originalHeight = 1024
            originalTableHeight = 600
            originalNoteLeading = 150
            originalNoteTrailing = 150
        }
        
        heightScaleFactor = currentHeight / originalHeight
        widthScaleFactor = currentWidth / originalWidth
        
        noteLeadingConstraint.constant = originalNoteLeading * widthScaleFactor
        noteTrailingConstraint.constant = originalNoteTrailing * widthScaleFactor
        tableViewHeightConstraint.constant = originalTableHeight * heightScaleFactor
        inputLabelTopConstraint.constant = liveViewSafeAreaGuide.layoutFrame.minY + 24
        
        view.setNeedsUpdateConstraints()
    }
    
    fileprivate func updateUI() {
        // Hide the noteView now that they've started shifting
        noteView.isHidden = true
        
        inputLabel.text = currentWord
        shiftLabel.text = String(currentShift)
        outputLabel.text = CipherContent.shift(inputText: currentWord, by: currentShift)
        tableView.reloadData()
        tableView.reloadSections(IndexSet(integer: 0) as IndexSet, with: UITableViewRowAnimation.fade)
    }
}

extension ShiftingPracticeViewController: PlaygroundLiveViewMessageHandler {
    public func receive(_ message: PlaygroundValue) {
        switch message {
        case .dictionary(let shiftDict):
            guard case let .integer(shift)? = shiftDict[Constants.playgroundMessageKeyShift], case let .string(word)? = shiftDict[Constants.playgroundMessageKeyWord] else { return }
            currentWord = word
            currentShift = shift
            updateUI()
        default:
            return
        }
    }
}

extension ShiftingPracticeViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return tableHeaderHeight
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size:  CGSize(width: tableView.frame.width, height: tableHeaderHeight)))
        headerView.backgroundColor = #colorLiteral(red: 0.156701833, green: 0.1675018072, blue: 0.2093972862, alpha: 1)
        
        let headerLabel = UILabel()
        headerLabel.text = NSLocalizedString("Processing shifts…", comment: "Shifting table header text.")
        headerLabel.textColor = #colorLiteral(red: 0.2048710883, green: 0.8790110946, blue: 0.205568701, alpha: 1)
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.7, delay: 0, options: [.curveEaseInOut, .repeat, .autoreverse], animations: {
                UIView.setAnimationRepeatCount(5.0)
                headerLabel.alpha = 0.0
            }, completion:  { completed in
                if completed {
                    headerLabel.alpha = 1.0
                    headerLabel.text = NSLocalizedString("Finished Processing", comment: "Shifting table header text.")
                }
            })
        }
        
        let views: [String: AnyObject] = ["header":headerLabel]
        let metrics: [String: AnyObject] = [:]
        headerView.addSubview(headerLabel)
        
        headerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[header]|", options: [], metrics: metrics, views: views))
        headerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-12-[header]|", options: [], metrics: metrics, views: views))
        
        return headerView
    }
}

extension ShiftingPracticeViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return abs(currentShift) + 1 //to acount for 0 shift
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
        cell.selectionStyle = .none
        let shiftString = NSLocalizedString("Shift", comment: "Shift string")
        var displayShift = 0
        if currentShift >= 0 {
            displayShift = indexPath.row
        } else {
            displayShift = -indexPath.row
        }
        
        cell.textLabel?.text = "\(shiftString) \(displayShift):"
        cell.detailTextLabel?.text = CipherContent.shift(inputText: currentWord, by: displayShift)
        
        return cell
    }
}
