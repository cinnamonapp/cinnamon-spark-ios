//
//  RootViewController.swift
//  Cinnamon
//
//  Created by Alessio Santo on 11/05/15.
//  Copyright (c) 2015 Cinnamon. All rights reserved.
//

import UIKit

class RootViewController: UIViewController, UIPageViewControllerDelegate {

    // The building block here
    var pageViewController: UIPageViewController?
    
    var cameraButton : UIButton!
    
    // Main controllers
    // they have specific actions to control their part of the app regardless of the active view controller
    var dashboardViewController : UIViewController!
    var userPhotoFeedNavigationController : CSUserPhotoFeedNavigationController!
    var socialFeedNavigationController : CSSocialFeedNavigationController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Setup pageViewController
        self.pageViewController = UIPageViewController(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
        self.pageViewController?.delegate = self
        self.pageViewController?.dataSource = self.pageStack
        
        // Setup userPhotoFeedNavigationController
        self.dashboardViewController = self.pageStack.viewControllerAtIndex(0)
        self.dashboardViewController.view.backgroundColor = UIColor.blackColor()
        
        println(pageStack.viewControllerAtIndex(0))
        
        self.pageViewController?.setViewControllers([self.dashboardViewController], direction: .Forward, animated: false, completion: {done in })

        self.addChildViewController(self.pageViewController!)
        self.view.addSubview(self.pageViewController!.view)

        
        
        var pageViewRect = self.view.bounds
        self.pageViewController!.view.frame = pageViewRect
        
        self.pageViewController!.didMoveToParentViewController(self)
        
        // Add the page view controller's gesture recognizers to the book view controller's view so that the gestures are started more easily.
        self.view.gestureRecognizers = self.pageViewController!.gestureRecognizers
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    var viewControllers : NSArray!
    var currentIndex : Int = 0
    
    override init(){
        super.init()
        
        var dashboardViewController = UIViewController()
        var userPhotoFeedNavigationController = CSUserPhotoFeedNavigationController()
        var socialFeedNavigationController = CSSocialFeedNavigationController()

        // Initialize controllers
        self.viewControllers = [
            socialFeedNavigationController,
            userPhotoFeedNavigationController
        ]
        
    }
    
    
    func viewControllerAtIndex(index: Int) -> UIViewController? {
        // Return the data view controller for the given index.
        return self.viewControllers[index] as? UIViewController
    }
    
    func indexOfViewController(viewController: UIViewController) -> Int {
        // Return the index of the given data view controller.
        return self.viewControllers.indexOfObject(viewController)
    }
    

    
    
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        self.currentIndex--
        
        if(self.currentIndex < 0){
            self.currentIndex = 0
            return nil
        }
    
        return UIViewController()
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
//        self.currentIndex++
//        
//        if(self.currentIndex > self.viewControllers.count - 1){
//            self.currentIndex = self.viewControllers.count - 1
//            return nil
//        }
//        
//        println("Index => \(self.currentIndex)")
//        println("Controller => \(self.viewControllerAtIndex(self.currentIndex))")
        
        return UIViewController()
    }


}