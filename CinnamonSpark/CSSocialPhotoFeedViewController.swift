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
    
    override init(){
        super.init()

        self.tabBarItem = UITabBarItem(title: "Community", image: UIImage(named: "Social"), tag: 1)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Temporary fix for custom navbar
        self.collectionView?.frame.origin.y += 30
        self.collectionView?.frame.size.height -= 30
        // End
        
        self.collectionView?.backgroundColor = viewsBackgroundColor
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setQuirkyMessage(SocialFeedQuirkyMessages.sample())
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // Check in current user
        CSAPIRequest().checkCurrentUserInUsingDeviceUUID { (request: AFHTTPRequestOperation!, responseObject: AnyObject!) -> Void in
            self.setDishCount(userDishCount.description)
        }
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadPhotos() {
        APIRequest.getOthersMealRecords(self.handleRequestSuccessResponse, failure: self.handleRequestFailureResponse)
    }

    func userRequiredRefreshWithRefreshControl(refreshControl: UIRefreshControl) {
        self.loadPhotos()
    }
    
    /**
    Query the database for meal records.
    
    :param: queryType Specifies if it should request All meal records or just the ones from the currentUser

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
    */
    
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
    override func photoBrowser(photoBrowser: CSPhotoBrowser, customizablePhotoBrowserCell cell: CSRepeatablePhotoBrowserCell, atIndexPath indexPath: NSIndexPath, withPhoto photo: CSPhoto) -> CSRepeatablePhotoBrowserCell {
        
        // TODO: - All this stuff must be translated into xib file for the cell
        
        cell.setPhotoWithThumbURL(photo.URL, originalURL: photo.URL)
        cell.photo.userInteractionEnabled = true
        
        cell.backgroundColor = viewsInsideBackgroundColor
        
        // Add tap gesture to photo by uncommenting these lines
//        let tapGesture = UITapGestureRecognizer(target: self.navigationController!, action: "openMealDetailViewControllerWithPhotoInGestureRecognizer:")
//        tapGesture.passedValue = photo
//        
//        cell.photo.addGestureRecognizer(tapGesture)
        
        // Set profile pic and username label
        if let pic = photo.user.microProfilePictureURL{
            cell.userProfilePicture.sd_setImageWithURL(pic)
        }
        
        cell.userProfileName.text = photo.user.username

        if let navController = self.navigationController as? CSSocialFeedNavigationController{
            cell.userProfileName.addTarget(navController, action: "openUserProfile:", forControlEvents: UIControlEvents.TouchUpInside, passedValue: photo)
        }
        
        if(photo.createdAtDate != nil){
            cell.timeAgoLabel.text = photo.createdAtDate.timeAgoSinceNow()
        }else{
            cell.timeAgoLabel.text = "Smart alert"
        }
        
        cell.titleAndHashtags.text = photo.title

        
        if let carbs = photo.carbsEstimate{
            cell.setCarbsEstimateToValue(carbs)
        }else{
            cell.hideCarbsEstimate()
        }
        
        return cell
    }
    
}

