//
//  CSFastCameraSavePictureViewController.swift
//  Cinnamon
//
//  Created by Alessio Santo on 18/05/15.
//  Copyright (c) 2015 Cinnamon. All rights reserved.
//

import UIKit

@objc
protocol CSFastCameraSavePictureDelegate : NSObjectProtocol{
    optional func savePictureControllerDidTapRightControl(savePictureController: CSFastCameraSavePictureViewController)
    
    func savePictureControllerDidConfirmPictureWithScaledImage(image: UIImage, withSize size: CSFastCameraSize?, withServing serving: CSFastCameraServing?, andDescription decription: String?)
}

class CSFastCameraSavePictureViewController: UIViewController, CSFastCameraControlsDelegate, UITextViewDelegate {

    var backgroundImage : UIImage?{
        get{
            return _backgroundImageView.image
        }
        
        set{
            _backgroundImageView.image = newValue
        }
    }
    var _backgroundImageView : UIImageView!
    
    var foregroundImage : UIImage?{
        get{
            return _foregroundImageView.image
        }
        
        set{
            _foregroundImageView.image = newValue
        }
    }
    var _foregroundImageView : UIImageView!
    
    var imageDetailsView : UIView!
    var imageDetailsTextField : UITextView!
    var cameraControlsView : CSFastCameraControls!
    
    var delegate : CSFastCameraSavePictureDelegate?
    
    // They can be set up on itinialization
    var selectedServing : CSFastCameraServing?
    var selectedSize : CSFastCameraSize?
    
    var _originalPicture : UIImage?
    
    convenience init(image: UIImage!){
        self.init()
        configure()
        
        _originalPicture = image
        
        var blurredImage = image.applyBlurWithRadius(CGFloat(8), tintColor: nil, saturationDeltaFactor: 1, maskImage: nil)
        blurredImage = blurredImage.imageRotatedByDegrees(90, flip: false)
        
        self.backgroundImage = blurredImage
        self.foregroundImage = image
    }
    
    func configure(){
        _backgroundImageView = UIImageView()
        _foregroundImageView = UIImageView()
        
        _backgroundImageView.contentMode = UIViewContentMode.ScaleAspectFill
        
        imageDetailsView = UIView()
        imageDetailsView.backgroundColor = UIColorFromHex(0x000000, alpha: 0.8)

        imageDetailsView.addSubview(_foregroundImageView)
        
        imageDetailsTextField = UITextView()
        imageDetailsTextField.backgroundColor = UIColor.clearColor()
        imageDetailsTextField.textColor = UIColor.whiteColor()
        imageDetailsTextField.font = UIFont(name: "Futura", size: 18)
        imageDetailsTextField.autocorrectionType = UITextAutocorrectionType.No
        imageDetailsTextField.keyboardType = UIKeyboardType.Twitter
        imageDetailsTextField.text = "Tell me more..."
        imageDetailsTextField.delegate = self
        imageDetailsTextField.textColor = UIColor.lightGrayColor()
        imageDetailsTextField.selectedTextRange = imageDetailsTextField.textRangeFromPosition(imageDetailsTextField.beginningOfDocument, toPosition: imageDetailsTextField.beginningOfDocument)
        imageDetailsTextField.keyboardAppearance = UIKeyboardAppearance.Dark
        
        imageDetailsTextField.becomeFirstResponder()
        
        imageDetailsView.addSubview(imageDetailsTextField)
        
        cameraControlsView = CSFastCameraControls(frame: CGRectMake(0, 0, 100, 60))
        cameraControlsView.backgroundColor = UIColorFromHex(0x000000, alpha: 0.8)
        
        cameraControlsView.shutterButton.switchToOkayLabel()
    
        let cancelButtonImageView = UIImageView(image: UIImage(named: "CameraCancelButton"))
        cancelButtonImageView.frame = CGRectMake(0, 0, 40, 40)
        cameraControlsView.rightControl.addSubview(cancelButtonImageView)
        
//        let backButtonImageView = UIImageView(image: UIImage(named: "CameraBackButton"))
//        backButtonImageView.frame = CGRectMake(0, 0, 40, 40)
//        cameraControlsView.leftControl.addSubview(backButtonImageView)

        let toolbar = CSFastCameraControls(frame: CGRectMake(0, 0, 100, 60))
        
        toolbar.delegate = self
        
        let toolbarCancelButtonImageView = UIImageView(image: UIImage(named: "CameraCancelButton"))
        toolbarCancelButtonImageView.frame = CGRectMake(0, 0, 40, 40)
        
//        let toolbarBackButtonImageView = UIImageView(image: UIImage(named: "CameraBackButton"))
//        toolbarBackButtonImageView.frame = CGRectMake(0, 0, 40, 40)
        
        toolbar.backgroundColor = UIColorFromHex(0x000000, alpha: 0.8)
        toolbar.shutterButton.switchToOkayLabel()
        toolbar.rightControl.addSubview(toolbarCancelButtonImageView)
//        toolbar.leftControl.addSubview(toolbarBackButtonImageView)
        imageDetailsTextField.inputAccessoryView = toolbar
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.addSubview(_backgroundImageView)
        self.view.addSubview(imageDetailsView)
        self.view.addSubview(cameraControlsView)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        _backgroundImageView.frame = view.bounds
        imageDetailsView.frame = CGRectMake(0, 50, CGRectGetWidth(view.bounds), 100)
        _foregroundImageView.frame = CGRectMake(15, 15, 70, 70)
        imageDetailsTextField.frame = CGRectMake(
            CGRectGetMaxX(_foregroundImageView.frame) + 15,
            CGRectGetMinY(_foregroundImageView.frame),
            CGRectGetWidth(imageDetailsView.bounds) - CGRectGetMaxX(_foregroundImageView.frame) - 30,
            CGRectGetHeight(imageDetailsView.bounds) - 30
        )
        
        cameraControlsView.frame = CGRectMake(
            CGRectGetMinX(view.bounds),
            CGRectGetHeight(view.bounds) - 60,
            CGRectGetWidth(view.bounds),
            60
        )
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        // Combine the textView text and the replacement text to
        // create the updated text string
        let currentText:NSString = textView.text
        let updatedText = currentText.stringByReplacingCharactersInRange(range, withString:text)
        
        // If updated text view will be empty, add the placeholder
        // and set the cursor to the beginning of the text view
        if countElements(updatedText) == 0 {
            
            textView.text = "Tell me more..."
            textView.textColor = UIColor.lightGrayColor()
            
            textView.selectedTextRange = textView.textRangeFromPosition(textView.beginningOfDocument, toPosition: textView.beginningOfDocument)
            
            return false
        }
            
            // Else if the text view's placeholder is showing and the
            // length of the replacement string is greater than 0, clear
            // the text view and set its color to black to prepare for
            // the user's entry
        else if textView.textColor == UIColor.lightGrayColor() && countElements(text) > 0 {
            textView.text = nil
            textView.textColor = UIColor.whiteColor()
        }
        
        return true
    }
    
    // MARK: - CSFastCameraControlsDelegate
    func fastCameraControlsDidTapLeftControl(fastCameraControls: CSFastCameraControls) {
        
    }
    
    func fastCameraControlsDidTapRightControl(fastCameraControls: CSFastCameraControls) {
        if let ifDelegate = delegate{
            if(ifDelegate.respondsToSelector("savePictureControllerDidTapRightControl:")){
                ifDelegate.savePictureControllerDidTapRightControl!(self)
            }
        }
    }
    
    func fastCameraControlsDidTapShutterButton(fastCameraControls: CSFastCameraControls) {
        if let ifDelegate = delegate{
            if(ifDelegate.respondsToSelector("savePictureControllerDidConfirmPictureWithScaledImage:withSize:withServing:andDescription:")){
                ifDelegate.savePictureControllerDidConfirmPictureWithScaledImage(_originalPicture!, withSize: selectedSize, withServing: selectedServing, andDescription: imageDetailsTextField.text)
            }
        }

    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
