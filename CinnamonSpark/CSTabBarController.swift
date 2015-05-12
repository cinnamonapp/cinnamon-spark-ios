//
//  CSTabBarController.swift
//  CinnamonSpark
//
//  Created by Alessio Santo on 31/03/15.
//  Copyright (c) 2015 Cinnamon. All rights reserved.
//

import UIKit

class CSTabBarController: UITabBarController {
        
    var cameraButton : UIButton!
    
    // Main controllers
    // they have specific actions to control their part of the app regardless of the active view controller
    var userPhotoFeedNavigationController : CSUserPhotoFeedNavigationController!
    var socialFeedNavigationController : CSSocialFeedNavigationController!

    // Initializers
    
    convenience init(delegate: UITabBarControllerDelegate){
        self.init()
        
        self.delegate = delegate
        
        let emptyVC = UIViewController()
        emptyVC.title = "."
        
        self.userPhotoFeedNavigationController  = CSUserPhotoFeedNavigationController()
        self.socialFeedNavigationController     = CSSocialFeedNavigationController()
        
        // Set these view controllers by default
        self.setViewControllers([self.socialFeedNavigationController, emptyVC, self.userPhotoFeedNavigationController], animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.customizeTabBar()
        self.view.backgroundColor = viewsBackgroundColor
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func customizeTabBar(){
        self.tabBar.translucent = false
        self.tabBar.barTintColor = viewsBackgroundColor
        self.tabBar.tintColor = UIColor(red: 51/255, green: 44/255, blue: 33/255, alpha: 1)
        
        let addHeight = CGFloat(5)
        
        self.tabBar.frame.size.height = self.tabBar.frame.size.height + addHeight
        self.tabBar.frame.origin.y = self.tabBar.frame.origin.y - addHeight
        
        self.tabBar.backgroundImage = UIImage()
        self.tabBar.shadowImage = UIImage()

    }
    
    override func setViewControllers(viewControllers: [AnyObject], animated: Bool) {
        super.setViewControllers(viewControllers, animated: animated)
        
        self.cameraButton = UIButton.buttonWithType(UIButtonType.Custom) as UIButton
        
        let height = self.tabBar.bounds.size.height + 15
        let x = CGRectGetMidX(self.tabBar.bounds) - (height / 2)
        let y = self.tabBar.frame.origin.y - 20.0
        
        self.cameraButton.frame = CGRectMake(x, y, height, height)
        
        self.cameraButton.setImage(UIImage(named: "CameraButton"), forState: UIControlState.Normal)
        
        self.cameraButton.addTarget(self, action: "cameraButtonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.view.addSubview(self.cameraButton)
    }
    
    func cameraButtonAction(sender: AnyObject){
        self.selectedViewController = self.userPhotoFeedNavigationController
        self.userPhotoFeedNavigationController.openCameraViewController(true)
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
