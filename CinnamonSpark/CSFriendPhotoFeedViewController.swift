//
//  CSPhotoBrowserViewController.swift
//  CinnamonSpark
//
//  Created by Alessio Santo on 20/03/15.
//  Copyright (c) 2015 Cinnamon. All rights reserved.
//

import Foundation

class CSFriendPhotoFeedViewController: CSSocialPhotoFeedViewController {
    
    // Optional: if it's there the query will be executed for one user only
    var mealRecordsForUser : CSUser!
    
    convenience init(user: CSUser){
        self.init()
        
        self.mealRecordsForUser = user
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let user = self.mealRecordsForUser{
            self.setQuirkyMessage("\(user.username)'s meals,\n what a great example!")
        }
    }
    
    override func loadPhotos() {
        if(self.mealRecordsForUser == nil){
            super.loadPhotos()
        }else{
            let user = self.mealRecordsForUser
            APIRequest.getUserMealRecords(user.id!, success: self.handleRequestSuccessResponse, failure: self.handleRequestFailureResponse)
        }
    }
    
    override func loadPhotosWithPage(page: Int) {
        if(self.mealRecordsForUser == nil){
            super.loadPhotosWithPage(page)
        }else{
            let user = self.mealRecordsForUser
            
            APIRequest.getUserMealRecords(user.id!, page: page, success: self.handleRequestSuccessResponsePaginated, failure: self.handleRequestFailureResponse)
        }
    }
    
}

