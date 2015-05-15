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

class CSCameraViewController: UIViewController, FastttCameraDelegate, UITextViewDelegate {

    var delegate : CSBaseDelegate!
    
    // Camera resources
    var fastCamera : FastttCamera!
    var takenPicture : FastttCapturedImage!
    
    // UIViews
    var tapSelector : CSMealSizeSelector!
    var retakeButton : UIBarButtonItem!
    var stillImageView : UIImageView!
    var cameraButton : UIButton!
    var titleInputField : UITextView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        self.title = "What did you have?"
        
        self.view.backgroundColor = UIColor.blackColor()
        
        self.initiateCamera(CSCameraFrameModes.SquareFrame)
        self.displayCamera()
        
        self.initiateTapSelector()
        self.displayTapSelector()
        
        self.initiateRetakeButton()
        
        self.initiateCameraButton()
        self.displayCameraButton(CSCameraButtomModes.TakePicture)
        
        self.displayCloseButton()
        
        self.initiateTitleInputField()
        
        self.navigationController?.navigationBar.translucent = true
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.alpha = 0
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.tintColor = mainActionColor
        
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
        
        tapSelector = CSMealSizeSelector(mirrorView: self.fastCamera.view)
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
        fastCamera.interfaceRotatesWithOrientation = false
        fastCamera.returnsRotatedPreview = false
        
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
        self.cameraButton.backgroundColor = UIColor(red: 169/255, green: 179/255, blue: 140/255, alpha: 1)
    }
    
    func displayCameraButton(mode: CSCameraButtomModes){
        switch mode{
        case .TakePicture:
            self.cameraButton.setTitle("Take picture", forState: UIControlState.Normal)
            self.cameraButton.removeTarget(self, action: "confirmPicture", forControlEvents: UIControlEvents.TouchUpInside)
            self.cameraButton.removeTarget(self, action: "savePicture", forControlEvents: UIControlEvents.TouchUpInside)
            self.cameraButton.addTarget(self, action: "takePicture", forControlEvents: UIControlEvents.TouchUpInside)
        break
        case .ConfirmPicture:
            self.cameraButton.setTitle("Looks good!", forState: UIControlState.Normal)
            self.cameraButton.removeTarget(self, action: "takePicture", forControlEvents: UIControlEvents.TouchUpInside)
            self.cameraButton.removeTarget(self, action: "savePicture", forControlEvents: UIControlEvents.TouchUpInside)
            self.cameraButton.addTarget(self, action: "confirmPicture", forControlEvents: UIControlEvents.TouchUpInside)
        case .SharePicture:
            self.cameraButton.setTitle("Save", forState: UIControlState.Normal)
            self.cameraButton.removeTarget(self, action: "takePicture", forControlEvents: UIControlEvents.TouchUpInside)
            self.cameraButton.removeTarget(self, action: "confirmPicture", forControlEvents: UIControlEvents.TouchUpInside)
            self.cameraButton.addTarget(self, action: "savePicture", forControlEvents: UIControlEvents.TouchUpInside)
        break
        default:
            self.displayCameraButton(.TakePicture)
        }
        
        self.view.addSubview(self.cameraButton)
    }
    
    // Method called when the users presses the take a picture button
    func takePicture(){
        self.fastCamera.takePicture()
    }
    
    // Method called when the user presses the confirm button
    func confirmPicture(){
        self.displayTitleInputField()
        self.displayCameraButton(.SharePicture)
    }
    
    // Method called by the final button
    func savePicture(){
        
        let image = self.takenPicture.scaledImage
        let imageData = UIImageJPEGRepresentation(image, 0.7)
        
        var title = self.titleInputField.text
        if(title == "Tell me more..."){
            title = ""
        }
        
        let params = [
            "meal_record": [
                "title": title,
                "size": self.tapSelector.selectedValue() as Int
            ]
        ]
        
        CSAPIRequest().createMealRecord(params, withImageData: imageData, delegate: self.delegate as? CSAPIRequestDelegate)
        
        if let cameraDelegate = self.delegate as? CSCameraDelegate{
            cameraDelegate.didTakePicture!(image, withSelectionValue: self.tapSelector.selectedValue())
        }
        
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
        
        self.prepareTitleInputFieldForReuse()
        
        self.displayCamera()
        self.prepareStillImageViewForReuse()
        
        self.displayTapSelector()
        
        self.displayCameraButton(CSCameraButtomModes.TakePicture)
        
        self.displayCloseButton()
    }
    
    // MARK: - Close button
    func displayCloseButton(){
        let buttonItem = UIBarButtonItem(title: "Close", style: UIBarButtonItemStyle.Plain, target: self, action: "closeViewController")
        self.navigationItem.leftBarButtonItem = buttonItem
    }

    // MARK: - Title input field
    func initiateTitleInputField(){
        let mainScreen = UIScreen.mainScreen().bounds
        let x : CGFloat = 10.0
        let barHeight = self.navigationController?.navigationBar.frame.height
        let y : CGFloat = 10.0 + barHeight!
        let height : CGFloat = 100.0
        let width : CGFloat = mainScreen.width - 2.0 * x
        self.titleInputField = UITextView(frame: CGRectMake(x, y, width, height))
        self.titleInputField.textColor = UIColor.whiteColor()
        self.titleInputField.backgroundColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        self.titleInputField.keyboardType = UIKeyboardType.Twitter
        self.titleInputField.delegate = self
        self.titleInputField.text = "Tell me more..."
    }
    
    func displayTitleInputField(){
        self.view.addSubview(self.titleInputField)
    }
    
    func prepareTitleInputFieldForReuse(){
        self.titleInputField.removeFromSuperview()
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        self.navigationItem.rightBarButtonItem = nil
        self.displayRetakeButton()
        
        if(textView.text == ""){
            textView.text = "Tell me more..."
        }
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        let button = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: textView, action: "resignFirstResponder")
    
        self.navigationItem.rightBarButtonItem = button
        self.prepareRetakeButtonForReuse()
        
        if(textView.text == "Tell me more..."){
            textView.text = ""
        }
    }
    
    // MARK: - Still image
    
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
    
    // MARK: - Title input field
    
    
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

