//
//  CSSocialFeedNavigationController.swift
//  CinnamonSpark
//
//  Created by Alessio Santo on 10/04/15.
//  Copyright (c) 2015 Cinnamon. All rights reserved.
//

import UIKit

class CSSocialFeedNavigationController: UINavigationController {
    
    // The social feed
    var socialPhotoFeedViewController : CSSocialPhotoFeedViewController!
    
    // The friend feed
    var friendPhotoFeedViewController : CSFriendPhotoFeedViewController!
    

    override init() {
        super.init()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        self.tabBarItem = UITabBarItem(title: "Community", image: UIImage(named: "Social"), tag: 1)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.socialPhotoFeedViewController = CSSocialPhotoFeedViewController()
        self.setViewControllers([self.socialPhotoFeedViewController], animated: false)
        
        self.appendMisterCinnamon()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func openUserProfile(sender: AnyObject){
        let gesture = sender as UITapGestureRecognizer
        let photo = gesture.passedValue as CSPhoto

        self.friendPhotoFeedViewController = CSFriendPhotoFeedViewController(user: photo.user)
        self.pushViewController(self.friendPhotoFeedViewController, animated: true)
    }
    
    func openMealDetailViewControllerWithPhotoInGestureRecognizer(gesture: UITapGestureRecognizer){
        let photo = gesture.passedValue as CSPhoto
        
        let detailView = CSMealRecordDetailView(photo: photo)
        self.pushViewController(detailView, animated: true)
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
