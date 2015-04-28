//
//  CSPhotoBrowserViewController.swift
//  CinnamonSpark
//
//  Created by Alessio Santo on 20/03/15.
//  Copyright (c) 2015 Cinnamon. All rights reserved.
//

import Foundation

let smartAlertReuseIdentifier = "smartAlertPhotoBrowserCell"


class CSSocialPhotoFeedViewController: CSPhotoBrowser, UIScrollViewDelegate {

    let APIRequest = CSAPIRequest()
    let mealSizesArray = ["small", "medium", "large"]
    
    // Pagination stuff
    var isAlreadyRefreshing : Bool = true
    var queryPage = 1
    var continueLoadingPhotos = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Temporary fix for custom navbar
        self.collectionView?.frame.origin.y += 30
        self.collectionView?.frame.size.height -= 30
        // End
        
        self.collectionView?.backgroundColor = viewsBackgroundColor
        
        
        self.collectionView!.registerNib(UINib(nibName: "CSSmartAlertPhotoBrowserCell", bundle: nil), forCellWithReuseIdentifier: smartAlertReuseIdentifier)
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

    override func loadPhotos() {
        APIRequest.getOthersMealRecords(self.handleRequestSuccessResponse, failure: self.handleRequestFailureResponse)
    }
    
    func loadPhotosWithPage(page: Int){
        APIRequest.getOthersMealRecordsWithPage(page, success: self.handleRequestSuccessResponsePaginated, failure: self.handleRequestFailureResponse)
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
        
        queryPage = 1
        isAlreadyRefreshing = false
    }

    func handleRequestSuccessResponsePaginated(operation: AFHTTPRequestOperation!, responseObject: AnyObject!){
        var mealRecords = responseObject as [NSDictionary]
        
        for (mealRecord) in mealRecords{
            
            let csPhoto = CSPhoto(dictionary: mealRecord)
            
            self.photos.append(csPhoto)
        }
        
        self.collectionView?.reloadData()
        self.refreshControl?.endRefreshing()
        
        if(mealRecords.count == 0){
            continueLoadingPhotos = false
        }
        
        isAlreadyRefreshing = false
    }

    /**
    The handler function for failure meal records responses.
    Override to set custom behaviour for this action.
    */
    func handleRequestFailureResponse(operation: AFHTTPRequestOperation!, error: NSError!){
        self.refreshControl?.endRefreshing()
    }

    
    
    // MARK: - UIScrollViewDelegate methods
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        
        let collectionView = self.collectionView!
        
        let didScrollToBottom = (collectionView.contentOffset.y > (collectionView.contentSize.height - collectionView.bounds.size.height))
        
        if (didScrollToBottom && !isAlreadyRefreshing){
            
            if(continueLoadingPhotos){
                isAlreadyRefreshing = true
            
                self.queryPage++
                
                self.loadPhotosWithPage(self.queryPage)
            }
            
        }
        
    }
    
    
    // MARK: - CSPhotoBrowserDelegate methods
    override func photoBrowser(photoBrowser: CSPhotoBrowser, forCollectionView collectionView: UICollectionView, customizablePhotoBrowserCell cell: CSRepeatablePhotoBrowserCell, atIndexPath indexPath: NSIndexPath, withPhoto photo: CSPhoto) -> CSRepeatablePhotoBrowserCell {
        
        // Check for mister cinnamon
        var finalcell = cell
        
        // If the id is -1 it means that is a smart alert
        if (photo.id == "-1"){
            finalcell = collectionView.dequeueReusableCellWithReuseIdentifier(smartAlertReuseIdentifier, forIndexPath: indexPath) as CSSmartAlertPhotoBrowserCell
        }
        
        finalcell.backgroundColor = viewsInsideBackgroundColor
        
        // Set the photo
        finalcell.setPhotoWithThumbURL(photo.URL, originalURL: photo.URL)
        
        // Add tap gesture to photo by uncommenting these lines
//        finalcell.photo.userInteractionEnabled = true
//        let tapGesture = UITapGestureRecognizer(target: self.navigationController!, action: "openMealDetailViewControllerWithPhotoInGestureRecognizer:")
//        tapGesture.passedValue = photo
//        
//        cell.photo.addGestureRecognizer(tapGesture)
        
        
        // Set profile pic and username label
        if (photo.user != nil){
            if let pic = photo.user.microProfilePictureURL{
                finalcell.userProfilePicture.sd_setImageWithURL(pic)
            }
            
            finalcell.userProfileName.text = photo.user.username
            
            // Add action to userProfileName. Click to view user's stream
            if let navController = self.navigationController as? CSSocialFeedNavigationController{
                finalcell.userProfileName.addTarget(navController, action: "openUserProfile:", forControlEvents: UIControlEvents.TouchUpInside, passedValue: photo)
            }

        }
        
        // Set the created at
        if(photo.createdAtDate != nil){
            finalcell.timeAgoLabel.text = photo.createdAtDate.timeAgoSinceNow()
        }else{
            finalcell.timeAgoLabel.text = "Smart alert"
        }
        
        // Set the title
        finalcell.titleAndHashtags.text = photo.title

        // Set the carbs value
        if let carbs = photo.carbsEstimate{
            finalcell.setCarbsEstimateToValue(carbs)
        }else{
            finalcell.hideCarbsEstimate()
        }
        
        return finalcell
    }
    
}

