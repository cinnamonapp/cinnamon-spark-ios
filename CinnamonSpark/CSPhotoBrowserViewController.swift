//
//  CSPhotoBrowserViewController.swift
//  CinnamonSpark
//
//  Created by Alessio Santo on 20/03/15.
//  Copyright (c) 2015 Cinnamon. All rights reserved.
//

import Foundation

class CSPhotoBrowserViewController: UIViewController, MWPhotoBrowserDelegate, CSCameraDelegate, CSAPIRequestDelegate {
    
    var photos : NSMutableArray!
    var browser : MWPhotoBrowser!
    var cameraViewController : CSCameraViewController!
    let mealSizesArray = ["small", "medium", "large"]
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.photos = NSMutableArray()
        
        CSAPIRequest().getMealRecords({ (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) -> Void in
            var mealRecords = responseObject as [NSDictionary]
            
            for (mealRecord) in mealRecords{
                
                let photo = MWPhoto(URL: NSURL(string: mealRecord["photo_original_url"] as String))
                let mealSize: Int = mealRecord["size"] as Int
                photo.caption = "Meal size: \(self.mealSizesArray[mealSize - 1])"
                
                self.photos.addObject(photo)
            }
            
            self.resetPhotoBrowser()
        }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
            
        })
        
        self.resetPhotoBrowser()
        
        self.openCamera()
    }
    
    func resetPhotoBrowser(){
        self.browser = nil
        self.browser = MWPhotoBrowser(delegate: self)
        
        // Set options
        self.browser.displayActionButton = false // Show action button to allow sharing, copying, etc (defaults to YES)
        self.browser.displayNavArrows = false // Whether to display left and right nav arrows on toolbar (defaults to NO)
        self.browser.displaySelectionButtons = false // Whether selection buttons are shown on each image (defaults to NO)
        self.browser.zoomPhotosToFill = true // Images that almost fill the screen will be initially zoomed to fill (defaults to YES)
        self.browser.alwaysShowControls = false // Allows to control whether the bars and controls are always visible or whether they fade away to show the photo full (defaults to NO)
        self.browser.enableGrid = true // Whether to allow the viewing of all the photo thumbnails on a grid (defaults to YES)
        self.browser.startOnGrid = true // Whether to start on the grid of thumbnails instead of the first photo (defaults to NO)
        
        self.navigationController?.pushViewController(self.browser, animated: false)
        
        self.browser.navigationItem.hidesBackButton = true
        
        var buttonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Camera, target: self, action: "openCamera")
        
        self.browser.navigationItem.rightBarButtonItem = buttonItem
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func didTakePicture(image: UIImage, withSelectionValue selectedValue: AnyObject) {

        let photo = MWPhoto(image: image)
        let mealSize = selectedValue as Int
        photo.caption = "Meal size: \(self.mealSizesArray[mealSize - 1])"
        self.photos.addObject(photo)
        
//        println("Chosen value \(selectedValue)")
        
        self.resetPhotoBrowser()
    }
    
    func didSuccessfullyCreateMealRecord(response: NSDictionary) {
        let thumbUrl    = NSURL(string: response["photo_thumb_url"]     as String)
        let originalUrl = NSURL(string: response["photo_original_url"]  as String)
        let mealSize    = response["size"] as Int
        let mealSizeName = self.mealSizesArray[mealSize - 1]

        self.photos.removeLastObject()
        
        let photo = MWPhoto(URL: originalUrl)
        photo.caption = "Meal size: \(mealSizeName)"
        
        self.photos.addObject(photo)
        
        self.cameraViewController = nil
        
        self.browser.reloadData()
    }
    
    func openCamera(){

        cameraViewController = CSCameraViewController()
        cameraViewController.delegate = self
        let navigationController = UINavigationController(rootViewController: cameraViewController)
        
//        self.navigationController?.pushViewController(cameraViewController, animated: true)
        presentViewController(navigationController, animated: true, completion: nil)
    }
    
    // MARK: - MWPhotoBrowser delegate methods
    func numberOfPhotosInPhotoBrowser(photoBrowser: MWPhotoBrowser!) -> UInt {
        return UInt(photos.count)
    }
    
    // This is for the thumb
    func photoBrowser(photoBrowser: MWPhotoBrowser!, thumbPhotoAtIndex index: UInt) -> MWPhotoProtocol! {
        return photos[Int(index)] as MWPhotoProtocol
    }
    
    // This is for the big picture
    func photoBrowser(photoBrowser: MWPhotoBrowser!, photoAtIndex index: UInt) -> MWPhotoProtocol! {
        if (index < UInt(photos.count)){
            return photos[Int(index)] as MWPhotoProtocol
        }
        return nil
    }
}

