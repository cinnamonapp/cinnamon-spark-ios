//
//  CSFastCameraControls.swift
//  Cinnamon
//
//  Created by Alessio Santo on 15/05/15.
//  Copyright (c) 2015 Cinnamon. All rights reserved.
//

import Foundation


class CSShutterButton : UIButton{
    
    private var circlePath : CAShapeLayer!
    private var outerCirclePath : CAShapeLayer!
    private var okayLabel : UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        okayLabel = UILabel()
        okayLabel.textAlignment = NSTextAlignment.Center
        okayLabel.textColor = UIColor.whiteColor()
        okayLabel.font = UIFont(name: "Futura", size: 18)
        okayLabel.text = "OK"
        self.addSubview(okayLabel)
        
        circlePath = CAShapeLayer()
        circlePath.fillColor   = UIColor.whiteColor().CGColor
        
        outerCirclePath = CAShapeLayer()
        outerCirclePath.lineWidth = 3
        outerCirclePath.fillColor = UIColor.clearColor().CGColor
        outerCirclePath.strokeColor = UIColor.whiteColor().CGColor
        circlePath.addSublayer(outerCirclePath)
        
        layer.addSublayer(circlePath)
    }
    
    var shutterRadius: CGFloat {
        get {
            return bounds.height / 2 - 6
        }
    }
    
    var outerRadius: CGFloat{
        get{
            return bounds.height / 2
        }
    }
    
    func circleFrame() -> CGRect {
        var circleFrame = CGRect(x: 0, y: 0, width: 2*shutterRadius, height: 2*shutterRadius)
        
        circleFrame.origin.x = CGRectGetMidX(circlePath.bounds) - CGRectGetMidX(circleFrame)
        circleFrame.origin.y = CGRectGetMidY(circlePath.bounds) - CGRectGetMidY(circleFrame)
        
        return circleFrame
    }
    
    func outerCircleFrame() -> CGRect {
        var circleFrame = CGRect(x: 0, y: 0, width: 2*outerRadius, height: 2*outerRadius)
        
        return circleFrame
    }
    
    func getCirclePath() -> UIBezierPath {
        return UIBezierPath(ovalInRect: circleFrame())
    }
    
    func getOuterCirclePath() -> UIBezierPath {
        return UIBezierPath(ovalInRect: outerCircleFrame())
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func switchToOkayLabel(){
        circlePath.removeFromSuperlayer()
    }
    
    func switchToShutterIcon(){
        layer.addSublayer(circlePath)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        okayLabel.frame     = bounds
        
        circlePath.frame    = bounds
        outerCirclePath.frame    = bounds
        circlePath.path     = getCirclePath().CGPath
        outerCirclePath.path     = getOuterCirclePath().CGPath
    }
    
}

class CSFastCameraControls : UIView{
    let shutterButton : CSShutterButton = CSShutterButton(frame: CGRectMake(0, 0, 65, 65))
    
    let rightControl    : UIButton = UIButton(frame: CGRectMake(0, 0, 40, 40))
    let leftControl     : UIButton = UIButton(frame: CGRectMake(0, 0, 40, 40))
    
    var delegate : CSFastCameraControlsDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        shutterButton.addTarget(self, action: "didTapShutterButton", forControlEvents: UIControlEvents.TouchUpInside)
        self.addSubview(shutterButton)
        
        rightControl.addTarget(self, action: "didTapRightControl", forControlEvents: UIControlEvents.TouchUpInside)
        self.addSubview(rightControl)

        leftControl.addTarget(self, action: "didTapLeftControl", forControlEvents: UIControlEvents.TouchUpInside)
        self.addSubview(leftControl)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func didTapShutterButton(){
        if let ifDelegate = delegate{
            if(ifDelegate.respondsToSelector("fastCameraControlsDidTapShutterButton:")){
                ifDelegate.fastCameraControlsDidTapShutterButton(self)
            }
        }
    }
    
    func didTapRightControl(){
        if let ifDelegate = delegate{
            if(ifDelegate.respondsToSelector("fastCameraControlsDidTapRightControl:")){
                ifDelegate.fastCameraControlsDidTapRightControl(self)
            }
        }
    }
    
    func didTapLeftControl(){
        if let ifDelegate = delegate{
            if(ifDelegate.respondsToSelector("fastCameraControlsDidTapLeftControl:")){
                ifDelegate.fastCameraControlsDidTapLeftControl(self)
            }
        }
    }
    
    override func layoutSubviews() {
        shutterButton.frame.origin.x = CGRectGetMidX(bounds) - shutterButton.frame.width / 2
        shutterButton.frame.origin.y = CGRectGetMidY(bounds) - shutterButton.frame.height / 2
        
        rightControl.frame.origin.x = CGRectGetMaxX(bounds) - rightControl.frame.width - 20
        rightControl.frame.origin.y = CGRectGetMidY(bounds) - rightControl.frame.height / 2
        
        leftControl.frame.origin.x = 20
        leftControl.frame.origin.y = CGRectGetMidY(bounds) - rightControl.frame.height / 2
        
    }
}

protocol CSFastCameraControlsDelegate : NSObjectProtocol{
    func fastCameraControlsDidTapRightControl(fastCameraControls: CSFastCameraControls)
    func fastCameraControlsDidTapLeftControl(fastCameraControls: CSFastCameraControls)
    func fastCameraControlsDidTapShutterButton(fastCameraControls: CSFastCameraControls)
}