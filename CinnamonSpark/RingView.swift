//
//  RingView.swift
//  RingThingTest
//
//  Created by Alessio Santo on 12/05/15.
//  Copyright (c) 2015 Alessio Santo. All rights reserved.
//

import UIKit

let yellow = UIColorFromHex(0xFEDB6C, alpha: 1)
let transparent = UIColorFromHex(0xD8D8D8, alpha: 0.2)

class RingView: UIView {

    let circlePathLayer = CAShapeLayer()
    
    let backCirclePathLayer = CAShapeLayer()

    var lineWidth : CGFloat{
        get{
            return _lineWidth
        }
        
        set{
            _lineWidth = newValue
            circlePathLayer.lineWidth = _lineWidth
            backCirclePathLayer.lineWidth = _lineWidth
        }
    }
    var _lineWidth : CGFloat = 8

    var circleRadius: CGFloat {
        get {
            return bounds.height / 2 - lineWidth / 2
        }
    }
        
    var fillColor : UIColor{
        get{
            return UIColor(CGColor: circlePathLayer.strokeColor)
        }
        
        set{
            circlePathLayer.strokeColor = newValue.CGColor
        }
    }
    
    var progress: CGFloat {
        get {
            return circlePathLayer.strokeEnd
        }
        set {
            if (newValue > 1) {
                circlePathLayer.strokeEnd = 1
            } else if (newValue < 0) {
                circlePathLayer.strokeEnd = 0
            } else {
                circlePathLayer.strokeEnd = newValue
            }
        }
    }
    
//    func setProgress(toProgress: CGFloat, animated: Bool){
//        let animation = CABasicAnimation(keyPath: "strokeEnd")
//        animation.duration = 0.8
//        animation.fromValue = progress
//        animation.toValue = toProgress
//        animation.repeatCount = 2
//
//        circlePathLayer.addAnimation(animation, forKey: "progressAnimation")
//    }
    
    var reverseProgress: CGFloat {
        get{
            return circlePathLayer.strokeStart
        }
        
        set{
            if (newValue > 1) {
                circlePathLayer.strokeStart = 0
                
                let remaining = newValue - 1
                
                circlePathLayer.strokeEnd = remaining
            } else if (newValue < 0) {
                circlePathLayer.strokeStart = 0
            } else {
                circlePathLayer.strokeStart = newValue
            }
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
        
        configureBack()
        
        circlePathLayer.frame       = bounds
        
        circlePathLayer.lineWidth   = lineWidth
        circlePathLayer.fillColor   = UIColor.clearColor().CGColor
        circlePathLayer.strokeColor = yellow.CGColor
        
        circlePathLayer.lineCap     = kCALineCapRound
        circlePathLayer.lineJoin    = kCALineJoinRound
        
        layer.addSublayer(circlePathLayer)
        
    }
    
    internal func configureBack(){
        
        backCirclePathLayer.frame       = bounds
        
        backCirclePathLayer.lineWidth   = lineWidth
        backCirclePathLayer.fillColor   = UIColor.clearColor().CGColor
        backCirclePathLayer.strokeColor = transparent.CGColor
        
        layer.addSublayer(backCirclePathLayer)
        
    }
    
    func circleFrame() -> CGRect {
        var circleFrame = CGRect(x: 0, y: 0, width: 2*circleRadius, height: 2*circleRadius)
        
        circleFrame.origin.x = CGRectGetMidX(circlePathLayer.bounds)// - CGRectGetMidX(circleFrame)
        circleFrame.origin.y = CGRectGetMidY(circlePathLayer.bounds)// - CGRectGetMidY(circleFrame)
        return circleFrame
    }
    
    func circlePath() -> UIBezierPath {
        let f = circleFrame()
        let s : CGFloat = CGFloat(-(M_PI)/2.0)
        let e : CGFloat = CGFloat(3*M_PI/2.0)
        
        return UIBezierPath(arcCenter: f.origin, radius: circleRadius, startAngle: s, endAngle: e, clockwise: true)
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        circlePathLayer.frame = bounds
        circlePathLayer.path = circlePath().CGPath
        
        backCirclePathLayer.frame = bounds
        backCirclePathLayer.path = circlePath().CGPath
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
