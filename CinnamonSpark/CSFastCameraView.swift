//
//  CSFastCameraView.swift
//  Cinnamon
//
//  Created by Alessio Santo on 15/05/15.
//  Copyright (c) 2015 Cinnamon. All rights reserved.
//

import UIKit

@objc protocol CSFastCameraViewDelegate : NSObjectProtocol{
    
    optional func fastCameraDidTapRightControl(fastCamera: CSFastCameraView)
    optional func fastCameraDidTapLeftControl(fastCamera: CSFastCameraView)
    optional func fastCameraDidTapShutterButton(fastCamera: CSFastCameraView)
    
    func fastCameraDidTakePictureWithScaledImage(image: UIImage, withSize size: CSFastCameraSize?, andServing serving: CSFastCameraServing?)
    
    func fastCameraDidConfirmPictureWithScaledImage(image: UIImage, withSize size: CSFastCameraSize?, andServing serving: CSFastCameraServing?)
}

class CSFastCameraView: UIView, FastttCameraDelegate, CSFastCameraSizeSelectorDelegate, CSFastCameraControlsDelegate, CSFastCameraServingSelectorDelegate {
    
    var cameraView : FastttCamera!

    var aboveCameraToolbar : UIView!
    var measurementLabel : UILabel!
    
    var sizeSelector : CSFastCameraSizeSelector!
    
    var cameraControlsToolbar : UIView!
    var servingSelector : CSFastCameraServingSelector!
    
    var cameraControlsView : CSFastCameraControls!

    var delegate : CSFastCameraViewDelegate?
    
    var stillImageView : UIImageView!
    
    var takenPicture : UIImage?
    
    override init(){
        super.init()
    }
    
    override init(frame: CGRect){
        super.init(frame: frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    
    func configure(){
        
        let backColor = UIColorFromHex(0x000000, alpha: 0.9)
        
        // The camera
        cameraView = FastttCamera()
        
        cameraView.handlesTapFocus                  = false
        cameraView.showsFocusView                   = false
        cameraView.delegate                         = self
        cameraView.interfaceRotatesWithOrientation  = false
        cameraView.returnsRotatedPreview            = false
        
        self.addSubview(cameraView.view)
        
        cameraControlsView = CSFastCameraControls(frame: CGRectMake(0, 0, frame.width, 40))
        cameraControlsView.backgroundColor = backColor
        
        
        stillImageView = UIImageView()
        self.addSubview(stillImageView)
        
        // Size selector
        sizeSelector = CSFastCameraSizeSelector(frame: frame, values: [])
        sizeSelector.delegate = self
        
        self.addSubview(sizeSelector)
        
        
        // Above camera toolbar
        aboveCameraToolbar = UIView()
        aboveCameraToolbar.backgroundColor = backColor
        
        measurementLabel = UILabel()
        measurementLabel.textColor = UIColor.whiteColor()
        measurementLabel.font = UIFont(name: "Futura", size: 18)
        measurementLabel.text = textForSelectedSize(sizeSelector.selectedValue)
        measurementLabel.textAlignment = NSTextAlignment.Center
        aboveCameraToolbar.addSubview(measurementLabel)
        self.addSubview(aboveCameraToolbar)
        
        // The camera controls toolbar
        cameraControlsToolbar = UIView()
        cameraControlsToolbar.backgroundColor = backColor
        
        servingSelector = CSFastCameraServingSelector(frame: cameraControlsToolbar.bounds, servings: [CSFastCameraServing(id: 1, name: "Cup"), CSFastCameraServing(id: 2, name: "Piece")])
        self.servingSelectorDidChangeSelectedValue(servingSelector, selectedValue: servingSelector.selectedServing)
        servingSelector.servingSelectorDelegate = self
        cameraControlsToolbar.addSubview(servingSelector)
        
        self.addSubview(cameraControlsToolbar)
        
        
        
        // Camera controls
        cameraControlsView.delegate = self
        let cancelButtonImageView = UIImageView(image: UIImage(named: "CameraCancelButton"))
        cancelButtonImageView.frame = CGRectMake(0, 0, 40, 40)
        cameraControlsView.rightControl.addSubview(cancelButtonImageView)
        
        let backButtonImageView = UIImageView(image: UIImage(named: "CameraBackButton"))
        backButtonImageView.frame = CGRectMake(0, 0, 40, 40)
        cameraControlsView.leftControl.addSubview(backButtonImageView)
        self.addSubview(cameraControlsView)
    }
    
    
    func sizeSelectorDidChangeSelectedValue(sizeSelector: CSFastCameraSizeSelector!, selectedValue: CSFastCameraSize?) {
        measurementLabel.text = textForSelectedSize(selectedValue)
    }
    
    func textForSelectedSize(selectedSize: CSFastCameraSize?) -> String{
        if let selected = selectedSize{
            return selected.name
        }else{
            return "None"
        }
    }
    
    func fastCameraControlsDidTapShutterButton(fastCameraControls: CSFastCameraControls) {
        if let ifDelegate = delegate{
            if(ifDelegate.respondsToSelector("fastCameraDidTapShutterButton:")){
                ifDelegate.fastCameraDidTapShutterButton!(self)
            }
        }
        
        if(stillImageView.image == nil){
            cameraView.takePicture()
            cameraControlsView.shutterButton.userInteractionEnabled = false
        }else{
            if let ifDelegate = delegate{
                if(ifDelegate.respondsToSelector("fastCameraDidConfirmPictureWithScaledImage:withSize:andServing:")){
                    ifDelegate.fastCameraDidConfirmPictureWithScaledImage(stillImageView.image!, withSize: sizeSelector.selectedValue, andServing: servingSelector.selectedServing)
                }
            }
        }
    }
    
    
    func fastCameraControlsDidTapRightControl(fastCameraControls: CSFastCameraControls) {
        if let ifDelegate = delegate{
            if(ifDelegate.respondsToSelector("fastCameraDidTapRightControl:")){
                ifDelegate.fastCameraDidTapRightControl!(self)
            }
        }
    }
    
    func fastCameraControlsDidTapLeftControl(fastCameraControls: CSFastCameraControls) {
        if let ifDelegate = delegate{
            if(ifDelegate.respondsToSelector("fastCameraDidTapLeftControl:")){
                ifDelegate.fastCameraDidTapLeftControl!(self)
            }
        }
        
        stillImageView.image = nil
        self.setNeedsLayout()
    }
    
    func servingSelectorDidChangeSelectedValue(servingSelector: CSFastCameraServingSelector, selectedValue: CSFastCameraServing?) {
        
        if let value = selectedValue{
            if(value.id == 1){
                sizeSelector.values = [
                    CSFastCameraSize(id: 1, name: "0.5 cup"),
                    CSFastCameraSize(id: 2, name: "1 cup"),
                    CSFastCameraSize(id: 3, name: "1.5 cups"),
                    CSFastCameraSize(id: 4, name: "2 cups")
                ]
                
            }
            
            if(value.id == 2){
                sizeSelector.values = [
                    CSFastCameraSize(id: 1, name: "Extra small"),
                    CSFastCameraSize(id: 2, name: "Small"),
                    CSFastCameraSize(id: 3, name: "Medium"),
                    CSFastCameraSize(id: 4, name: "Large")
                ]
            }
        }
        
    }
    
    func cameraController(cameraController: FastttCameraInterface!, didFinishScalingCapturedImage capturedImage: FastttCapturedImage!) {
        
        cameraControlsView.shutterButton.userInteractionEnabled = true
        stillImageView.image = capturedImage.scaledImage
        
        self.setNeedsLayout()
        
        if let ifDelegate = delegate{
            if(ifDelegate.respondsToSelector("fastCameraDidTakePictureWithScaledImage:withSize:andServing:")){
                takenPicture = capturedImage.scaledImage
                ifDelegate.fastCameraDidTakePictureWithScaledImage(capturedImage.scaledImage, withSize: sizeSelector.selectedValue, andServing: servingSelector.selectedServing)
            }
        }
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        if(cameraView == nil){
            println("CSFastCamerView => Please run the configure() method")
            return
        }
        
        if(stillImageView.image != nil){
            cameraControlsView.leftControl.hidden = false
            sizeSelector.userInteractionEnabled = false
            cameraControlsView.shutterButton.switchToOkayLabel()
            cameraControlsToolbar.hidden = true
            measurementLabel.text = "Looks good?"
        }else{
            cameraControlsView.leftControl.hidden = true
            sizeSelector.userInteractionEnabled = true
            cameraControlsView.shutterButton.switchToShutterIcon()
            cameraControlsToolbar.hidden = false
            self.servingSelectorDidChangeSelectedValue(servingSelector, selectedValue: servingSelector.selectedServing)
            
            
        }
        
        cameraControlsView.frame = CGRectMake(0, 0, frame.width, 40)
        
        sizeSelector.frame.size.height = frame.width
        sizeSelector.frame.origin.y = CGRectGetMidY(frame) - sizeSelector.frame.height / 2 - cameraControlsView.frame.height
        
        stillImageView.frame = sizeSelector.frame
        cameraView.view.frame = sizeSelector.frame
        
        aboveCameraToolbar.frame = CGRectMake(0, 0, frame.width, sizeSelector.frame.origin.y)
        measurementLabel.frame = aboveCameraToolbar.frame
        
        cameraControlsToolbar.frame = CGRectMake(0, CGRectGetMaxY(sizeSelector.frame), bounds.width, 40)
        servingSelector.frame = cameraControlsToolbar.bounds
        
        cameraControlsView.frame.origin.y = CGRectGetMaxY(cameraControlsToolbar.frame)
        cameraControlsView.frame.size.height = frame.height - CGRectGetMaxY(cameraControlsToolbar.frame)

    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}

