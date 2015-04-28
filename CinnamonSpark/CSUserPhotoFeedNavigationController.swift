//
//  CSSocialFeedNavigationController.swift
//  CinnamonSpark
//
//  Created by Alessio Santo on 10/04/15.
//  Copyright (c) 2015 Cinnamon. All rights reserved.
//

import UIKit

class CSUserPhotoFeedNavigationController: UINavigationController {
    
    // The week view
    var userWeekPhotoFeedViewController : CSUserWeekPhotoFeedViewController!
    
    // The meal view
    var userPhotoFeedViewController     : CSUserPhotoFeedViewController!
    
    // The dish detail
    var mealRecordDetailViewController  : CSMealRecordDetailView!
    
    
    override init(){
        super.init()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        self.tabBarItem = UITabBarItem(title: "You", image: UIImage(named: "Meals"), tag: 1)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.userPhotoFeedViewController = CSUserPhotoFeedViewController()
        self.userWeekPhotoFeedViewController = CSUserWeekPhotoFeedViewController()
        
        self.viewControllers = [self.userWeekPhotoFeedViewController, self.userPhotoFeedViewController]
        
        self.appendMisterCinnamon()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func openUserPhotoFeedViewControllerAnimated(animated: Bool){
        if(self.viewControllers.count == 1){
            self.pushViewController(self.userPhotoFeedViewController, animated: animated)
        }
    }
    
    func openMealDetailViewControllerWithPhotoId(photoId: String, animated: Bool){
        let detailView = CSMealRecordDetailView(photoId: photoId)

        self.openUserPhotoFeedViewControllerAnimated(animated)
        self.pushViewController(detailView, animated: animated)
    }
    
    func openCameraViewController(animated: Bool){
        self.openUserPhotoFeedViewControllerAnimated(animated)
        // TODO: - Move thid into this navigation controller?
        self.userPhotoFeedViewController.openCamera()
    }
    
    
    // MARK: - Custom behaviour for UINavigationController
    override func popToRootViewControllerAnimated(animated: Bool) -> [AnyObject]? {
        var array : [AnyObject]? = []
        
        if(self.viewControllers.count == 1){
            self.openUserPhotoFeedViewControllerAnimated(animated)
        }else{
            array = super.popToViewController(self.userPhotoFeedViewController, animated: true)
        }

        return array
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
