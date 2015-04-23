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

// APIEndpoints constant
let apiEndpoints : (local: String, development: String, staging: String, production: String) = (
    local:          "http://localhost:3000",
    development:    "http://192.168.1.12:3000",
    staging:        "http://cinnamon-staging.herokuapp.com",
    production:     "http://cinnamon-production.herokuapp.com"
)

// Change this constant to change the endpoint for entire app
let primaryAPIEndpoint = apiEndpoints.development


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UITabBarControllerDelegate {

    var window: UIWindow?
    
    var userFeedViewController : CSUserPhotoFeedViewController!
    var userWeeklyFeedViewController : CSUserWeekPhotoFeedViewController!
    var userFeedNavigationController : UINavigationController!
    var socialFeedNavigationController : CSSocialFeedNavigationController!
    var tabBarViewController: CSTabBarController!

    let userHasOnboardedKey = "user_has_onboarded"
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window?.backgroundColor = UIColor.blackColor()
        
        var userHasOnboardedAlready = NSUserDefaults.standardUserDefaults().boolForKey(userHasOnboardedKey)
        
        if userHasOnboardedAlready {
            self.setupNormalRootVC(false)
        }else{
            self.window!.rootViewController = self.generateOnboardingViewController()
        }
        
        self.window?.makeKeyAndVisible()
        
        Fabric.with([Crashlytics()])
        
        // Check in current user
        (CSAPIRequest()).checkCurrentUserInUsingDeviceUUID()

        application.registerForRemoteNotificationsAllAtOnce()
        
        
        if let options = launchOptions{
            if let userInfo = options[UIApplicationLaunchOptionsRemoteNotificationKey] as? [NSObject : AnyObject]{
                self.processRemoteNotificationForApplication(application, withNotification: userInfo)
            }
        }
        
        return true
    }
    
    private func generateOnboardingViewController() -> OnboardingViewController {
        // Generate the first page...
        let firstPage: OnboardingContentViewController = OnboardingContentViewController(title: "What A Beautiful Photo", body: "This city background image is so beautiful", image: UIImage(named:
            "blue"), buttonText: "Enable Location Services") {
                println("Do something here...");
        }
        
        // Generate the second page...
        let secondPage: OnboardingContentViewController = OnboardingContentViewController(title: "I'm So Sorry", body: "I can't get over the nice blurry background photo.", image: UIImage(named:
            "red"), buttonText: "Connect With Facebook") {
                println("Do something else here...");
        }
        
        // Generate the third page, and when the user hits the button we want to handle that the onboarding
        // process has been completed.
        let thirdPage: OnboardingContentViewController = OnboardingContentViewController(title: "Seriously Though", body: "Kudos to the photographer.", image: UIImage(named:
            "yellow"), buttonText: "Let's Get Started") {
                self.handleOnboardingCompletion()
        }
        
        // Create the onboarding controller with the pages and return it.
        let onboardingVC: OnboardingViewController = OnboardingViewController(backgroundImage: UIImage(named: "street"), contents: [firstPage, secondPage, thirdPage])
        
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
        self.prepareSocialFeedNavigationControllerForReuse()
        self.prepareUserFeedNavigationControllerForReuse()
        self.prepareTabBarViewControllerForReuse()
        
        
        // If we want to animate it, animate the transition - in this case we're fading, but you can do it
        // however you want.
        if animated {
            UIView.transitionWithView(self.window!, duration: 0.5, options:.TransitionCrossDissolve, animations: { () -> Void in
                // Set the tabBarViewController as root view controller
                self.window!.rootViewController = self.tabBarViewController
                }, completion:nil)
        }
            
        // Otherwise we just want to set the root view controller normally.
        else {
            self.window?.rootViewController = self.tabBarViewController
        }
    }

    
    private func prepareTabBarViewControllerForReuse(){
        self.tabBarViewController = CSTabBarController()
        self.tabBarViewController.delegate = self
        
        let emptyVC = UIViewController()
        emptyVC.title = "."
        
        self.tabBarViewController.setViewControllers([self.socialFeedNavigationController, emptyVC, userFeedNavigationController], animated: false)
    }
    
    private func prepareSocialFeedNavigationControllerForReuse(){
        //#warning Change view controller here before deploying
        self.socialFeedNavigationController = CSSocialFeedNavigationController()
    }
    
    private func prepareUserFeedNavigationControllerForReuse(){
        self.userFeedViewController = CSUserPhotoFeedViewController()
        self.userFeedViewController.title = "You"
        
        self.userWeeklyFeedViewController = CSUserWeekPhotoFeedViewController()
        self.userWeeklyFeedViewController.title = "You"
        
        self.userFeedNavigationController = UINavigationController(rootViewController: self.userWeeklyFeedViewController)
        
        self.userFeedNavigationController.pushViewController(userFeedViewController, animated: false)
    }
    
    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
        if (viewController.title != "."){
            return true
        }else{
            return false
        }
    }
    
    func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {
        // Call this method
        viewController.willAppearAfterTabBarViewControllerSelection()
    }
    
    // MARK: - Push notifications
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        
        self.processRemoteNotificationForApplication(application, withNotification: userInfo)

    }
    
    func processRemoteNotificationForApplication(application: UIApplication,  withNotification userInfo: [NSObject : AnyObject]){
        let aps = userInfo["aps"] as NSDictionary
        
        if let photoId = userInfo["meal_record_id"] as? Int{
            self.tabBarViewController.selectedIndex = 2
            self.userFeedViewController.openMealDetailViewControllerWithPhotoId(photoId.description)
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

