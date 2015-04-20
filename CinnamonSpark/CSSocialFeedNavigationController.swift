//
//  CSSocialFeedNavigationController.swift
//  CinnamonSpark
//
//  Created by Alessio Santo on 10/04/15.
//  Copyright (c) 2015 Cinnamon. All rights reserved.
//

import UIKit

class CSSocialFeedNavigationController: UINavigationController {
    
    var socialFeedViewController : CSSocialPhotoFeedViewController!
    var userFeedViewController : CSFriendPhotoFeedViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.socialFeedViewController = CSSocialPhotoFeedViewController()
//        self.setViewControllers([socialFeedViewController], animated: false)
        
        
        let detailView = CSMealRecordDetailView()
        self.setViewControllers([detailView], animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func openUserProfile(sender: AnyObject){
        let button = sender as UIButton
        let photo = button.passedValue as CSPhoto

        self.userFeedViewController = CSFriendPhotoFeedViewController()
        self.userFeedViewController.mealRecordsForUser = photo.user
        self.pushViewController(userFeedViewController, animated: true)
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
