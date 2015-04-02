//
//  CSPhotoBrowserViewController.swift
//  CinnamonSpark
//
//  Created by Alessio Santo on 20/03/15.
//  Copyright (c) 2015 Cinnamon. All rights reserved.
//

import Foundation

class CSUserPhotoFeedViewController: CSPhotoFeedViewController {
    
    override init(){
        super.init()
        
        self.tabBarItem = UITabBarItem(title: "You", image: UIImage(named: "Meals"), tag: 1)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        self.getMealRecords(.CurrentUser)
    }
}

