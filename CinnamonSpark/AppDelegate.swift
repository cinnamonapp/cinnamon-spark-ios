//
//  AppDelegate.swift
//  CinnamonSpark
//
//  Created by Alessio Santo on 20/03/15.
//  Copyright (c) 2015 Cinnamon. All rights reserved.
//

import UIKit
import CoreData
import Fabric
import Crashlytics

var userDishCount = 0

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate/*, UITabBarControllerDelegate*/ {

    var window: UIWindow?
    
//    var tabBarViewController: CSTabBarController!

    var rootViewController: RootViewController!

    let userHasOnboardedKey = "final_user_has_onboarded"
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window?.backgroundColor = viewsBackgroundColor
        
        // Override point for customization after application launch.
        
        // Fabric with crashalitics
        Fabric.with([Crashlytics()])
        
        // Onboarding or rootViewController
        var userHasOnboardedAlready = NSUserDefaults.standardUserDefaults().boolForKey(userHasOnboardedKey)
        
        if userHasOnboardedAlready {
            self.setupNormalRootVC(false)
        }else{
            self.window!.rootViewController = self.generateOnboardingViewController()
        }
        
        // Register for remote notifications
        application.registerForRemoteNotificationsAllAtOnce()
        
        // Handle notifications
        if let options = launchOptions{
            if let userInfo = options[UIApplicationLaunchOptionsRemoteNotificationKey] as? [NSObject : AnyObject]{
                self.processRemoteNotificationForApplication(application, withNotification: userInfo)
            }
        }
        
        // Make window visible
        self.window?.makeKeyAndVisible()
        
        return true
    }
    
    private func generateOnboardingViewController() -> OnboardingViewController {
        
        let screenBounds = UIScreen.mainScreen().bounds
        
        // The original image is 960 * 1684
        let estimatedImageHeight = 1684 * screenBounds.width / 960
        let estimatedTopPadding = estimatedImageHeight * 0.584
        
        
        // Create the onboarding controller with the pages and return it.
        let onboardingVC: OnboardingViewController = OnboardingViewController(backgroundImage: UIImage(named: "OnboardingBackground"), contents: [])
        
        
        // Generate the first page...
        let firstPage: OnboardingContentViewController = OnboardingContentViewController(title: nil, body: "Hi I am Mr. Cinnamon and I want\nto make a deal with you about\nyour health. ", image: UIImage(named:
            "blue"), buttonText: "Yeah") {
                onboardingVC.moveNextPage()
        }
        
        // Generate the second page...
        let secondPage: OnboardingContentViewController = OnboardingContentViewController(title: nil, body: "You take a picture of your\nfood & drinks, I tell you about\nyour carbs.", image: nil, buttonText: "Ok, but why carbs? ") {
            onboardingVC.moveNextPage()
        }
        
        // Generate the third page...
        let thirdPage: OnboardingContentViewController = OnboardingContentViewController(title: nil, body: "Carbs = Sugar\nMuch sugar = Not good for you\n\nIt’s more complicated than that,\nbut let’s keep it simple for now. ", image: nil, buttonText: "Alright, and how?") {
            onboardingVC.moveNextPage()
        }
        
        // Generate the fourth page
        let fourthPage: OnboardingContentViewController = OnboardingContentViewController(title: nil, body: "For each dish I give you a carb level:", image: UIImage(named: "Balls"), buttonText: "Fine") {
            onboardingVC.moveNextPage()
        }
        
        let fifthPage: OnboardingContentViewController = OnboardingContentViewController(title: nil, body: "And for each meal a range indicator:", image: UIImage(named: "Rects"), buttonText: "Ok") {
            onboardingVC.moveNextPage()
        }
        
        
        let sixthPage: OnboardingContentViewController = OnboardingContentViewController(title: nil, body: "Let’s try to keep our carbs low, together.\n30-50g per meal would be awesome!", image: nil, buttonText: "Sure, but what’s in for me?") {
            onboardingVC.moveNextPage()
        }
        
        let seventhPage: OnboardingContentViewController = OnboardingContentViewController(title: nil, body: "You learn about your food.\nYou become aware of your habits.\nAnd I will inspire you to eat healthier.", image: nil, buttonText: "Count. Me. In.") {
            onboardingVC.moveNextPage()
        }
        
        let eightPage: OnboardingContentViewController = OnboardingContentViewController(title: nil, body: "There is one more thing:\nYour friends are also here!", image: nil, buttonText: "You had me at 'friends'") {
            self.handleOnboardingCompletion()
        }
        
        onboardingVC.viewControllers = [firstPage, secondPage, thirdPage, fourthPage, fifthPage, sixthPage, seventhPage, eightPage]
        
        
        onboardingVC.topPadding = 250
        onboardingVC.underBodyPadding = 5
        onboardingVC.iconHeight = 60
        onboardingVC.iconWidth = 150
        
        onboardingVC.bodyFontSize = 15
        onboardingVC.titleTextColor = UIColor.blackColor()
        onboardingVC.bodyTextColor = UIColor.blackColor()
        onboardingVC.buttonTextColor = UIColor.blackColor()
        onboardingVC.swipingEnabled = false
        onboardingVC.shouldMaskBackground = false
        onboardingVC.shouldBlurBackground = false
        onboardingVC.hidePageControl = true
        
        onboardingVC.underTitlePadding = 0
        
        let hardware = UIDeviceHardware().platform()
        
        // The iPhone 4
        if(startsWith(hardware, "iPhone4")){
            onboardingVC.topPadding = estimatedTopPadding - 50
            onboardingVC.bottomPadding = 0
            // The iphone 5c/s
        }else if(startsWith(hardware, "iPhone5") || startsWith(hardware, "iPhone6")){
            onboardingVC.topPadding = estimatedTopPadding
            onboardingVC.bottomPadding = 45
            // The iPhone 6 and the other stuff
        }else{
            onboardingVC.topPadding = estimatedTopPadding
            onboardingVC.bottomPadding = 55
        }
        
        thirdPage.topPadding = thirdPage.topPadding - 10
        fourthPage.topPadding = fourthPage.topPadding - 10
        
        sixthPage.topPadding = sixthPage.topPadding + 10
        eightPage.topPadding = eightPage.topPadding + 10
        
        return onboardingVC
    }

    func handleOnboardingCompletion() {
        // Now that we are done onboarding, we can set in our NSUserDefaults that we've onboarded now, so in the
        // future when we launch the application we won't see the onboarding again.
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: userHasOnboardedKey)
        
        // Setup the normal root view controller of the application, and set that we want to do it animated so that
        // the transition looks nice from onboarding to normal app.
        setupNormalRootVC(true)
    }

    func setupNormalRootVC(animated : Bool) {
        // Here I'm just creating a generic view controller to represent the root of my application.
//        self.prepareSocialFeedNavigationControllerForReuse()
//        self.prepareUserPhotoFeedNavigationControllerForReuse()
        self.prepareRootViewControllerForReuse()
        
        
        // If we want to animate it, animate the transition - in this case we're fading, but you can do it
        // however you want.
        if animated {
            UIView.transitionWithView(self.window!, duration: 0.5, options:.TransitionCrossDissolve, animations: { () -> Void in
                // Set the tabBarViewController as root view controller
                self.window!.rootViewController = self.rootViewController
                }, completion:nil)
        }
            
        // Otherwise we just want to set the root view controller normally.
        else {
            self.window?.rootViewController = self.rootViewController
        }
    }

    // Setup the tabBarViewController
//    private func prepareTabBarViewControllerForReuse(){
//        self.tabBarViewController = CSTabBarController(delegate: self)
//    }
    
    // Setup the rootViewController
    private func prepareRootViewControllerForReuse(){
        self.rootViewController = RootViewController()
    }
    
    // MARK: - UITabBarController delegate methods
    
//    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
//        if (viewController.title != "."){
//            return true
//        }else{
//            return false
//        }
//    }
//    
//    func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {
//        // Call this method
//        viewController.willAppearAfterTabBarViewControllerSelection()
//    }
    
    
    
    
    // MARK: - Push notifications
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        
        self.processRemoteNotificationForApplication(application, withNotification: userInfo)

    }
    
    func processRemoteNotificationForApplication(application: UIApplication,  withNotification userInfo: [NSObject : AnyObject]){
        let aps = userInfo["aps"] as NSDictionary
        
        if let photoId = userInfo["meal_record_id"] as? Int{
//            self.tabBarViewController.selectedViewController = self.tabBarViewController.userPhotoFeedNavigationController
//            self.tabBarViewController.userPhotoFeedNavigationController.openMealDetailViewControllerWithPhotoId(photoId.description, animated: false)
            
            self.rootViewController.pageStack.dashboardViewController.refreshDashboard()
        }
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        CSAPIRequest().updateCurrentUserNotificationToken(deviceToken)
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        println(error)
    }
    
    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
        application.registerForRemoteNotifications()
    }
    
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.cinnamon-app.CinnamonSpark" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1] as NSURL
    }()

    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("CinnamonSpark", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("CinnamonSpark.sqlite")
        var error: NSError? = nil
        var failureReason = "There was an error creating or loading the application's saved data."
        if coordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil, error: &error) == nil {
            coordinator = nil
            // Report any error we got.
            let dict = NSMutableDictionary()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            dict[NSUnderlyingErrorKey] = error
            error = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(error), \(error!.userInfo)")
            abort()
        }
        
        return coordinator
    }()

    lazy var managedObjectContext: NSManagedObjectContext? = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        if coordinator == nil {
            return nil
        }
        var managedObjectContext = NSManagedObjectContext()
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        if let moc = self.managedObjectContext {
            var error: NSError? = nil
            if moc.hasChanges && !moc.save(&error) {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                NSLog("Unresolved error \(error), \(error!.userInfo)")
                abort()
            }
        }
    }

}


extension UIViewController{
    func willAppearAfterTabBarViewControllerSelection(){
        
    }
}

extension UIApplication{
    func registerForRemoteNotificationsAllAtOnce(){
        let application = UIApplication.sharedApplication()
        if (application.respondsToSelector("registerUserNotificationSettings:")) {
            // use registerUserNotificationSettings
            application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: .Alert | .Sound | .Badge, categories: nil))
        } else {
            application.registerForRemoteNotificationTypes(.Alert | .Sound | .Badge)
        }
    }
}

