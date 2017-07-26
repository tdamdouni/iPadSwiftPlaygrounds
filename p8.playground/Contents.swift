//: Playground - noun: a place where people can play
// https://github.com/kaleposhobios/playgrounds/blob/master/ConstraintsPlayground.playground/Contents.swift

import UIKit
import XCPlayground

// Remember, to see the view you have to open the assistant editor (the double-loop button in the upper right)

// Set up some constants to use later, so it's easier to change values
let labelXSpacer: CGFloat = 10
let labelYSpacer: CGFloat = 15

// Set up the main view to use
let view = UIView(frame: CGRect(x: 0, y: 0, width: 400, height: 600))
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

// Center the subview horizontally in the view. Constraints like this define one item to another, and are good for centering, for example.
view.addConstraint(NSLayoutConstraint(item: grayView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: .CenterX, multiplier: 1, constant: 0))

// Center the subview vertically in the view
view.addConstraint(NSLayoutConstraint(item: grayView, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: .CenterY, multiplier: 1, constant: 0))

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

// Now, use Visual Format Language (VFL) to constrain the views. VFL is good for defining relationships betweeen multiple items at once.
// The constraint must be added to whatever is the parent (or self) of all involved views.
grayView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-(spacer)-[titleLabel]-(10)-[subtitleLabel]-(spacer)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: ["spacer": labelYSpacer], views: ["titleLabel": titleLabel, "subtitleLabel": subtitleLabel]))
grayView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-(spacer)-[label]-(spacer)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: ["spacer": labelXSpacer], views: ["label": titleLabel]))
grayView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-(spacer)-[label]-(spacer)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: ["spacer": labelXSpacer], views: ["label": subtitleLabel]))


