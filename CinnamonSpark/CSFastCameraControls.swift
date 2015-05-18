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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        circlePath = CAShapeLayer()
        circlePath.frame       = bounds
        
        circlePath.fillColor   = UIColor.whiteColor().CGColor
        
        layer.addSublayer(circlePath)
    }
    
    var shutterRadius: CGFloat {
        get {
            return bounds.height / 2
        }
    }
    
    func circleFrame() -> CGRect {
        var circleFrame = CGRect(x: 0, y: 0, width: 2*shutterRadius, height: 2*shutterRadius)
        
        //        circleFrame.origin.x = CGRectGetMidX(circlePath.bounds)// - CGRectGetMidX(circleFrame)
        //        circleFrame.origin.y = CGRectGetMidY(circlePath.bounds)// - CGRectGetMidY(circleFrame)
        return circleFrame
    }
    
    func getCirclePath() -> UIBezierPath {
        return UIBezierPath(ovalInRect: circleFrame())
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        circlePath.frame.size    = frame.size
        circlePath.path     = getCirclePath().CGPath
    }
}
class CSFastCameraControls : UIView{
    var shutterButton : CSShutterButton!
    
    var rightControl : UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        shutterButton = CSShutterButton(frame: CGRectMake(0, 0, 40, 40))
        self.addSubview(shutterButton)
        
        rightControl = UIButton(frame: CGRectMake(0, 0, 40, 40))
        self.addSubview(rightControl)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        shutterButton.frame.origin.x = CGRectGetMidX(bounds) - shutterButton.frame.width / 2
        shutterButton.frame.origin.y = CGRectGetMidY(bounds) - shutterButton.frame.height / 2
        
        rightControl.frame.origin.x = CGRectGetMaxX(bounds) - rightControl.frame.width - 20
        rightControl.frame.origin.y = CGRectGetMidY(bounds) - rightControl.frame.height / 2
        
    }
}