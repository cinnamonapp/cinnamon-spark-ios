//
//  CSFastCameraView.swift
//  Cinnamon
//
//  Created by Alessio Santo on 15/05/15.
//  Copyright (c) 2015 Cinnamon. All rights reserved.
//

import UIKit

class CSFastCameraView: UIView {

    var parentViewController : UIViewController?
    
    var cameraView : FastttCamera!

    var aboveCameraToolbar : UIView!
    var measurementLabel : UILabel!
    
    var sizeSelector : CSFastCameraSizeSelector!
    
    var cameraControlsToolbar : UIView!
    var servingSelector : CSFastCameraServingSelector!
    
    var cameraControlsView : CSFastCameraControls!
    
    
    override init(){
        super.init()
    }
    
    override init(frame: CGRect){
        super.init(frame: frame)
    }
    
    convenience init(parentViewController: UIViewController){
        self.init()
        frame = parentViewController.view.frame
        self.parentViewController = parentViewController
        configure()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    
    private func configure(){
        
        let backColor = UIColorFromHex(0x000000, alpha: 0.9)
        
        // The camera
        cameraView = FastttCamera()
        
        cameraView.handlesTapFocus                  = false
        cameraView.showsFocusView                   = false
//        cameraView.delegate                         = self
        cameraView.interfaceRotatesWithOrientation  = false
        cameraView.returnsRotatedPreview            = false
        
        cameraView.view.frame               = frame
//        cameraView.view.frame.size.height   = frame.width
        
        self.addSubview(cameraView.view)
        
        cameraControlsView = CSFastCameraControls(frame: CGRectMake(0, 0, frame.width, 40))
        cameraControlsView.backgroundColor = backColor
        
        sizeSelector = CSFastCameraSizeSelector(frame: frame, values: [])
        sizeSelector.frame.size.height = frame.width
//        sizeSelector.backgroundColor = UIColorFromHex(0xffffff, alpha: 0.5)
        sizeSelector.frame.origin.y = CGRectGetMidY(frame) - sizeSelector.frame.height / 2 - cameraControlsView.frame.height
        
        self.addSubview(sizeSelector)
        
        aboveCameraToolbar = UIView(frame: CGRectMake(0, 0, frame.width, sizeSelector.frame.origin.y))
        aboveCameraToolbar.backgroundColor = backColor
        self.addSubview(aboveCameraToolbar)
        
        // The toolbar
        cameraControlsToolbar = UIView(frame: CGRectMake(0, CGRectGetMaxY(sizeSelector.frame), bounds.width, 40))
        cameraControlsToolbar.backgroundColor = backColor
        servingSelector = CSFastCameraServingSelector(frame: cameraControlsToolbar.bounds, servings: [CSFastCameraServing(id: 1, name: "Cups"), CSFastCameraServing(id: 2, name: "Piece")])
        cameraControlsToolbar.addSubview(servingSelector)
        self.addSubview(cameraControlsToolbar)
        
        cameraControlsView.frame.origin.y = CGRectGetMaxY(cameraControlsToolbar.frame)
        cameraControlsView.frame.size.height = frame.height - CGRectGetMaxY(cameraControlsToolbar.frame)
        let cancelButtonImageView = UIImageView(image: UIImage(named: "CameraCancelButton"))
        cancelButtonImageView.frame = CGRectMake(0, 0, 40, 40)
        cameraControlsView.rightControl.addSubview(cancelButtonImageView)
        self.addSubview(cameraControlsView)
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}



class CGFastCameraSize : NSObject{
    var id : Int!
    var name : String!
}

class CSFastCameraSizeSelector : UIView{
    
    var backgroundLayer : CALayer!
    var maskCircleLayer : CAShapeLayer!
    
    override init(){
        super.init()
    }
    override init(frame: CGRect){
        super.init(frame: frame)
    }
    
    convenience init(frame: CGRect, values: [CGFastCameraSize]!){
        self.init()
        self.frame = frame
        configure()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configure(){
        backgroundLayer = CALayer()
        backgroundLayer.backgroundColor = UIColorFromHex(0xffffff, alpha: 0.5).CGColor
        backgroundLayer.frame = bounds
//        layer.addSublayer(backgroundLayer)
        
        maskCircleLayer = CAShapeLayer()
        maskCircleLayer.fillRule = kCAFillRuleEvenOdd
        
        let path : CGMutablePathRef = CGPathCreateMutable()
        CGPathAddPath(path, nil, CGPathCreateWithRect(bounds, nil))
        CGPathAddPath(path, nil, CGPathCreateWithEllipseInRect(bounds, nil))
        maskCircleLayer.path = path
        
        backgroundLayer.mask = maskCircleLayer
        layer.addSublayer(backgroundLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

//        backgroundLayer.frame = bounds
//        backgroundLayer.path = CGPathCreateWithRect(bounds, nil)
//        
//        maskCircleLayer.frame = bounds
//        maskCircleLayer.path = CGPathCreateWithRect(CGRectMake(0, 0, 100, 100), nil)
    }
    
}