//
//  ButtonBar.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//

import UIKit

let desiredGapBetweenButtons : CGFloat = 10

public class ButtonBar : UIView {
    private var stackView : UIStackView
    private var widthConstraint : NSLayoutConstraint?
    private var heightConstraint : NSLayoutConstraint?
    internal var numberOfButtons : Int {
        get {
            return self.stackView.arrangedSubviews.count
        }
    }
    
    
    override init(frame: CGRect) {
        self.stackView = UIStackView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        self.stackView.axis = .horizontal
        self.stackView.distribution = .equalSpacing
        self.stackView.translatesAutoresizingMaskIntoConstraints = false

        super.init(frame: frame)

        self.translatesAutoresizingMaskIntoConstraints = false        
        self.addSubview(self.stackView)

        self.widthConstraint = self.widthAnchor.constraint(equalToConstant: frame.width)
        self.heightConstraint = self.heightAnchor.constraint(equalToConstant: frame.height)
        
        NSLayoutConstraint.activate([
            self.widthConstraint!,
            self.heightConstraint!,
            self.stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant:0),
            self.stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant:0),
            self.stackView.topAnchor.constraint(equalTo: self.topAnchor, constant:0)
            ])
    }

    convenience public init(origin: CGPoint, buttons : Array<UIView>) {
        let desiredGapBetweenButtons = 10
        let buttonGap = desiredGapBetweenButtons * (buttons.count - 1)
        let barSize = buttons.reduce(CGSize(width:buttonGap, height:0)) { (size : CGSize, button : UIView) -> CGSize in
            let buttonSize = button.frame.size
            var accumulatedSize = size
            if buttonSize.height > accumulatedSize.height {
                accumulatedSize.height = buttonSize.height
            }
            
            accumulatedSize.width += buttonSize.width
            
            return accumulatedSize
        }
        
        self.init(frame: CGRect(x: origin.x, y: origin.y, width: barSize.width, height: barSize.height))
        
        for button in buttons {
            self.stackView.addArrangedSubview(button)
        }
    }

    required public init?(coder aDecoder: NSCoder) {
        print("init(coder:) has not been implemented for ButtonBar")
        return nil
    }
}

internal class ButtonBarButton : UIButton {
    static internal func createANewButton(title: String, target: Any?, action: Selector, for controlEvents: UIControlEvents = .touchUpInside) -> UIView {
        let button = ButtonBarButton(type: .custom)
        button.setTitle(title, for: .normal)
        button.setTitleColor(UIColor.interfaceColor, for: .normal)
        button.setTitleColor(UIColor.interfaceColor.colorWithRelativeBrightness(0.60), for: .highlighted)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18.0)
        
        button.addTarget(target, action: action, for: controlEvents)
        
        button.contentEdgeInsets = UIEdgeInsets(top: 11, left: 20, bottom: 11, right: 20)
        button.sizeToFit()
        let buttonSize = button.sizeThatFits(CGSize(width:400, height:100))
        
        let wrapper = UIVisualEffectView(effect: UIBlurEffect(style: .extraLight))
        wrapper.frame = CGRect(x: 0, y: 0, width: buttonSize.width, height: buttonSize.height)
        wrapper.layer.cornerRadius = 22.0
        wrapper.clipsToBounds = true
        wrapper.contentView.addSubview(button)

        // UIStackView *really* wants constraints and UIVisualEffectView's innards are all autoresizing masks (sorry about that). If we don't constrain the wrapper to the same width/height as the button, UIStackView will collapse whatever dimension is aligned with its axis to zero.
        NSLayoutConstraint.activate([
            wrapper.widthAnchor.constraint(equalToConstant: buttonSize.width),
            wrapper.heightAnchor.constraint(equalToConstant: buttonSize.height),
            button.widthAnchor.constraint(equalTo: wrapper.contentView.widthAnchor, constant:0),
            button.heightAnchor.constraint(equalTo: wrapper.contentView.heightAnchor, constant:0)
            ])

        // Force the button to layout so that it doesn't get caught up in an animation block later.
        wrapper.layoutIfNeeded()

        return wrapper
    }
}

extension UIColor {
    func colorWithRelativeBrightness(_ relativeBrighness: CGFloat) -> UIColor {
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0
        self.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        
        brightness *= relativeBrighness
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
    }
    
    class var interfaceColor : UIColor {
        get {
            return UIColor(red: 254.0/255.0, green: 75.0/255.0, blue: 38.0/255.0, alpha: 1.0)
        }
    }
}
