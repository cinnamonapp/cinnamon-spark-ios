//
//  DotsScrollView.swift
//  Cinnamon
//
//  Created by Alessio Santo on 15/05/15.
//  Copyright (c) 2015 Cinnamon. All rights reserved.
//

import UIKit

class DotsScrollView: UIScrollView {

    var dotsCount : Int{
        get{
            
            if(_dotsCount == nil){
                _dotsCount = 7
            }
            
            return _dotsCount
        }
        
        set{
            _dotsCount = newValue
            removeDotsFromSuperview()
            _dots = nil
        }
    }
    var _dotsCount : Int!
    
    var padding : UIEdgeInsets = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
    
    let defaultRadius : CGFloat = 10
    
    var dots : [DotView]{
        get{
            
            if(_dots != nil){
                return _dots
            }
            
            var array : [DotView] = []
            
            for(var i = 0; i < dotsCount; i++){
                let dot = DotView(frame: CGRectMake(0, 0, defaultRadius*2, defaultRadius*2))
                array.append(dot)
            }
            
            _dots = array
            
            return array
        }
    }
    var _dots : [DotView]!
    
    override init(frame: CGRect){
        super.init(frame: frame)
        configure()
    }
    
    required init(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
        configure()
    }
    
    func configure(){
        for dot in dots{
            self.addSubview(dot)
        }
    }
    
    func colorDotsWithColors(colors: [UIColor]){
        for (index, dot) in enumerate(dots){
            dot.fillColor = colors[index]
        }
    }
    
    func removeDotsFromSuperview(){
        for dot in dots{
            if let superview = dot.superview{
                dot.removeFromSuperview()
            }
        }
    }
    
    func spaceBetweenDots() -> CGFloat{
        var space : CGFloat = 10
        
        let availableSpace : CGFloat = bounds.size.width - padding.left - padding.right
        let usedSpace : CGFloat = CGFloat(dots.count) * defaultRadius * 2
        let remainingSpace : CGFloat = availableSpace - usedSpace
        
        space = remainingSpace / CGFloat(dots.count - 1)
        
        return space
    }
    
    override func layoutSubviews(){
        super.layoutSubviews()
        
        dots.first?.frame.origin.x = padding.left
        
        for(var i = 1; i < dots.count; i++){
            let dot = dots[i]
            let previousDot = dots[i-1]
            
            dot.frame.origin.x = CGRectGetMaxX(previousDot.frame) + spaceBetweenDots()
        }
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}


class DotView: UIView {
    
    let circlePathLayer = CAShapeLayer()
    
    var lineWidth : CGFloat = 2
    
    var circleRadius: CGFloat {
        get {
            return bounds.height / 2 - lineWidth / 2
        }
    }
    
    var fillColor : UIColor{
        get{
            return UIColor(CGColor: circlePathLayer.fillColor)
        }
        
        set{
            circlePathLayer.fillColor = newValue.CGColor
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
        
        circlePathLayer.frame = bounds
        
        circlePathLayer.lineWidth   = lineWidth
        circlePathLayer.fillColor   = UIColor.clearColor().CGColor //UIColorFromHex(0xF17223, alpha: 1).CGColor
        circlePathLayer.strokeColor = UIColor.whiteColor().CGColor
        
        layer.addSublayer(circlePathLayer)
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
        circlePathLayer.frame   = bounds
        circlePathLayer.path    = circlePath().CGPath
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
    // Drawing code
    }
    */
    
}