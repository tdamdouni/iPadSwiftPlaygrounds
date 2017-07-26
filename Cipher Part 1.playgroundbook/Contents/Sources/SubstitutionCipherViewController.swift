//
//  SubstitutionCipherViewController.swift
//
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import UIKit
import PlaygroundSupport

typealias Plaintext = (text: String, shift: Int)

@objc(SubstitutionCipherViewController)
public class SubstitutionCipherViewController: UIViewController, PlaygroundLiveViewSafeAreaContainer {
    
    // MARK: Properties
    
    @IBOutlet weak var pagerContainerView: UIView!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    var plaintexts: [Plaintext] = [(CipherContent.ciphertext, 0)]
    fileprivate var pageController: UIPageViewController?
    fileprivate var currentWord = CipherContent.ciphertext
    private let decryptionPagerEmbedSegue = "decryptionPagerEmbedSegue"
    
    // Constraints
    @IBOutlet weak var pagerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var pagerViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var pagerViewTrailingConstraint: NSLayoutConstraint!
    
    // MARK: View Controller LifeCycle
    
    public override func updateViewConstraints() {
        resetConstraintsForViewSize()
        super.updateViewConstraints()
    }
    
    public override func viewDidLayoutSubviews() {
        resetConstraintsForViewSize()
    }
    
    override public func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Embed segue to present the plaintext for each shift
        if segue.identifier == decryptionPagerEmbedSegue {
            pageController = segue.destination as? UIPageViewController
            pageController?.dataSource = self
            pageController?.delegate = self
            let pageControl = UIPageControl.appearance(whenContainedInInstancesOf: [UIPageViewController.self])
            pageControl.pageIndicatorTintColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
            pageControl.currentPageIndicatorTintColor = #colorLiteral(red: 0.2048710883, green: 0.8790110946, blue: 0.205568701, alpha: 1)
            refreshPager()
        }
    }
    
    // MARK: IBAction Methods
    
    // Show the next page in `pageController`
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        let nextPage = getNextPage()
        pageController?.setViewControllers([nextPage], direction: .forward, animated: true, completion: { [weak self] (completed) in
            if nextPage.shiftUsed == 5 && self?.currentWord == CipherContent.ciphertext {
                self?.send(.string(Constants.playgroundMessageKeySuccess))
            }
        })
    }
    
    // Show the next previous in `pageController`
    @IBAction func previousButtonTapped(_ sender: UIButton) {
        let previousPage = getPreviousPage()
        pageController?.setViewControllers([previousPage], direction: .reverse, animated: true, completion: { [weak self] (completed) in
            if previousPage.shiftUsed == 5 && self?.currentWord == CipherContent.ciphertext {
                self?.send(.string(Constants.playgroundMessageKeySuccess))
            }
        })
    }
    
    // MARK: Custom Methods
    
    private func resetConstraintsForViewSize() {
        let currentWidth = liveViewSafeAreaGuide.layoutFrame.width
        let currentHeight = liveViewSafeAreaGuide.layoutFrame.height
        var originalPagerViewHeight: CGFloat = 0
        var heightScaleFactor: CGFloat = 1
        var widthScaleFactor: CGFloat = 1
        var originalHeight: CGFloat = 0
        var originalWidth: CGFloat = 0
        var originalSideMargins: CGFloat = 0
        
        // Portrait
        if currentHeight > currentWidth {
            originalHeight = 1366
            originalWidth = 1024
            originalPagerViewHeight = 1100
            originalSideMargins = 100
        } else {
            // Landscape
            originalHeight = 1024
            originalWidth = 1366
            originalPagerViewHeight = 800
            originalSideMargins = 200
        }
        
        heightScaleFactor = currentHeight / originalHeight
        widthScaleFactor = currentWidth / originalWidth
        
        pagerViewHeightConstraint.constant = originalPagerViewHeight * heightScaleFactor
        pagerViewLeadingConstraint.constant = originalSideMargins * widthScaleFactor
        pagerViewTrailingConstraint.constant = originalSideMargins * widthScaleFactor
        
        view.setNeedsUpdateConstraints()
    }
    
    fileprivate func refreshPager() {
        // If there's only 1 plaintext, disable next/previous buttons
        if plaintexts.count < 2 {
            nextButton.isEnabled = false
            previousButton.isEnabled = false
        } else {
            nextButton.isEnabled = true
            previousButton.isEnabled = true
        }
        
        guard let startingViewController = viewControllerAtIndex(index: 0) else { return }
        
        let viewControllers = [startingViewController]
        pageController?.setViewControllers(viewControllers, direction: .forward, animated: false, completion: nil)
    }
}

extension SubstitutionCipherViewController: UIPageViewControllerDataSource {
    fileprivate func getPreviousPage() -> SubstitutionCipherPageViewController {
        if let pagerViewController = pageController {
            if let lastViewController = pagerViewController.viewControllers?.last {
                if let previousPage = pageViewController(pagerViewController, viewControllerBefore: lastViewController) as? SubstitutionCipherPageViewController {
                    return previousPage
                }
            }
        }
        
        //If we can't get the previous one, just return the current
        return pageController?.viewControllers?.last as! SubstitutionCipherPageViewController
    }
    
    fileprivate func getNextPage() -> SubstitutionCipherPageViewController {
        if let pagerViewController = pageController {
            if let lastViewController = pagerViewController.viewControllers?.last {
                if let nextPage = pageViewController(pagerViewController, viewControllerAfter: lastViewController) as? SubstitutionCipherPageViewController {
                    return nextPage
                }
            }
        }
        
        //If we can't get the next one, just return the current
        return pageController?.viewControllers?.last as! SubstitutionCipherPageViewController
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let viewController = viewController as? SubstitutionCipherPageViewController {
            var index = viewController.pageIndex
            if index == 0 {
                return nil
            }
            index = index - 1
            return viewControllerAtIndex(index: index)
        }
        return nil
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let viewController = viewController as? SubstitutionCipherPageViewController {
            var index = viewController.pageIndex
            index = index + 1
            if index == plaintexts.count {
                return nil
            }
            return viewControllerAtIndex(index: index)
        }
        return nil
    }
    
    fileprivate func viewControllerAtIndex(index: Int) -> SubstitutionCipherPageViewController? {
        guard plaintexts.count != 0 && index < plaintexts.count else { return nil }
        
        let pageContentViewController: SubstitutionCipherPageViewController = SubstitutionCipherPageViewController.instantiateFromMainStoryboard()
        let plaintext = plaintexts[index]
        pageContentViewController.plaintext = plaintext.text
        pageContentViewController.pageIndex = index
        pageContentViewController.shiftUsed = plaintext.shift
        
        return pageContentViewController
    }
}

extension SubstitutionCipherViewController: UIPageViewControllerDelegate {
    public func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            if let viewController = pageViewController.viewControllers?[0] as? SubstitutionCipherPageViewController {
            
                // 5 is currently the key shift to decrypt the puzzle
                if viewController.shiftUsed == CipherContent.decryptionKey && currentWord == CipherContent.ciphertext {
                    send(.string(Constants.playgroundMessageKeySuccess))
                }
            }
        }
    }
}

extension SubstitutionCipherViewController: PlaygroundLiveViewMessageHandler {
    // Dumps out plaintexts list to avoid old strings getting stuck in there
    public func liveViewMessageConnectionOpened() {
        plaintexts = []
    }
    
    public func receive(_ message: PlaygroundValue) {
        switch message {
        case .dictionary(let shiftDict):
            guard case let .integer(shift)? = shiftDict[Constants.playgroundMessageKeyShift], case let .string(word)? = shiftDict[Constants.playgroundMessageKeyWord] else { return }
            plaintexts.append((CipherContent.shift(inputText: word, by: -shift), shift))
            currentWord = word
            refreshPager()
        default:
            return
        }
    }
    
    
}
