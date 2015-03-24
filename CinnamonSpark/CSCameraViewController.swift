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

class CSCameraViewController: UIViewController, FastttCameraDelegate {

    var fastCamera : FastttCamera!
    var cameraButton : UIButton!
    var delegate : CSCameraDelegate!
    var tapSelector : CSTapSelector!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let mainScreen = UIScreen.mainScreen().bounds
        
        self.view.backgroundColor = UIColor.blackColor()
        
        self.setCameraView(CSCameraFrameModes.SquareFrame)
        
        let buttonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Stop, target: self, action: "closeViewController")
        self.navigationItem.rightBarButtonItem = buttonItem
        self.navigationController?.navigationBar.translucent = true
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.alpha = 0
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        
        
        self.view.addSubview(cameraButton)

        tapSelector = CSTapSelector(values: ["small", "medium", "large"], origin: CGPointMake(CGRectGetMidX(self.fastCamera.view.frame), CGRectGetMidY(self.fastCamera.view.frame)))
        tapSelector.maxRadius = Float(mainScreen.size.width / 2.0) - 10.0
        tapSelector.refreshFrame()
        
        self.view.addSubview(tapSelector)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setCameraView(frameMode: CSCameraFrameModes){
        
        let mainScreen = UIScreen.mainScreen().bounds
        
        fastCamera = FastttCamera()
        fastCamera.delegate = self
        
        self.fastttAddChildViewController(fastCamera)
        
        if(frameMode == .SquareFrame){
            fastCamera.view.frame = self.view.frame
        }
        
        fastCamera.view.frame.size.height = self.view.frame.width
        
        cameraButton = UIButton(frame: CGRectMake(0, mainScreen.size.height - 50, mainScreen.size.width, 50))
        cameraButton.titleLabel?.textAlignment = NSTextAlignment.Center
        cameraButton.setTitle("Take", forState: UIControlState.Normal)
        cameraButton.addTarget(self, action: "takePicture", forControlEvents: UIControlEvents.TouchUpInside)
        
    }
    
    func closeViewController(){
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func takePicture(){
        fastCamera.takePicture()
        
//        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//        NSDictionary *parameters = @{@"foo": @"bar"};
//        NSURL *filePath = [NSURL fileURLWithPath:@"file://path/to/image.png"];
//        [manager POST:@"http://example.com/resources.json" parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//        [formData appendPartWithFileURL:filePath name:@"image" error:nil];
//        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"Success: %@", responseObject);
//        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"Error: %@", error);
//        }];
        
//        let manager = AFHTTPRequestOperationManager()
//
//        var params = NSDictionary(object: "foo", forKey: "bar")
        
    }

    // MARK: - FastttCameraDelegate methods
    
    func cameraController(cameraController: FastttCameraInterface!, didFinishCapturingImage capturedImage: FastttCapturedImage!) {
        
//        let image = capturedImage.fullImage
//        let imageData = UIImageJPEGRepresentation(image, 0.7)
//        
//        let manager = AFHTTPRequestOperationManager()
//        
//        let params : NSDictionary = [
//            "meal_record": [
//                "size": 2,
//                "carbs_estimate": 3
//            ]
//        ]
//        
//        manager.POST("http://192.168.10.222:3000/meal_records", parameters: params, constructingBodyWithBlock: { (formData: AFMultipartFormData!) -> Void in
//            formData.appendPartWithFileData(imageData, name: "meal_record[photo]", fileName: "testfile.jpeg", mimeType: "image/jpeg")
//            
//        }, success: { (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) -> Void in
//            println(responseObject)
//            
//        }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
//            println("error")
//        }
        
//        self.delegate.didTakePicture!(image, withSelectionValue: tapSelector.selectedValue() as String)
    
//        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func cameraController(cameraController: FastttCameraInterface!, didFinishScalingCapturedImage capturedImage: FastttCapturedImage!) {
        
        let image = capturedImage.scaledImage
        
        let imageData = UIImageJPEGRepresentation(image, 0.5)
        
        let manager = AFHTTPRequestOperationManager()
        
        let params : NSDictionary = [
            "meal_record": [
                "size": 2,
                "carbs_estimate": 3
            ]
        ]
        
        manager.POST("http://192.168.10.222:3000/meal_records", parameters: params, constructingBodyWithBlock: { (formData: AFMultipartFormData!) -> Void in
            formData.appendPartWithFileData(imageData, name: "meal_record[photo]", fileName: "testfile.jpeg", mimeType: "image/jpeg")
            
            }, success: { (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) -> Void in
                println(responseObject)
                
            }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println("error")
        }
        
    }

}

