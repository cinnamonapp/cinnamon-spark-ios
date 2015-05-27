//
//  DotsScrollView.swift
//  Cinnamon
//
//  Created by Alessio Santo on 15/05/15.
//  Copyright (c) 2015 Cinnamon. All rights reserved.
//

import UIKit

@objc
protocol DotsScrollViewDelegate : UIScrollViewDelegate{
    /**
        This method is called when the user touches one of the dots.
    
        :param: dotsScrollViewDelegate The object that is container of dots
        :param: indexPath The index path of the touched object. Only the item property is filled for now.
    */
    optional func dotsScrollView(
                                 dotsScrollView: DotsScrollView,
        didSelectItemAtIndexPath indexPath: NSIndexPath
    )
}

class DotsScrollView: UIScrollView, DotViewDelegate{
    
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
            
            // Put the dots back into the view
            configure()
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
            
            // Dots initialization
            for(var i = 0; i < dotsCount; i++){
                let dot = DotView(frame: CGRectMake(0, 0, defaultRadius*2, defaultRadius*2 + 15))
                dot.label.text = "Tue"
                dot.delegate = self
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
    
    // MARK: - Dots method
    
    func colorDotsWithColors(colors: [UIColor]){
        for (index, dot) in enumerate(dots){
            dot.fillColor = colors[index]
        }
    }
    
    func setTextToDotsWithStrings(strings: [String]){
        for (index, dot) in enumerate(dots){
            dot.label.text = strings[index]
        }
    }
    
    func removeDotsFromSuperview(){
        for dot in dots{
            if let superview = dot.superview{
                dot.removeFromSuperview()
            }
        }
    }
    
    // MARK: - Layout methods
    
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
//            dot.frame.origin.y = CGRectGetMidY(bounds) - dot.frame.height / 2
        }
    }
    
    
    // MARK: - DotViewDelegate methods
    func dotViewDidTouchUpInside(dotView: DotView) {
        let index = indexOf(dot: dotView, inArray: dots)
        let indexPath = NSIndexPath(forItem: index, inSection: 0)
        
        if let delegate = self.delegate as? DotsScrollViewDelegate{
            if(delegate.respondsToSelector("dotsScrollView:didSelectItemAtIndexPath:")){
                delegate.dotsScrollView!(self, didSelectItemAtIndexPath: indexPath)
            }
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

protocol DotViewDelegate: NSObjectProtocol{
    /**
        Called when a dot is touched.
        
        :param: dotView The dot that has been touched
    */
    func dotViewDidTouchUpInside(dotView: DotView)
}

class DotView: UIView {
    
    var delegate : DotViewDelegate?
    
    let circlePathLayer = CAShapeLayer()
    
    var lineWidth : CGFloat = 2
    
    var circleRadius: CGFloat {
        get {
            return bounds.width / 2 - lineWidth / 2
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
    
    let label : UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    func configure() {
        
        // Configure circle
        circlePathLayer.frame = bounds
        
        circlePathLayer.lineWidth   = lineWidth
        circlePathLayer.fillColor   = UIColor.clearColor().CGColor //UIColorFromHex(0xF17223, alpha: 1).CGColor
        circlePathLayer.strokeColor = UIColor.whiteColor().CGColor
        
        layer.addSublayer(circlePathLayer)
        
        // Configure label
        label.font = label.font.fontWithSize(9)
        label.textColor = UIColor.whiteColor()
        label.textAlignment = NSTextAlignment.Center
        self.addSubview(label)
        
        addTouchUpInsideGesture()
    }
    
    func addTouchUpInsideGesture(){
        let gesture = UITapGestureRecognizer(target: self, action: "handleTapGesture:")
        self.addGestureRecognizer(gesture)
    }
    
    func handleTapGesture(sender: AnyObject?){
        // Call the delegate methods
        if let delegate = self.delegate{
            if(delegate.respondsToSelector("dotViewDidTouchUpInside:")){
                delegate.dotViewDidTouchUpInside(self)
            }
        }
    }
    
    func circleFrame() -> CGRect {
        var circleFrame = CGRect(x: 0, y: 0, width: 2*circleRadius, height: 2*circleRadius)
        
        circleFrame.origin.x = CGRectGetMidX(circlePathLayer.bounds)// - CGRectGetMidX(circleFrame)
        circleFrame.origin.y = CGRectGetMidX(circlePathLayer.bounds)// - CGRectGetMidY(circleFrame)
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
        
        // This has either a height of 0 or a adaptive height
        label.hidden = (bounds.height == bounds.width)
        label.frame = CGRectMake(0, CGRectGetMaxX(bounds), CGRectGetWidth(bounds), bounds.height - 2*circleRadius)
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
    // Drawing code
    }
    */
    
}

private func indexOf(#dot: DotView, inArray array: [DotView]) -> Int{
    for (index, element) in enumerate(array){
        if(element == dot){
            return index
        }
    }
    
    return -1
}