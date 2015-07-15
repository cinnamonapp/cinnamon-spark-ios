//
//  CSCameraViewController.swift
//  CinnamonSpark
//
//  Created by Alessio Santo on 20/03/15.
//  Copyright (c) 2015 Cinnamon. All rights reserved.
//

import UIKit
import QuartzCore

enum CSCameraFrameModes{
    case SquareFrame
    case FullFrame
}

enum CSCameraButtomModes{
    case TakePicture
    case ConfirmPicture
    case SharePicture
}

@objc
protocol CSCameraViewControllerDelegate : NSObjectProtocol{
    optional func cameraViewController(
        cameraViewController: CSCameraViewController,
        didConfirmPictureWithScaledImage scaledImage: UIImage,
        withSize size: CSFastCameraSize?,
        withServing serving: CSFastCameraServing?,
        andDescription description: String?
    )
}

class CSCameraViewController: UIViewController, FastttCameraDelegate, CSFastCameraSavePictureDelegate, UITextViewDelegate, CSFastCameraViewDelegate {

    var delegate : CSCameraViewControllerDelegate?
    
    // Refactored stuff
    var cameraView : CSFastCameraView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.backgroundColor = UIColor.blackColor()
        
        self.navigationController?.navigationBarHidden = true
        
        cameraView = CSFastCameraView(frame: view.bounds)

        cameraView.delegate = self
        cameraView.configure()
        
        self.view.addSubview(cameraView)
        
        cameraView.aboveCameraToolbarHidden = true
        cameraView.cameraControlsToolbarHidden = true

        cameraView.sizeSelector.selectValueWithIndex(3)
        cameraView.wantsSizeSelectorUserInteractionEnabled = false
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fastCameraDidTapRightControl(fastCamera: CSFastCameraView) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func fastCameraDidTakePictureWithScaledImage(image: UIImage, withSize size: CSFastCameraSize?, andServing serving: CSFastCameraServing?) {
        
    }
    
    func fastCameraDidConfirmPictureWithScaledImage(image: UIImage, withSize size: CSFastCameraSize?, andServing serving: CSFastCameraServing?) {
        let review = CSFastCameraSavePictureViewController(image: image)
        review.selectedSize = size
        review.selectedServing = serving
        review.delegate = self
        self.navigationController?.pushViewController(review, animated: true)
    }
    
    
    func savePictureControllerDidTapRightControl(savePictureController: CSFastCameraSavePictureViewController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func savePictureControllerDidConfirmPictureWithScaledImage(image: UIImage, withSize size: CSFastCameraSize?, withServing serving: CSFastCameraServing?, andDescription description: String?) {
        
        if let ifDelegate = delegate{
            if(ifDelegate.respondsToSelector("cameraViewController:didConfirmPictureWithScaledImage:withSize:withServing:andDescription:")){
                ifDelegate.cameraViewController!(self, didConfirmPictureWithScaledImage: image, withSize: size, withServing: serving, andDescription: description)
            }
        }
    }

}

