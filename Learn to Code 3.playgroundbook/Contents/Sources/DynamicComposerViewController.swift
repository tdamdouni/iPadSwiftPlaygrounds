// 
//  DynamicComposerViewController.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//


import UIKit
import UIKit.UIGestureRecognizerSubclass
import PlaygroundSupport
import Foundation
import SpriteKit

public let sceneSize = CGSize(width:1000, height: 1000)
public let baseContentEdgeLength : CGFloat = 512 // The size of the live view in landscape on an iPad
public let contentInset : CGFloat = 10 // The amount we'll inset the edge length to pull it away from the edge

public class DynamicComposerViewController : UIViewController, PlaygroundLiveViewSafeAreaContainer, UIGestureRecognizerDelegate, LiveViewSceneDelegate {
    
    var messageProcessingQueue: DispatchQueue? = nil
    let skView = LiveView(frame: .zero)
    let liveViewScene = LiveViewScene(size: sceneSize)
    let backgroundView = UIView(frame: .zero)
    let overlayView = SelfIgnoringView(frame: .zero)
    
    var sendTouchEvents:Bool = false
    var constraintsAdded = false
    
    private var skViewCenterXConstraint : NSLayoutConstraint?
    private var skViewCenterYConstraint : NSLayoutConstraint?
    private var bgImageViewCenterXConstraint : NSLayoutConstraint?
    private var bgImageViewCenterYConstraint : NSLayoutConstraint?
    
    public var backgroundImage : Image? {
        didSet {
            var image : UIImage?
            if let bgImage = backgroundImage {
                image = UIImage(named: bgImage.path)
            }
            else {
                // Default to the friends background when the background image
                image = UIImage(named:"LTC3_BG")
            }

            guard let imageView = backgroundView.subviews[0] as? UIImageView else { fatalError("failed to find backgroundImage imageView") }
            imageView.image = image
        }
    }
    
    public override func viewDidLoad() {
        // The scene needs to inform us of some events
        liveViewScene.sceneDelegate = self
        // Because the background image is *not* part of the scene itself, transparency is needed for the view and scene
        skView.allowsTransparency = true
        
        view.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        skView.translatesAutoresizingMaskIntoConstraints = false
        overlayView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(backgroundView)
        view.addSubview(skView)
        view.addSubview(overlayView)
        skView.presentScene(liveViewScene)

        func _constrainCenterAndSize(parent: UIView, child: UIView) {
            child.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                child.centerXAnchor.constraint(equalTo: parent.centerXAnchor),
                child.centerYAnchor.constraint(equalTo: parent.centerYAnchor),
                child.widthAnchor.constraint(equalTo: parent.widthAnchor),
                child.heightAnchor.constraint(equalTo: parent.heightAnchor)
                ])
        }

        let borderColorView = AddressableContentBorderView(frame: .zero)
        skView.addSubview(borderColorView)
        _constrainCenterAndSize(parent: skView, child: borderColorView)

        liveViewScene.overlayHost = overlayView

        // Create a blue background image
        let image : UIImage? = {
            UIGraphicsBeginImageContextWithOptions(CGSize(width:2500, height:2500), false, 2.0)
            UIColor(red: 0.22, green: 0.56, blue: 0.73, alpha: 1.0).set()
            UIRectFill(CGRect(x: 0, y: 0, width: 2500, height: 2500))
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return image
        }()
        let defaultBackgroundView = UIImageView(image:image)
        defaultBackgroundView.contentMode = .center
        defaultBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.addSubview(defaultBackgroundView)

        skViewCenterXConstraint = skView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        skViewCenterYConstraint = skView.centerYAnchor.constraint(equalTo: view.centerYAnchor)

        _constrainCenterAndSize(parent: view, child: backgroundView)
        _constrainCenterAndSize(parent: view, child: overlayView)
        _constrainCenterAndSize(parent: backgroundView, child: defaultBackgroundView)
        
        // Grab references to the background imageview's center x/y constraints so that we can pan the background
        bgImageViewCenterXConstraint = backgroundView.constraints.filter { $0.firstAttribute == .centerX }.first
        bgImageViewCenterYConstraint = backgroundView.constraints.filter { $0.firstAttribute == .centerY }.first

        NSLayoutConstraint.activate([
            skViewCenterXConstraint!,
            skViewCenterYConstraint!,
            overlayView.topAnchor.constraint(equalTo: self.liveViewSafeAreaGuide.topAnchor),
            ])

        pinchGesture = UIPinchGestureRecognizer.init(target: self, action: #selector(handlePinch(pinchGesture:)))
        pinchGesture?.delaysTouchesBegan = true
        pinchGesture?.delegate = self
        skView.addGestureRecognizer(pinchGesture!)
        
        panGesture = UIPanGestureRecognizer.init(target: self, action: #selector(handlePan(panGesture:)))
        panGesture?.delaysTouchesBegan = true
        panGesture?.minimumNumberOfTouches = 2
        panGesture?.delegate = self
        skView.addGestureRecognizer(panGesture!)
        
        // This gesture is here only to facilitate preventing an unwanted touch from getting through to the scene when pan/zoom gestures recognize (28923851).
        singleFingerPan = UIPanGestureRecognizer.init(target: self, action: #selector(handleSingleFingerPan(panGesture:)))
        singleFingerPan?.minimumNumberOfTouches = 1
        singleFingerPan?.maximumNumberOfTouches = 1
        singleFingerPan?.delaysTouchesBegan = true
        singleFingerPan?.cancelsTouchesInView = false
        singleFingerPan?.delegate = self
        pinchGesture?.require(toFail: singleFingerPan!)
        panGesture?.require(toFail: singleFingerPan!)
        skView.addGestureRecognizer(singleFingerPan!)

        NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: UIAccessibilityVoiceOverStatusChanged), object: nil, queue: OperationQueue.main) { (note : Notification) in
            self.updateGestureAvailabilityForVoiceOver()
        }
        updateGestureAvailabilityForVoiceOver()
    }

    private func updateGestureAvailabilityForVoiceOver() {
        let forceGesturesDisabled : Bool = true
        if UIAccessibilityIsVoiceOverRunning() || forceGesturesDisabled {
            pinchGesture?.isEnabled = false
            panGesture?.isEnabled = false
            singleFingerPan?.isEnabled = false
        }
        else {
            pinchGesture?.isEnabled = true
            panGesture?.isEnabled = true
            singleFingerPan?.isEnabled = true
        }
    }

    public override func viewWillAppear(_ animated: Bool) {
        guard constraintsAdded == false else { return }
        if let parentView = self.view.superview {
            NSLayoutConstraint.activate([
                view.centerXAnchor.constraint(equalTo: parentView.centerXAnchor),
                view.centerYAnchor.constraint(equalTo: parentView.centerYAnchor),
                view.widthAnchor.constraint(equalTo: parentView.widthAnchor),
                view.heightAnchor.constraint(equalTo: parentView.heightAnchor)])
        }
        constraintsAdded = true
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        let _ = updateMinimumAllowedEdgeLength(proposedSize: nil)
    }
    
    private var pinchGesture : UIPinchGestureRecognizer? = nil
    private var panGesture : UIPanGestureRecognizer? = nil
    private var singleFingerPan : UIPanGestureRecognizer? = nil
    
    private var percentZoomed : CGFloat = 0
    private var currentContentEdgeLength : CGFloat?
    private var minimumAllowedEdgeLength : CGFloat = baseContentEdgeLength - contentInset
    private var maximumAllowedEdgeLength : CGFloat {
        get {
            return  2 * minimumAllowedEdgeLength
        }
    }
    private var currentBGImageViewTransform : CGAffineTransform?

    @objc(handlePinch:)
    private func handlePinch(pinchGesture: UIPinchGestureRecognizer) {
        switch pinchGesture.state {
        case .began:
            currentContentEdgeLength = skView.contentEdgeLength
            currentBGImageViewTransform = backgroundView.subviews[0].transform

        case .changed:
            var newSize : CGFloat = round(currentContentEdgeLength! * pinchGesture.scale)
            // Prevent infinite zoom in either direction
            let hardStopMin = minimumAllowedEdgeLength * 0.8
            if newSize < hardStopMin {
                newSize = hardStopMin
            }

            let hardStopMax = maximumAllowedEdgeLength * 1.1
            if newSize > hardStopMax {
                newSize = hardStopMax
            }
            
            if skView.contentEdgeLength != newSize {
                skView.contentEdgeLength = newSize
                skView.invalidateIntrinsicContentSize()
                
                backgroundView.subviews[0].transform = currentBGImageViewTransform!.scaledBy(x: pinchGesture.scale, y: pinchGesture.scale)
            }
        case .cancelled, .ended:
            let animationDuration : TimeInterval = 0.60
            currentContentEdgeLength = nil

            if skView.contentEdgeLength < minimumAllowedEdgeLength {
                let t : CGAffineTransform = .identity
                UIView.animateKeyframes(withDuration: animationDuration, delay: 0.0, options: [.calculationModeCubicPaced], animations: { 
                    UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.33, animations: { 
                        self.skView.contentEdgeLength = self.minimumAllowedEdgeLength * 1.1
                        self.backgroundView.subviews[0].transform = t.scaledBy(x: 1.1, y: 1.1)
                        self.skView.invalidateIntrinsicContentSize()
                        self.skView.superview?.setNeedsLayout()
                        self.skView.superview?.layoutIfNeeded()
                    })

                    UIView.addKeyframe(withRelativeStartTime: 0.33, relativeDuration: 0.33, animations: { 
                        self.skView.contentEdgeLength = self.minimumAllowedEdgeLength * 0.9
                        self.backgroundView.subviews[0].transform = t.scaledBy(x: 0.9, y: 0.9)
                        self.skView.invalidateIntrinsicContentSize()
                        self.skView.superview?.setNeedsLayout()
                        self.skView.superview?.layoutIfNeeded()
                    })

                    UIView.addKeyframe(withRelativeStartTime: 0.66, relativeDuration: 0.33, animations: { 
                        self.skView.contentEdgeLength = self.minimumAllowedEdgeLength
                        self.backgroundView.subviews[0].transform = t
                        self.skView.invalidateIntrinsicContentSize()
                        self.skView.superview?.setNeedsLayout()
                        self.skView.superview?.layoutIfNeeded()
                    })

                    }, completion: { (completedAnimation : Bool) in 
                        self.percentZoomed = self.skView.contentEdgeLength / self.minimumAllowedEdgeLength - CGFloat(1.0)
                    }
                )
            }
            else if skView.contentEdgeLength > maximumAllowedEdgeLength {
                var t : CGAffineTransform = .identity
                t = t.scaledBy(x: 2.0, y: 2.0)
                UIView.animateKeyframes(withDuration: animationDuration, delay: 0.0, options: [.calculationModeCubicPaced], animations: { 
                    UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.33, animations: { 
                        self.skView.contentEdgeLength = self.maximumAllowedEdgeLength * 0.9
                        self.backgroundView.subviews[0].transform = t.scaledBy(x: 0.9, y: 0.9)
                        self.skView.invalidateIntrinsicContentSize()
                        self.skView.superview?.setNeedsLayout()
                        self.skView.superview?.layoutIfNeeded()
                    })

                    UIView.addKeyframe(withRelativeStartTime: 0.33, relativeDuration: 0.33, animations: { 
                        self.skView.contentEdgeLength = self.maximumAllowedEdgeLength * 1.1
                        self.backgroundView.subviews[0].transform = t.scaledBy(x: 1.1, y: 1.1)
                        self.skView.invalidateIntrinsicContentSize()
                        self.skView.superview?.setNeedsLayout()
                        self.skView.superview?.layoutIfNeeded()
                    })

                    UIView.addKeyframe(withRelativeStartTime: 0.66, relativeDuration: 0.33, animations: { 
                        self.skView.contentEdgeLength = self.maximumAllowedEdgeLength
                        self.backgroundView.subviews[0].transform = t
                        self.skView.invalidateIntrinsicContentSize()
                        self.skView.superview?.setNeedsLayout()
                        self.skView.superview?.layoutIfNeeded()
                    })

                    }, completion: { (completedAnimation : Bool) in 
                        self.percentZoomed = self.skView.contentEdgeLength / self.minimumAllowedEdgeLength - CGFloat(1.0)
                    }
                )
            }
            else {
                self.percentZoomed = self.skView.contentEdgeLength / self.minimumAllowedEdgeLength - CGFloat(1.0)
            }

        default:
            break
        }
    }

    // The amount we'll allow pan gestures to move before resisting (also the maximum we'll allow a pan to go). This value changes based on the zoom of the scene.
    private var panOffsetAffordance : CGFloat {
        get {
            let shorterEdge = self.view.bounds.size.width < self.view.bounds.size.height ? self.view.bounds.size.width : self.view.bounds.size.height
            return (shorterEdge / 2.0) * self.percentZoomed
        }
    }

    private var currentPosition : CGPoint?
    private var currentBGImagePosition : CGPoint?
    private var panRangeLimit : CGFloat?
    @objc(handlePan:)
    private func handlePan(panGesture: UIPanGestureRecognizer) {
        switch panGesture.state {
        case .began:
            if let xCons = skViewCenterXConstraint, let yCons = skViewCenterYConstraint {
                currentPosition = CGPoint(x: xCons.constant, y: yCons.constant)
            }
            panRangeLimit = self.view.bounds.size.width < self.view.bounds.size.height ? self.view.bounds.size.width : self.view.bounds.size.height

            if let xCons = bgImageViewCenterXConstraint, let yCons = bgImageViewCenterYConstraint {
                currentBGImagePosition = CGPoint(x: xCons.constant, y: yCons.constant)
            }

        case .changed:
            let translation = panGesture.translation(in: nil)
            // There's a number of position/constraint items we need to make this happen. They all need to exist.
            if let cPos = currentPosition, let bgPos = currentBGImagePosition, 
                let xCons = skViewCenterXConstraint, let yCons = skViewCenterYConstraint,
                let bgxCons = bgImageViewCenterXConstraint, let bgyCons = bgImageViewCenterYConstraint {

                // Range is a relative value to the area in which the rubber band is going to happen. It effectively scales the effect appropriately for the given area in which its occurring. The math is pulled directly from the rubber band logic found in UIScrollView.
                func _calculateOffset(proposedOffset: CGFloat, maxOffset: CGFloat, range: CGFloat) -> CGFloat {
                    let absOffset = abs(proposedOffset)
                    if (absOffset < maxOffset) {
                        return proposedOffset // Nothing to do if we're under the max allowed offset
                    }

                    let isNegative = (__inline_signbitf(Float(proposedOffset)) == 0) ? false : true

                    var unitOffset = (absOffset - maxOffset) / range
                    unitOffset = (1 - (1 / (0.55 * unitOffset + 1)))
                    let newOffset = (unitOffset * range) + maxOffset
                    return newOffset * (isNegative == true ? -1 : 1)
                }

                let xOffset = _calculateOffset(proposedOffset: translation.x, maxOffset: panOffsetAffordance, range: panRangeLimit!)
                let yOffset = _calculateOffset(proposedOffset: translation.y, maxOffset: panOffsetAffordance, range: panRangeLimit!)
                
                // Update the scene's position
                xCons.constant = cPos.x + xOffset
                yCons.constant = cPos.y + yOffset
                
                // Update the background's position
                bgxCons.constant = bgPos.x + xOffset
                bgyCons.constant = bgPos.y + yOffset
            }

        case .ended, .cancelled:
            currentPosition = nil
            panRangeLimit = nil
            currentBGImagePosition = nil

            if let xCons = skViewCenterXConstraint, let yCons = skViewCenterYConstraint,
                let bgxCons = bgImageViewCenterXConstraint, let bgyCons = bgImageViewCenterYConstraint {
                let resetToCenter = 50.0 * (self.percentZoomed + 1)
                if abs(xCons.constant) <= resetToCenter {
                    xCons.constant = 0
                    bgxCons.constant = 0
                }
                else if abs(xCons.constant) > panOffsetAffordance {
                    xCons.constant = panOffsetAffordance * (xCons.constant.sign == .minus ? -1 : 1)
                    bgxCons.constant = panOffsetAffordance * (bgxCons.constant.sign == .minus ? -1 : 1)
                }

                if abs(yCons.constant) <= resetToCenter {
                    yCons.constant = 0
                    bgyCons.constant = 0
                }
                else if abs(yCons.constant) > panOffsetAffordance {
                    yCons.constant = panOffsetAffordance * (yCons.constant.sign == .minus ? -1 : 1)
                    bgyCons.constant = panOffsetAffordance * (bgyCons.constant.sign == .minus ? -1 : 1)
                }

                UIView.animate(withDuration: 0.2, delay: 0.0, options: [.curveEaseInOut], animations: { 
                    self.skView.superview?.setNeedsLayout()
                    self.skView.superview?.layoutIfNeeded()
                    }, completion: nil)
            }            
        default:
            break
        }
    }
    
    @objc(handleSingleFingerPan:)
    private func handleSingleFingerPan(panGesture: UIPanGestureRecognizer) {
        switch panGesture.state {
        case .began:
            // This is a bit on the clever side... the LiveViewScene is watching for raw touch events. However, we're using gestures here to pan/zoom. Gestures have mechanisms to delay touchesBegan but that only happens if the gestures move into a failed state. In the case of just our pan/zoom gestures, a single finger gesture would never fail and the touches never get delivered. But by having a single-finger gesture, which both pan/zoom gestures require to fail, we can force both into a failed state by having the single-finger gesture recognize. Then we simply set the gesture's state to failed to trigger delivery of the touch that had the single-finger gesture recognize in the first place.
            // Yes, this is playing a bit fast and loose with gesture overriding and making .state mutable.
            panGesture.state = .failed
        default:
            break
        }
    }


    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if (gestureRecognizer == panGesture && otherGestureRecognizer == pinchGesture) ||
            (gestureRecognizer == pinchGesture && otherGestureRecognizer == panGesture) {
            // Allow both pan and pinch at the same time
            return true
        }
        return false
    }
    
    // Returns the shorter edge of the size
    private func updateMinimumAllowedEdgeLength(proposedSize: CGSize?) -> CGFloat {
        var size = proposedSize
        if size == nil {
            size = view.bounds.size
        }
        
        var shorterEdge : CGFloat = 0
        var safeAreaInset : CGFloat = 0
        if size!.width < size!.height {
            shorterEdge = size!.width
            safeAreaInset = max(self.liveViewSafeAreaGuide.layoutFrame.origin.x, self.view.frame.size.width - self.liveViewSafeAreaGuide.layoutFrame.size.width)
        }
        else {
            shorterEdge = size!.height
            safeAreaInset = max(self.liveViewSafeAreaGuide.layoutFrame.origin.y, self.view.frame.size.height - self.liveViewSafeAreaGuide.layoutFrame.size.height)
        }
        
        minimumAllowedEdgeLength = shorterEdge - safeAreaInset - contentInset
        
        return shorterEdge
    }
    
    private func recenterSceneForLiveViewSize(size: CGSize) {
        // Do nothing if we're gesturing.
        if let pan = panGesture { guard pan.state == .possible else { return } }
        if let pinch = pinchGesture { guard pinch.state == .possible else { return } }

        let currentContentEdgeLength = skView.contentEdgeLength
        let shorterEdge = updateMinimumAllowedEdgeLength(proposedSize: size)
        
        if shorterEdge < currentContentEdgeLength && percentZoomed <= 0.10 {
            // If we're within 10% of the current minimum size, assume they wanted to resize along with the size change
            skView.contentEdgeLength = minimumAllowedEdgeLength
            percentZoomed = 0.0
            self.skView.invalidateIntrinsicContentSize()
        }
        else if shorterEdge > currentContentEdgeLength {
            skView.contentEdgeLength = minimumAllowedEdgeLength
            percentZoomed = 0.0
            self.skView.invalidateIntrinsicContentSize()
        }

        if let xCons = skViewCenterXConstraint, let yCons = skViewCenterYConstraint,
            let bgxCons = bgImageViewCenterXConstraint, let bgyCons = bgImageViewCenterYConstraint {
            xCons.constant = 0
            yCons.constant = 0

            bgxCons.constant = 0
            bgyCons.constant = 0
        }
    }
    
    private var oldViewSize : CGSize = .zero
    public override func viewWillLayoutSubviews() {
        if view.bounds.size != oldViewSize {
            recenterSceneForLiveViewSize(size: view.bounds.size)
            oldViewSize = view.bounds.size
        }
    }
}

public class LiveView : SKView, PlaygroundLiveViewSafeAreaContainer {
    public var contentEdgeLength : CGFloat = baseContentEdgeLength - contentInset
    override public var intrinsicContentSize: CGSize {
        get {
            return CGSize(width: contentEdgeLength, height: contentEdgeLength)
        }
    }
}

public class SelfIgnoringView : UIView {
    override public func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        if (view == self) {
            return nil
        }
        return view
    }
}

public class AddressableContentBorderView : SelfIgnoringView {
    override public var isOpaque: Bool {
        set {}
        get { return false }
    }
    override public func draw(_ rect: CGRect) {
        UIColor.clear.set()
        let path = UIBezierPath(rect: self.bounds)
        path.fill()

        let pattern = Array<CGFloat>(arrayLiteral: 3.0, 3.0)
        path.setLineDash(pattern, count: 2, phase: 0.0)
        path.lineJoinStyle = .round
        UIColor.white.set()
        path.stroke()
    }
}

extension DynamicComposerViewController : PlaygroundLiveViewMessageHandler {
    
    public func liveViewMessageConnectionOpened() {
        messageProcessingQueue = DispatchQueue(label: "Message Processing Queue")
        liveViewScene.connectedToUserCode()
    }
    
    public func liveViewMessageConnectionClosed() {
        liveViewScene.disconnectedFromUserCode()
    }
    
    public func receive(_ message: PlaygroundValue) {
        messageProcessingQueue?.async { [unowned self] in
            self.processMessage(message)
        }
    }
    
    private func processMessage(_ message: PlaygroundValue) {
        guard let unpackedMessage = Message(rawValue: message) else {
            return
        }

        switch unpackedMessage {
   
        case .registerTouchHandler(let registered):
            DispatchQueue.main.async { [unowned self] in
                self.sendTouchEvents = registered
            }
          
        default:
            self.liveViewScene.handleMessage(message: unpackedMessage)
        }
    }
    
}
