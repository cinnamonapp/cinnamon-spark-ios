//
//  IndicatorRingView.swift
//  Cinnamon
//
//  Created by Alessio Santo on 22/05/15.
//  Copyright (c) 2015 Cinnamon. All rights reserved.
//

import UIKit

class IndicatorRingView: RingView {

    var circleIndicator : CircleIndicatorLabel!
    
    var circleSpacing : CGFloat = 4
    
    var label : UILabel {
        get{
            return circleIndicator.labelView
        }
    }
    
    override var fillColor : UIColor{
        get{
            return super.fillColor
        }
        
        set{
            super.fillColor = newValue
            circleIndicator.backgroundColor = newValue
        }
    }
    
    var font : UIFont{
        get{
            return label.font
        }
        
        set{
            label.font = newValue
        }
    }
    
    var textColor : UIColor{
        get{
            return label.textColor
        }
        
        set{
            label.textColor = newValue
        }
    }
    
    var text : String?{
        get{
            return label.text
        }
        
        set{
            label.text = newValue
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = UIColor.clearColor()
    }
    
    override func configure() {
        super.configure()
        
        lineWidth = 4
        
        circleIndicator = CircleIndicatorLabel(frame: bounds)
        self.addSubview(circleIndicator)
        
        fillColor = UIColor.whiteColor()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        circleIndicator.frame = bounds
        circleIndicator.frame.size.height -= lineWidth * 2 + circleSpacing * 2
        circleIndicator.frame.size.width -= lineWidth * 2 + circleSpacing * 2
        
        circleIndicator.frame.origin.y += lineWidth + circleSpacing
        circleIndicator.frame.origin.x += lineWidth + circleSpacing
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}


class CircleIndicatorLabel : UIView{
    
    var circleMaskLayer : CAShapeLayer!
    var labelView : UILabel!
    
    var circleRadius: CGFloat {
        get {
            return bounds.height / 2
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    func configure() {
        labelView = UILabel()
        labelView.textAlignment = NSTextAlignment.Center
        
        self.addSubview(labelView)
        
        applyMask()
    }

    
    
    private func applyMask(){
        circleMaskLayer = CAShapeLayer()
        circleMaskLayer.fillColor = UIColor.whiteColor().CGColor
        
        layer.mask = circleMaskLayer
    }
    
    func circleMaskFrame() -> CGRect {
        var circleFrame = CGRect(x: 0, y: 0, width: 2*circleRadius, height: 2*circleRadius)
        
        //        circleFrame.origin.x = CGRectGetMidX(circlePathLayer.bounds)// - CGRectGetMidX(circleFrame)
        //        circleFrame.origin.y = CGRectGetMidY(circlePathLayer.bounds)// - CGRectGetMidY(circleFrame)
        return circleFrame
    }
    
    func circleMaskPath() -> UIBezierPath {
        return UIBezierPath(ovalInRect: circleMaskFrame())
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        labelView.frame = bounds
        
        circleMaskLayer.frame = bounds
        circleMaskLayer.path = circleMaskPath().CGPath
    }
}