//
//  CircleImageView.swift
//  Cinnamon
//
//  Created by Alessio Santo on 13/05/15.
//  Copyright (c) 2015 Cinnamon. All rights reserved.
//

import UIKit

class CircleImageView: UIImageView {
    
    let circlePathLayer = CAShapeLayer()
    let borderLayer = CAShapeLayer()
    
    var borderWidth : CGFloat{
        get{
            return borderLayer.lineWidth
        }
        set{
            borderLayer.lineWidth = newValue
        }
    }
    
    var borderColor : UIColor{
        get{
            return UIColor(CGColor: borderLayer.strokeColor)
        }
        
        set{
            borderLayer.strokeColor = newValue.CGColor
        }
    }
    
    override init() {
        super.init()
        
        applyMask()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        applyMask()
    }
    
    override init(image: UIImage!) {
        super.init(image: image)
        
        applyMask()
    }
    
    
    override init(image: UIImage!, highlightedImage: UIImage?) {
        super.init(image: image, highlightedImage: highlightedImage)
        
        applyMask()
    }
    
    func applyMask(){
        circlePathLayer.frame = bounds
        circlePathLayer.fillColor = UIColor.whiteColor().CGColor
        
        layer.mask = circlePathLayer
        
        borderLayer.fillColor = UIColor.clearColor().CGColor
        borderWidth = 0
        borderColor = UIColor.whiteColor()
        
        layer.addSublayer(borderLayer)
    }
    
    var circleRadius: CGFloat {
        get {
            return bounds.height / 2
        }
    }
    
    func circleFrame() -> CGRect {
        var circleFrame = CGRect(x: 0, y: 0, width: 2*circleRadius, height: 2*circleRadius)
        
//        circleFrame.origin.x = CGRectGetMidX(circlePathLayer.bounds)// - CGRectGetMidX(circleFrame)
//        circleFrame.origin.y = CGRectGetMidY(circlePathLayer.bounds)// - CGRectGetMidY(circleFrame)
        return circleFrame
    }
    
    func circlePath() -> UIBezierPath {
        return UIBezierPath(ovalInRect: circleFrame())
    }

    
    override func layoutSubviews() {
        super.layoutSubviews()
        circlePathLayer.frame = bounds
        circlePathLayer.path = circlePath().CGPath
        
        borderLayer.frame = bounds
        borderLayer.path = circlePath().CGPath
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}




extension UIImage{
    func imageScaledToSize(newSize: CGSize) -> UIImage {
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
    self.drawInRect(CGRectMake(0, 0, newSize.width, newSize.height))
    let newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage
    }
}


