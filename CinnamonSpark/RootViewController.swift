//
//  RootViewController.swift
//  Cinnamon
//
//  Created by Alessio Santo on 11/05/15.
//  Copyright (c) 2015 Cinnamon. All rights reserved.
//

import UIKit

class RootViewController: UIViewController, UIPageViewControllerDelegate, CSCameraViewControllerDelegate, CSAPIRequestDelegate {

    // The building block here
    var pageViewController: UIPageViewController?
    
    var cameraViewController : CSCameraViewController!
    var cameraButton : UIButton!
    var cameraButtonHidden : Bool {
        get{
            return cameraButton.hidden
        }
        
        set{
            cameraButton.hidden = newValue
        }
    }
    
    var controlsHidden : Bool{
        get{
            return cameraButtonHidden && pageStack.pageControl.hidden
        }
        
        set{
            cameraButtonHidden = newValue
            pageStack.pageControl.hidden = newValue
        }
    }
    
    var swipeInteractionEnabled : Bool{
        get{
            return (pageViewController?.dataSource !== nil)
        }
        
        set{
            if(newValue){
                pageViewController?.dataSource = pageStack
            }else{
                pageViewController?.dataSource = nil
            }
        }
    }
    
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
        

        println(CSUser.currentUserMealRecordsCount)
        
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
        var initialViewController = self.pageStack.viewControllerAtIndex(2)!
        
        
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
        
        self.view.addSubview(self.pageStack.pageControl)
    }
    
    var pageStack: PageStackController {
        // Return the model controller object, creating it if necessary.
        // In more complex implementations, the model controller may be passed to the view controller.
        if _pageStack == nil {
            _pageStack = PageStackController()
            _pageStack?.rootViewController = self
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
        self.cameraButton.backgroundColor = UIColorFromHex(0x000000, alpha: 0.7)
        
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
    

    func cameraViewController(cameraViewController: CSCameraViewController, didConfirmPictureWithScaledImage scaledImage: UIImage, withSize size: CSFastCameraSize?, withServing serving: CSFastCameraServing?, andDescription description: String?) {
        
        //        let rotatedImage = scaledImage.imageRotatedByDegrees(90, flip: false)
        let image = scaledImage //cameraViewController.cameraView.takenPicture!
//        let rotatedImage = UIImage(CGImage: image.CGImage, scale: image.scale, orientation: image)
        
        let imageData = UIImageJPEGRepresentation(image, 0.7)
        
        // Save image to photo album
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        
        var title = description!
        if(title == "Tell me more... if you like"){
            title = ""
        }
        
        let params : NSDictionary = [
            "meal_record": [
                "title": title,
                "size": size!.id,
                "serving": serving!.id
            ]
        ]
        
        
        let mealRecord = CSPhoto(dictionary: params)
        
        println("Created meal record with date \(mealRecord.createdAtDate)")
        let str = "test"
        println("dictionary: \(mealRecord.toQueueableDictionaryForKey(str))")
        
        if let currentUser = CSUser.currentUser(){
            mealRecord.user = currentUser
        }
        
        mealRecord.image = image
        
        pageStack.dashboardViewController.dashboardObject?.backgroundImageURL = nil
        pageStack.dashboardViewController.refreshDataWithLastMealRecord(mealRecord)
        
//        cameraViewController.dismissViewControllerAnimated(true, completion: nil)
        
        showGreatJobNotification()
        
//        CSAPIRequest().createMealRecord(params, withImageData: imageData, success: handleCreateMealRecordRequestSuccess)
        
//        mealRecord.save(success: handleCreateMealRecordRequestSuccess, failure: handleCreateMealRecordRequestSuccess)
        
        mealRecord.queue(success: handleCreateMealRecordRequestSuccess, failure: handleCreateMealRecordRequestSuccess)
    }
    
    
    func showGreatJobNotification(){
        if let currentUser = CSUser.currentUser(){
            CSUser.currentUserMealRecordsCount += 1
            

            
            cameraViewController.dismissViewControllerAnimated(true, completion: { () -> Void in
                
                let userMealRecordsCount = CSUser.currentUserMealRecordsCount
                println(userMealRecordsCount)
                
                // For the first 5 mealRecords and every 50th
                if (userMealRecordsCount <= 5 || userMealRecordsCount % 10 == 0){
                    
                    var message = "and counting! You certainly know the way to a healthy eating app's heart. Give me a moment to analyze the carbs."
                    
                    if(userMealRecordsCount == 1){
                        message = "Got it! Now, give me some minutes to analyze those carbs."
                    }
                    
                    if(userMealRecordsCount <= 5){
                        message = "Looks delicious! Let me pull up those numbers for you! Just some minutes..."
                    }
                    
                    
                    
                    var alertView = JSSAlertView()
                    
                    alertView.show(
                        self,
                        title: "\(userMealRecordsCount)",
                        text: message,
                        buttonText: "OK",
                        color: UIColor.blackColor(),
                        iconImage: UIImage()
                    )
                    
                    alertView.setTextTheme(.Light)
                }
                
            })
            
            
        }
        
    }
    
    func handleCreateMealRecordRequestSuccess(request: AFHTTPRequestOperation!, response: AnyObject!){
        if let dashboard = pageStack.dashboardViewController.dashboardObject{
            let mealRecord = CSPhoto(dictionary: response as NSDictionary)
            
            dashboard.backgroundImageURL = mealRecord.photoURL(.BlurredBackground)
            dashboard.lastMealRecord = mealRecord
        }
        pageStack.dashboardViewController.setReloadCollectionView()
    }
    

    func openMealDetailViewControllerWithPhotoId(photoId: String, animated: Bool){
        
        let mealDetailViewController = CSMealRecordDetailView(photoId: photoId)
        //        let navController = UINavigationController(rootViewController: mealDetailViewController)
        
        self.presentViewController(mealDetailViewController, animated: animated, completion: nil)
    }
    
    func openMealDetailViewControllerWithMealRecord(mealRecord: CSPhoto, animated: Bool){
        
        let mealDetailViewController = CSMealRecordDetailView(photo: mealRecord)
        //        let navController = UINavigationController(rootViewController: mealDetailViewController)
        
        self.presentViewController(mealDetailViewController, animated: animated, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    func navigateToCommunityView(#completion: ((Bool) -> Void)!){
        
        if let currentController = pageViewController?.viewControllers.first as? CSSocialFeedNavigationController{
            completion(true)
        }else{
            self.pageViewController?.setViewControllers([pageStack.communityView], direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: completion)
        }
        
        
    }
    
    func navigateToDashboardView(#completion: ((Bool) -> Void)!){
        
        if let currentController = pageViewController?.viewControllers.first as? DashboardViewController{
            completion(true)
        }else{
            self.pageViewController?.setViewControllers([pageStack.dashboardViewController], direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: completion)
        }
        
    }
    
    func pageViewController(pageViewController: UIPageViewController, willTransitionToViewControllers pendingViewControllers: [AnyObject]) {
        if let nextViewController = pendingViewControllers.first as? UIViewController{
            let index = self.pageStack.indexOfViewController(nextViewController)
            println(index)
            
            self.pageStack.pageControl.currentPage = index
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.pageStack.pageControl.frame = CGRectMake(0, 20, view.frame.width, 20)
    }
}


class FakeViewController : UIViewController{
    
}

class SuperFakeViewController : UIViewController{
    
}

class PageStackController: NSObject, UIPageViewControllerDataSource{
    
    var pageControl : UIPageControl!
    
    let dashboardViewController             : DashboardViewController!
    let userPhotoFeedNavigationController   : CSUserPhotoFeedNavigationController!
    
    let userMonthView : UIViewController!
    let communityView : CSSocialFeedNavigationController!
    
    var rootViewController : RootViewController?{
        get{
            return dashboardViewController.cs_rootViewController
        }
        
        set{
            dashboardViewController.cs_rootViewController = newValue
            userPhotoFeedNavigationController.cs_rootViewController = newValue
            communityView.cs_rootViewController = newValue
        }
    }
    
    override init(){
        super.init()
        
        pageControl = UIPageControl()
        pageControl.numberOfPages = 4
        pageControl.currentPage = 2
        pageControl.userInteractionEnabled = false
        
        // Init this
        let layout      = UICollectionViewFlowLayout()
        layout.itemSize = UIScreen.mainScreen().bounds.size

        dashboardViewController = DashboardViewController(collectionViewLayout: layout)
        
        // Init this
        userPhotoFeedNavigationController = CSUserPhotoFeedNavigationController()
        let view = userPhotoFeedNavigationController.view
        let view2 = userPhotoFeedNavigationController.userPhotoFeedViewController.view
        
        userMonthView = FakeViewController()
        let fakeMonthImage = UIImageView(image: UIImage(named: "FakeMonthView"))
        fakeMonthImage.frame = userMonthView.view.bounds
        userMonthView.view.addSubview(fakeMonthImage)
        
        communityView = CSSocialFeedNavigationController()
        let view3 = communityView.view
        let view4 = communityView.socialPhotoFeedViewController.view
    }
    
    func viewControllersCount() -> Int{
        return 4
    }
    
    func viewControllerAtIndex(index: Int) -> UIViewController? {
        // Return the data view controller for the given index.
        
        if(index==3){
            
            return communityView
        }
        
        if(index==2){
            
            return dashboardViewController
        }
        
        if(index==1){
            
            return userPhotoFeedNavigationController
        }
        
        if(index==0){
            return userMonthView
        }

        return nil
    }
    
    func indexOfViewController(viewController: UIViewController) -> Int {
        // Return the index of the given data view controller.
        
        if let vc = viewController as? CSSocialFeedNavigationController{
            return 3
        }
        
        if let vc = viewController as? DashboardViewController{
            return 2
        }
        
        if let vc = viewController as? CSUserPhotoFeedNavigationController{
            return 1
        }
        
        if let vc = viewController as? FakeViewController{
            return 0
        }
        
        
        return NSNotFound
    }
    

//    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
//        return self.viewControllersCount()
//    }
//    
//    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
//        return 1
//    }
    
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        var index = self.indexOfViewController(viewController)
        
        
        
        println("Index => \(index)")
        
        if(index <= 0){
            return nil
        }
        
        index--
        
        
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




@objc
protocol Rootable{
    var cs_rootViewController : RootViewController? {get set}
}

private var cs_rootViewControllerKeyAssociation : UInt8 = 0
extension UIViewController : Rootable{
    var cs_rootViewController : RootViewController? {
        get{
            return objc_getAssociatedObject(self, &cs_rootViewControllerKeyAssociation) as RootViewController?
        }
        
        set{
            objc_setAssociatedObject(self, &cs_rootViewControllerKeyAssociation, newValue, objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN))
        }
    }
    
}

