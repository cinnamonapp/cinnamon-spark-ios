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

    override init(){
        super.init()
    }
    
    convenience init(user: CSUser){
        self.init()
        
        self.mealRecordsForUser = user
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
            if let user = self.mealRecordsForUser{
                APIRequest.getUserMealRecords(user.id, success: self.handleRequestSuccessResponse, failure: self.handleRequestFailureResponse)
            }else{
                APIRequest.getUserMealRecords(self.handleRequestSuccessResponse, failure: self.handleRequestFailureResponse)
            }
        }
    }
        
//    func photoBrowser(photoBrowser: CSPhotoBrowser, customizableTopViewInterface cell: CSPhotoBrowserCell) -> CSPhotoBrowserCell {
//        
//        if let user = self.mealRecordsForUser{
//            
//            // Profile pic
//            let width  : CGFloat = 100
//            let height : CGFloat = width
//            let userImageView = UIImageView(frame: CGRectMake(10, 10, width, height))
//
//            userImageView.sd_setImageWithURL(user.profilePictureURL)
//            cell.addSubview(userImageView)
//            
//            // Username
//            let labelWidth : CGFloat = 200
//            let labelX : CGFloat = userImageView.frame.width + userImageView.frame.origin.x + 10
//            let usernameLabel = UILabel(frame: CGRectMake(labelX, 10, labelWidth, userImageView.frame.height))
//            
//            usernameLabel.text = user.username
//            
//            cell.addSubview(usernameLabel)
//
//        }
//        
//        return cell
//    }
//    
//    func sizeForCustomizableTopViewInterface(photoBrowser: CSPhotoBrowser, itemSize: CGSize) -> CGSize{
//        var size = itemSize
//        size.height = 120
//        
//        return size
//    }
    
}

