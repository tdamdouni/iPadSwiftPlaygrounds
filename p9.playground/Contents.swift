//: Playground - noun: a place where people can play
// https://github.com/kaleposhobios/playgrounds/blob/master/AnimationPlayground.playground/Contents.swift

import UIKit
//import XCPlayground

// Remember, to see the view you have to open the assistant editor (the double-loop button in the upper right)

// In reality you wouldn't have all the code in one place, you should use classes ☺️

// Set up some constants to use later, so it's easier to change values
let labelXSpacer: CGFloat = 10
let labelYSpacer: CGFloat = 15

// Set up the main view to use
let view = UIView(frame: CGRect(x: 0, y: 0, width: 400, height: 400))
view.backgroundColor = UIColor.whiteColor()
XCPlaygroundPage.currentPage.liveView = view

// Set up a subview to center inside the view
let grayView = UIView(frame: CGRect.zero)

// Since Swift is strongly typed, don't need to say `UIColor.` -- it can infer that.
grayView.backgroundColor = .grayColor()

// We want to use constraints, so we have to call this. If we were using interface builder, it would default to this setting.

grayView.translatesAutoresizingMaskIntoConstraints = false
// Views need to know their x position, y position, width and height. Views with content (like labels with text) have an `intrinsic` content size that they want to be. So if you don't otherwise define a width and height, they'll use those.

// Add the subview to the parent view. Have to add it before you can set any constraints.
view.addSubview(grayView)

grayView.center = view.center

// Since we will be adding a few labels to the gray view, and positioning the related to all 4 of the gray view's sides, they will give the gray view its width and height. So we don't need to add constraints for that.
let titleLabel = UILabel(frame: CGRect.zero)
titleLabel.translatesAutoresizingMaskIntoConstraints = false
titleLabel.text = "I'm a title! I'm really long!"
titleLabel.font = UIFont.boldSystemFontOfSize(20)
titleLabel.backgroundColor = .whiteColor()
titleLabel.textAlignment = .Center

// Title label is a subview (child) of gray view, not of the main `view`
grayView.addSubview(titleLabel)

// Both labels have an intrinsic size (because they has text that knows how big they wants to be) so all we need to define are their x and y positions.
let subtitleLabel = UILabel(frame: CGRect.zero)
subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
subtitleLabel.text = "I'm a subtitle"
subtitleLabel.font = .systemFontOfSize(16)
subtitleLabel.backgroundColor = .whiteColor()
subtitleLabel.textAlignment = .Center
grayView.addSubview(subtitleLabel)

let button = UIButton(frame: CGRect.zero)
button.translatesAutoresizingMaskIntoConstraints = false
button.setTitle("Bounce me", forState: UIControlState.Normal)
button.setTitleColor(.blackColor(), forState: .Normal)
view.addSubview(button)

let fadeButton = UIButton(frame: CGRect.zero)
fadeButton.translatesAutoresizingMaskIntoConstraints = false
fadeButton.setTitle("Fade the box", forState: UIControlState.Normal)
fadeButton.setTitleColor(.blackColor(), forState: .Normal)
view.addSubview(fadeButton)

// Create the animator to use
let animator = UIDynamicAnimator(referenceView: view)

// Provide an object that can be the button target since 
// there is no `self` in playground
class ButtonTarget: NSObject {
    var moveTargetView: UIView
    var fadeTargetView: UIView
    var animator: UIDynamicAnimator
    
    init(moveTargetView: UIView,
         fadeTargetView: UIView,
         animator: UIDynamicAnimator) {
        self.moveTargetView = moveTargetView
        self.fadeTargetView = fadeTargetView
        self.animator = animator
    }
    
    func moveView() {
        // push the view
        let push = UIPushBehavior(items: [moveTargetView], mode: .Instantaneous)
        push.angle = 2
        push.magnitude = 20
        animator.addBehavior(push)
    }
    
    func fadeView() {
        // Fade the view out or in. Incomplete logic because it doesn't handle the "is currnetly animating" case
        var newAlpha: CGFloat = 0
        if fadeTargetView.alpha == 0 {
            newAlpha = 1
        } else {
            newAlpha = 0
        }
        // Duration in seconds
        UIView.animateWithDuration(1, animations: {
            self.fadeTargetView.alpha = newAlpha
        })
    }
}

let target = ButtonTarget(moveTargetView: button,
                          fadeTargetView: grayView,
                          animator: animator)
button.addTarget(target, action: #selector(ButtonTarget.moveView), forControlEvents: .TouchUpInside)
fadeButton.addTarget(target, action: #selector(ButtonTarget.fadeView), forControlEvents: .TouchUpInside)

// Now, use Visual Format Language (VFL) to constrain the views. VFL is good for defining relationships betweeen multiple items at once.
// The constraint must be added to whatever is the parent (or self) of all involved views.
view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[button][fadeButton]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["button": button, "fadeButton":fadeButton]))
grayView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-(spacer)-[titleLabel]-(10)-[subtitleLabel]-(spacer)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: ["spacer": labelYSpacer], views: ["titleLabel": titleLabel, "subtitleLabel": subtitleLabel]))
grayView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-(spacer)-[label]-(spacer)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: ["spacer": labelXSpacer], views: ["label": titleLabel]))
grayView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-(spacer)-[label]-(spacer)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: ["spacer": labelXSpacer], views: ["label": subtitleLabel]))
view.addConstraint(NSLayoutConstraint(item: button, attribute: .CenterX, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1, constant: 0))
view.addConstraint(NSLayoutConstraint(item: fadeButton, attribute: .CenterX, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1, constant: 0))


// Force constraints to be evaluated
view.layoutSubviews()

// Add some dynamic animation, namely some gravity
let gravity = UIGravityBehavior(items: [grayView, button, fadeButton])
animator.addBehavior(gravity)

// Add some collision detection
let collision = UICollisionBehavior(items: [grayView, button, fadeButton])
collision.translatesReferenceBoundsIntoBoundary = true
animator.addBehavior(collision)



