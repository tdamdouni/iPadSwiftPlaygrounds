// https://github.com/erictheriault/playgrounds/blob/master/gradient.playground/Contents.swift

import UIKit

extension UIView {
    
    func addGradient(startColor: UIColor, endColor: UIColor, isHorizontal: Bool) {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = bounds
        gradient.colors = [startColor.cgColor, endColor.cgColor]
        if isHorizontal {
            gradient.startPoint = CGPoint(x: 0, y: 0.5)
            gradient.endPoint = CGPoint(x: 1, y: 0.5)
        }
        layer.insertSublayer(gradient, at: 0)
    }
    
}

let view = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
view.addGradient(startColor: UIColor.red, endColor: UIColor.yellow, isHorizontal: true)
