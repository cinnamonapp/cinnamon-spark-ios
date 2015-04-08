//
//  CSPhotoBrowserViewController.swift
//  CinnamonSpark
//
//  Created by Alessio Santo on 20/03/15.
//  Copyright (c) 2015 Cinnamon. All rights reserved.
//

import Foundation

class CSSocialPhotoFeedViewController: CSPhotoBrowser {

    let APIRequest = CSAPIRequest()
    let mealSizesArray = ["small", "medium", "large"]
    
    private var refreshControl : UIRefreshControl?

    override init(){
        super.init()
        
        self.tabBarItem = UITabBarItem(title: "Community", image: UIImage(named: "Social"), tag: 1)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    override func viewDidLoad(){
        super.viewDidLoad()
    }
    
    override func loadPhotos() {
        self.getMealRecords(.All)
    }

    func userRequiredRefreshWithRefreshControl(refreshControl: UIRefreshControl) {
        self.refreshControl = refreshControl
        self.loadPhotos()
    }
    
    /**
    Query the database for meal records.
    
    :param: queryType Specifies if it should request All meal records or just the ones from the currentUser
    */
    private func getMealRecords(queryType: CSPhotoFeedQueryTypes){
        switch queryType{
        case .All:
            APIRequest.getOthersMealRecords(self.handleRequestSuccessResponse, failure: self.handleRequestFailureResponse)
            break
        case .CurrentUser:
            APIRequest.getUserMealRecords(self.handleRequestSuccessResponse, failure: self.handleRequestFailureResponse)
            break
        default:
            self.getMealRecords(.CurrentUser)
        }
    }

    
    /**
    The handler function for success meal records responses.
    Override to set custom behaviour for this action.
    */
    func handleRequestSuccessResponse(operation: AFHTTPRequestOperation!, responseObject: AnyObject!){
        var mealRecords = responseObject as [NSDictionary]
        
        self.photos = []
        
        for (mealRecord) in mealRecords{
            
            let csPhoto = CSPhoto(dictionary: mealRecord)
            
            self.photos.append(csPhoto)
        }
        
        self.collectionView?.reloadData()
        self.refreshControl?.endRefreshing()
    }
    
    /**
    The handler function for failure meal records responses.
    Override to set custom behaviour for this action.
    */
    func handleRequestFailureResponse(operation: AFHTTPRequestOperation!, error: NSError!){
        self.refreshControl?.endRefreshing()
    }

    
    
    // MARK: - CSPhotoBrowserDelegate methods
    override func photoBrowser(photoBrowser: CSPhotoBrowser, customizablePhotoBrowserCell cell: CSPhotoBrowserCell, atIndexPath indexPath: NSIndexPath, withPhoto photo: CSPhoto) -> CSPhotoBrowserCell {
        
        cell.setImageWithURL(photo.URL)
        
        // Set profile pic and username label
        let profilePictureView = UIImageView(frame: CGRectMake(5, 5, 20, 20))
        profilePictureView.sd_setImageWithURL(photo.profilePictureURL)
        
        let usernameLabel : UILabel = UILabel(frame: CGRectMake(30, 5, 200, 20))
        usernameLabel.text = photo.username
        usernameLabel.font = usernameLabel.font.fontWithSize(10.0)
        
        let timeAgo = UILabel(frame: CGRectMake(0, 5, cell.frame.width - 5, 20))
        timeAgo.text = photo.createdAtDate.timeAgoSinceNow()
        timeAgo.textAlignment = NSTextAlignment.Right
        timeAgo.font = timeAgo.font.fontWithSize(10.0)
        timeAgo.textColor = UIColor.lightGrayColor()
        
        
        cell.addSubviewToCaptionView(profilePictureView)
        cell.addSubviewToCaptionView(usernameLabel)
        cell.addSubviewToCaptionView(timeAgo)
        
        return cell
    }
}

