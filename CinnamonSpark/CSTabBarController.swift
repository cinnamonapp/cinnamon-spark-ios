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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func setViewControllers(viewControllers: [AnyObject], animated: Bool) {
        super.setViewControllers(viewControllers, animated: animated)
        
        self.cameraButton = UIButton.buttonWithType(UIButtonType.Custom) as UIButton
        
        let height = self.tabBar.bounds.size.height + 10.0
        let x = CGRectGetMidX(self.tabBar.bounds) - (height / 2)
        let y = self.tabBar.frame.origin.y - 10.0
        
        self.cameraButton.frame = CGRectMake(x, y, height, height)
        
        self.cameraButton.setImage(UIImage(named: "CameraButton"), forState: UIControlState.Normal)
        
        self.cameraButton.addTarget(self, action: "cameraButtonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.view.addSubview(self.cameraButton)
    }
    
    func cameraButtonAction(sender: AnyObject){
        var vc = self.viewControllers?[2] as UINavigationController
        var vc2 = vc.viewControllers?[0] as CSUserPhotoFeedViewController
        
        vc2.openCamera()
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
