//
//  RootViewController.swift
//  Cinnamon
//
//  Created by Alessio Santo on 11/05/15.
//  Copyright (c) 2015 Cinnamon. All rights reserved.
//

import UIKit

class RootViewController: UIViewController, UIPageViewControllerDelegate, CSCameraDelegate, CSAPIRequestDelegate {

    // The building block here
    var pageViewController: UIPageViewController?
    
    var cameraViewController : CSCameraViewController!
    var cameraButton : UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        // Check in current user
        CSAPIRequest().checkCurrentUserInUsingDeviceUUID { (request: AFHTTPRequestOperation!, responseObject: AnyObject!) -> Void in
            
            let userDictionary = responseObject as NSDictionary
            
            if let dishCount = userDictionary["meal_records_count"] as? Int{
                // Set the global variable
                userDishCount = dishCount
            }
            
            self.setDishCount(userDishCount.description)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    
    func setupView(){
        
        self.view.backgroundColor = viewsBackgroundColor
        
        // Setup pageViewController
        self.pageViewController = UIPageViewController(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
        self.pageViewController?.delegate = self
        self.pageViewController?.dataSource = self.pageStack
        
        // Setup userPhotoFeedNavigationController
        var initialViewController = self.pageStack.viewControllerAtIndex(0)!
        
        
        self.pageViewController?.setViewControllers([initialViewController], direction: .Forward, animated: false, completion: { (b: Bool) -> Void in })
        
        self.addChildViewController(self.pageViewController!)
        self.view.addSubview(self.pageViewController!.view)
        
        
        
        var pageViewRect = self.view.bounds
        
        self.initiateCameraButton()
        self.displayCameraButton()
        
        // Leave some space for the camera button on bottom
        // pageViewRect.size.height -= self.cameraButton.bounds.size.height
        
        self.pageViewController!.view.frame = pageViewRect
        
        self.pageViewController!.didMoveToParentViewController(self)
        
        // Add the page view controller's gesture recognizers to the book view controller's view so that the gestures are started more easily.
        self.view.gestureRecognizers = self.pageViewController!.gestureRecognizers
        
    }
    
    var pageStack: PageStackController {
        // Return the model controller object, creating it if necessary.
        // In more complex implementations, the model controller may be passed to the view controller.
        if _pageStack == nil {
            _pageStack = PageStackController()
        }
        return _pageStack!
    }
    
    var _pageStack: PageStackController? = nil

    
    
    func pageViewController(pageViewController: UIPageViewController, spineLocationForInterfaceOrientation orientation: UIInterfaceOrientation) -> UIPageViewControllerSpineLocation {
        // Set the spine position to "min" and the page view controller's view controllers array to contain just one view controller. Setting the spine position to 'UIPageViewControllerSpineLocationMid' in landscape orientation sets the doubleSided property to true, so set it to false here.
        let currentViewController = self.pageViewController!.viewControllers[0] as UIViewController
        let viewControllers = [currentViewController]
        self.pageViewController!.setViewControllers(viewControllers, direction: .Forward, animated: true, completion: {done in })
        
        self.pageViewController!.doubleSided = false
        return .Min
    }

    
    
    
    // Camera stuff
    
    func initiateCameraButton(){
        let bounds = view.bounds
        
        self.cameraButton = UIButton(frame: CGRectMake(0, bounds.size.height - 60, bounds.size.width, 60))
        self.cameraButton.titleLabel?.textAlignment = NSTextAlignment.Center
        self.cameraButton.backgroundColor = UIColorFromHex(0x000000, alpha: 0.4)
        
        var buttonBounds = self.cameraButton.bounds
        buttonBounds.origin = CGPointMake(0, 0)
        
        let cameraIcon = UIImageView(image: UIImage(named: "CameraButton"))
        cameraIcon.frame = CGRectMake(0, 0, 30, 22)
        
        cameraIcon.frame.origin.x = CGRectGetMidX(buttonBounds) - cameraIcon.frame.width / 2
        cameraIcon.frame.origin.y = CGRectGetMidY(buttonBounds) - cameraIcon.frame.height / 2
        
        self.cameraButton.addTarget(self, action: "cameraButtonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        self.cameraButton.addSubview(cameraIcon)
    }
    
    func displayCameraButton(){
        self.view.addSubview(self.cameraButton)
    }

    
    func didTakePicture(image: UIImage, withSelectionValue selectedValue: AnyObject) {
        // Save image to photo album
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        
        userDishCount += 1
        
        // Show the alert for the first 5 times
        // and every 50th dish uploaded
        if (userDishCount <= 5 || userDishCount % 50 == 0){
            
            var s = (userDishCount > 1) ? "s" : ""
            
            var alertview = JSSAlertView().show(self.cameraViewController, title: "Awesome", text: "You are awesome my friend, \(userDishCount) meal\(s) already and going straight! Now hold on, we know you can't wait to see your carb result.\nWe will notify you.", buttonText: "Whoa", color: mainActionColor, iconImage: UIImage(named: "MonsterCircle"))
            
            alertview.setTextTheme(.Light)
            alertview.addAction { () -> Void in
                self.cameraViewController.closeViewController()
            }
            
        }else{
            self.cameraViewController.closeViewController()
        }
        
        
    }
    
    
    func didSuccessfullyCreateMealRecord(response: NSDictionary) {
        pageStack.dashboardViewController.refreshDashboard()
    }
    
    func openCamera(){
        
        cameraViewController = CSCameraViewController()
        cameraViewController.delegate = self
        let navigationController = UINavigationController(rootViewController: self.cameraViewController)
        
        presentViewController(navigationController, animated: true, completion: nil)
    }
    

    
    func cameraButtonAction(sender: AnyObject){
        openCamera()
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


class PageStackController: NSObject, UIPageViewControllerDataSource{
    
    let dashboardViewController             : DashboardViewController!
    let userPhotoFeedNavigationController   : CSUserPhotoFeedNavigationController!
    
    override init(){
        super.init()
        
        // Init this
        let layout      = UICollectionViewFlowLayout()
        layout.itemSize = UIScreen.mainScreen().bounds.size
        dashboardViewController = DashboardViewController(collectionViewLayout: layout)
        
        // Init this
        userPhotoFeedNavigationController = CSUserPhotoFeedNavigationController()
    }
    
    func viewControllersCount() -> Int{
        return 2
    }
    
    func viewControllerAtIndex(index: Int) -> UIViewController? {
        // Return the data view controller for the given index.
        
        if(index==0){
            
            return dashboardViewController
        }

        if(index==1){
            return userPhotoFeedNavigationController
        }

        return nil
    }
    
    func indexOfViewController(viewController: UIViewController) -> Int {
        // Return the index of the given data view controller.
        
        if let vc = viewController as? DashboardViewController{
            return 0
        }
        
        if let vc = viewController as? CSUserPhotoFeedNavigationController{
            return 1
        }
        
        
        return NSNotFound
    }
    

    
    
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        var index = self.indexOfViewController(viewController)
        
        index--
        
        if(index <= 0){
            return nil
        }
    
        return self.viewControllerAtIndex(index)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        var index = self.indexOfViewController(viewController)
        
        index++
        
        if(index >= self.viewControllersCount()){
            return nil
        }
        
        return self.viewControllerAtIndex(index)
    }


}