//
//  CSPhotoBrowserViewController.swift
//  CinnamonSpark
//
//  Created by Alessio Santo on 20/03/15.
//  Copyright (c) 2015 Cinnamon. All rights reserved.
//

import Foundation

enum CSPhotoFeedQueryTypes{
    case CurrentUser
    case All
}

class CSPhotoFeedViewController: UIViewController, MWPhotoBrowserDelegate, CSCameraDelegate, CSAPIRequestDelegate {
    
    var photos : NSMutableArray = NSMutableArray()
    var browser : MWPhotoBrowser!
    var cameraViewController : CSCameraViewController!
    let mealSizesArray = ["small", "medium", "large"]
    let APIRequest = CSAPIRequest()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.autoresizingMask = .FlexibleBottomMargin | .FlexibleHeight | .FlexibleTopMargin
        
        self.resetPhotoBrowser()

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewWillAppear(animated)
        println("hello")
        self.resetPhotoBrowser()
    }
    
    /**
        Query the database for meal records.
    
        :param: queryType Specifies if it should request All meal records or just the ones from the currentUser
    */
    func getMealRecords(queryType: CSPhotoFeedQueryTypes){
        switch queryType{
        case .All:
            APIRequest.getOthersMealRecords(self.handleRequestSuccessResponse, failure: self.handleRequestFailureResponse)
        break
        case .CurrentUser:
            APIRequest.getUserMealRecords(self.handleRequestSuccessResponse, failure: self.handleRequestFailureResponse)
        break
        default:
            self.getMealRecords(.CurrentUser)
        }
    }
    
    /**
        The handler function for success meal records responses.
        Override to set custom behaviour for this action.
    */
    func handleRequestSuccessResponse(operation: AFHTTPRequestOperation!, responseObject: AnyObject!){
        var mealRecords = responseObject as [NSDictionary]
        
        for (mealRecord) in mealRecords{
            
            let photo = MWPhoto(URL: NSURL(string: mealRecord["photo_original_url"] as String))
            let mealSize: Int = mealRecord["size"] as Int
            photo.caption = "Meal size: \(self.mealSizesArray[mealSize - 1])"
            
            self.photos.addObject(photo)
        }
        
        self.resetPhotoBrowser()
    }
    
    /**
        The handler function for failure meal records responses.
        Override to set custom behaviour for this action.
    */
    func handleRequestFailureResponse(operation: AFHTTPRequestOperation!, error: NSError!){
        
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
        self.browser.enableSwipeToDismiss = true
        self.browser.hidesBottomBarWhenPushed = false
        
        self.navigationController?.pushViewController(self.browser, animated: false)

        self.browser.navigationItem.hidesBackButton = true
        
        var buttonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Camera, target: self, action: "openCamera")

//        self.browser.navigationItem.rightBarButtonItem = buttonItem
    }
    
    func showGrid(){
        self.browser.showGridAnimated()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        println("Do something about memory warnings!")
    }
    
    func didTakePicture(image: UIImage, withSelectionValue selectedValue: AnyObject) {
        
        let photo = MWPhoto(image: image)
        let mealSize = selectedValue as Int
        photo.caption = "Meal size: \(self.mealSizesArray[mealSize - 1])"
        self.photos.addObject(photo)
        
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
    
    func photoBrowserDidHideGrid(photoBrowser: MWPhotoBrowser!) {
        let button = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self, action: "showGrid")
        self.browser.navigationItem.leftBarButtonItem = button
    }
    
    func photoBrowserDidShowGrid(photoBrowser: MWPhotoBrowser!) {
        self.browser.navigationItem.leftBarButtonItem = nil
    }
    
    func setTabBarVisible(visible:Bool, animated:Bool) {
        
        //* This cannot be called before viewDidLayoutSubviews(), because the frame is not set before this time
        
        // bail if the current state matches the desired state
        if (tabBarIsVisible() == visible) { return }
        
        // get a frame calculation ready
        let frame = self.tabBarController?.tabBar.frame
        let height = frame?.size.height
        let offsetY = (visible ? -height! : height)
        
        // zero duration means no animation
        let duration:NSTimeInterval = (animated ? 0.3 : 0.0)
        
        //  animate the tabBar
        if frame != nil {
            UIView.animateWithDuration(duration) {
                self.tabBarController?.tabBar.frame = CGRectOffset(frame!, 0, offsetY!)
                return
            }
        }
    }
    
    func tabBarIsVisible() ->Bool {
        return self.tabBarController?.tabBar.frame.origin.y < CGRectGetMaxY(self.view.frame)
    }

}

