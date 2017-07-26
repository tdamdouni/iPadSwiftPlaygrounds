
// Playground - noun: a place where people can play
// https://gist.github.com/hsjunnesson/9e07291b7ccd35cea269

import UIKit
import QuartzCore


@IBDesignable
public class CirclePhotoView: UIView {
    
    @IBInspectable public var image: UIImage?
    
    lazy var circleLayer: CAShapeLayer = CAShapeLayer()
    lazy var imageLayer: CALayer = CALayer()
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        // Add to super layer if not present
        
        if circleLayer.superlayer == nil {
            layer.addSublayer(circleLayer)
        }
        
        if imageLayer.superlayer == nil {
            layer.insertSublayer(imageLayer, above: circleLayer)
        }
        
        // Update circle
        circleLayer.path = CGPathCreateWithEllipseInRect(bounds, nil)
        circleLayer.fillColor = UIColor.lightGrayColor().CGColor
        
        // Update image
        let inset = CGRectInset(bounds, 5, 5)
        imageLayer.frame = inset
        
        if let image = self.image {
            let maskedImage = maskImage(image, size: bounds.size)
            imageLayer.contents = maskedImage.CGImage
            imageLayer.backgroundColor = UIColor.clearColor().CGColor
        } else {
            imageLayer.contents = nil
            imageLayer.backgroundColor = UIColor.whiteColor().CGColor
        }
    }
    
    // Mask an image in a circle
    func maskImage(image: UIImage, size: CGSize) -> UIImage {
        UIGraphicsBeginImageContext(size)
        let context = UIGraphicsGetCurrentContext()
        let rect = CGRectMake(0, 0, size.width, size.height)
        
        let path = CGPathCreateWithEllipseInRect(rect, nil)
        CGContextAddPath(context, path)
        CGContextClip(context)
        
        image.drawInRect(rect)
        
        let maskedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return maskedImage
    }
}


let view = CirclePhotoView(frame: CGRectMake(0, 0, 100, 100))

view.image = UIImage(named: "avatar.jpg")
view.setNeedsLayout()

view
