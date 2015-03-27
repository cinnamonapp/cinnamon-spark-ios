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
}

class CSCameraViewController: UIViewController, FastttCameraDelegate {

    // The camera
    var fastCamera : FastttCamera!
    var stillImageView : UIImageView!
    var cameraButton : UIButton!
    var delegate : CSBaseDelegate!
    var tapSelector : CSTapSelector!
    var retakeButton : UIBarButtonItem!
    var takenPicture : FastttCapturedImage!
    
    private let apiUrl = "http://murmuring-dusk-8873.herokuapp.com/meal_records.json"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.backgroundColor = UIColor.blackColor()
        
        self.initiateCamera(CSCameraFrameModes.SquareFrame)
        self.displayCamera()
        
        self.initiateTapSelector()
        self.displayTapSelector()
        
        self.initiateRetakeButton()
        
        self.initiateCameraButton()
        self.displayCameraButton(CSCameraButtomModes.TakePicture)
        
        let buttonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Stop, target: self, action: "closeViewController")
        self.navigationItem.rightBarButtonItem = buttonItem
        self.navigationController?.navigationBar.translucent = true
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.alpha = 0
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        
        self.view.addSubview(cameraButton)
        
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Tap selector
    func initiateTapSelector(){
        let mainScreen = UIScreen.mainScreen().bounds
        
        tapSelector = CSTapSelector(values: [1, 2, 3],
            origin: CGPointMake(CGRectGetMidX(self.fastCamera.view.frame), CGRectGetMidY(self.fastCamera.view.frame)),
            minimumRadius: nil,
            maximumRadius: Float(mainScreen.size.width / 2.0) - 20.0)
    }
    
    func displayTapSelector(){
        self.view.addSubview(tapSelector)
    }
    
    func prepareTapSelectorForReuse(){
        self.tapSelector.removeFromSuperview()
    }
    
    //MARK: - Fast camera
    
    func prepareCameraForReuse(){
        self.fastttRemoveChildViewController(fastCamera)
    }
    
    func displayCamera(){
        self.fastttAddChildViewController(fastCamera)
    }
    
    func initiateCamera(frameMode: CSCameraFrameModes){
        
        let mainScreen = UIScreen.mainScreen().bounds
        
        fastCamera = FastttCamera()
        fastCamera.handlesTapFocus = false
        fastCamera.showsFocusView = false
        fastCamera.delegate = self
        
        fastCamera.view.frame = self.view.frame
        
        if(frameMode == .SquareFrame){
            fastCamera.view.frame.size.height = self.view.frame.width
            
            // Add some top space equals the navigation bar's height
            if let navigationBarHeight = self.navigationController?.navigationBar{
                fastCamera.view.frame.origin.y = navigationBarHeight.frame.height
            }
            
        }
        
    }
    
    // MARK: - Camera button
    
    func initiateCameraButton(){
        let mainScreen = UIScreen.mainScreen().bounds
        
        self.cameraButton = UIButton(frame: CGRectMake(0, mainScreen.size.height - 50, mainScreen.size.width, 50))
        self.cameraButton.titleLabel?.textAlignment = NSTextAlignment.Center
    }
    
    func displayCameraButton(mode: CSCameraButtomModes){
        switch mode{
        case .TakePicture:
            self.cameraButton.setTitle("Take picture", forState: UIControlState.Normal)
            self.cameraButton.removeTarget(self, action: "confirmPicture", forControlEvents: UIControlEvents.TouchUpInside)
            self.cameraButton.addTarget(self, action: "takePicture", forControlEvents: UIControlEvents.TouchUpInside)
        break
        case .ConfirmPicture:
            self.cameraButton.setTitle("Confirm", forState: UIControlState.Normal)
            self.cameraButton.removeTarget(self, action: "takePicture", forControlEvents: UIControlEvents.TouchUpInside)
            self.cameraButton.addTarget(self, action: "confirmPicture", forControlEvents: UIControlEvents.TouchUpInside)
        break
        default:
            self.displayCameraButton(.TakePicture)
        }
    }
    
    func takePicture(){
        self.fastCamera.takePicture()
    }
    
    func confirmPicture(){
        let image = self.takenPicture.scaledImage
        let imageData = UIImageJPEGRepresentation(image, 0.7)
        
//        println(self.tapSelector.selectedValue())
        
        CSAPIRequest().createMealRecord(self.tapSelector.selectedValue() as Int, withImageData: imageData, delegate: self.delegate as? CSAPIRequestDelegate)
        
        if let cameraDelegate = self.delegate as? CSCameraDelegate{
            cameraDelegate.didTakePicture!(image, withSelectionValue: self.tapSelector.selectedValue())
        }
    
        self.closeViewController()

    }
    
    // MARK: - Retake button
    
    func initiateRetakeButton(){
        self.retakeButton = UIBarButtonItem(title: "Retake", style: UIBarButtonItemStyle.Plain, target: self, action: "retakeButtonPressed")
    }
    
    func displayRetakeButton(){
        self.navigationItem.leftBarButtonItem = retakeButton
    }
    
    func prepareRetakeButtonForReuse(){
        self.navigationItem.leftBarButtonItem = nil
    }

    func retakeButtonPressed(){
        self.prepareRetakeButtonForReuse()
        
        self.displayCamera()
        self.prepareStillImageViewForReuse()
        
        self.displayTapSelector()
        
        self.displayCameraButton(CSCameraButtomModes.TakePicture)
    }

    //MARK: - Still image
    
    func initiateStillImageView(frame: CGRect){
        self.stillImageView = UIImageView()
        self.stillImageView.frame = frame
    }
    
    func prepareStillImageViewForReuse(){
        self.stillImageView.removeFromSuperview()
    }
    
    func displayStillImageViewWithImage(image: UIImage){
        self.stillImageView.image = image
        self.view.addSubview(stillImageView)
    }
    

    
    
    func closeViewController(){
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - FastttCameraDelegate methods
    
    func cameraController(cameraController: FastttCameraInterface!, didFinishScalingCapturedImage capturedImage: FastttCapturedImage!) {
        
        self.takenPicture = capturedImage

        self.prepareCameraForReuse()
        self.initiateStillImageView(self.fastCamera.view.frame)
        self.displayStillImageViewWithImage(capturedImage.scaledImage)
        
        self.displayRetakeButton()
        
        self.displayCameraButton(CSCameraButtomModes.ConfirmPicture)
        
    }

}

