//
//  CSPhotoBrowserViewController.swift
//  CinnamonSpark
//
//  Created by Alessio Santo on 20/03/15.
//  Copyright (c) 2015 Cinnamon. All rights reserved.
//

import Foundation

class CSSocialPhotoFeedViewController: CSPhotoBrowser, UIScrollViewDelegate {

    let APIRequest = CSAPIRequest()
    let mealSizesArray = ["small", "medium", "large"]
    
    // Pagination stuff
    var isAlreadyRefreshing : Bool = true
    var queryPage = 1
    var continueLoadingPhotos = true
    
    override init(){
        // TODO: - Allow the developer to set this from inheritance
        super.init(collectionViewLayout: CSCommunityViewLayout() )
        
        // By default set the delegate to self
        self.delegate = self
        
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.barStyle = UIBarStyle.BlackTranslucent
        
        // Temporary fix for custom navbar
//        self.collectionView?.frame.origin.y += 30
//        self.collectionView?.frame.size.height -= 30
        // End
        
        self.collectionView?.backgroundColor = viewsBackgroundColor
        self.collectionView?.registerNib(UINib(nibName: "CSMealRecordActionsCell", bundle: nil), forSupplementaryViewOfKind: CSCommunityViewActionsDecorationViewKind, withReuseIdentifier: CSCommunityViewActionsDecorationViewKind)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if(photos.count == 0){
            // Try to load photos again if there aren't any photos still
            loadPhotos()
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if let navigationController = self.navigationController{
            navigationController.cs_rootViewController?.swipeInteractionEnabled = true
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
    
    override func repeatablePhotoBrowserCellNibName() -> String {
        return "CSMealRecordDetailCell"
    }
    
    override func repeatablePhotoBrowserReuseIdentifier() -> String {
        return "mealRecordDetailCell"
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
        
        for (index, mealRecord) in enumerate(mealRecords){
            
            let csPhoto = CSPhoto(dictionary: mealRecord)
            
            if(index == 0){
                self.setBlurredBackgroundImageWithURL(csPhoto.photoURL(.BlurredBackground))
            }

            
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
        println("There was an error in the community view api")
    }
    
    
    // MARK: - UIScrollViewDelegate methods
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        
        let collectionView = self.collectionView!
        
        let didScrollToBottom = (collectionView.contentOffset.y > (collectionView.contentSize.height - collectionView.bounds.size.height - 400))
        
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
        var finalcell = cell as CSMealRecordDetailCell
        
        finalcell.backgroundColor = UIColor.clearColor()
        
        finalcell.photoTapGesture.addTarget(self, action: "openMealDetailViewController:", passedArguments: [
            "mealRecord": photo
        ])
        
        finalcell.setPhotoWithThumbURL(photo.photoURL(CSPhotoPhotoStyle.Thumbnail), originalURL: photo.photoURL(CSPhotoPhotoStyle.Large), andMealSize: photo.size)
        
        finalcell.setUserWithUser(photo.user)
        
        finalcell.timeAgoLabel.text = photo.createdAtDate.shortTimeAgoSinceNow()
        
        finalcell.titleAndHashtags.text = photo.title
        
        finalcell.setCarbsEstimateToValue(CSPhotoMealCarbsEstimate.Low, grams: 0)
        finalcell.indicatorRing.progress = 0
        finalcell.indicatorRing.textColor = ColorPalette.DefaultTextColor
        finalcell.indicatorRing.font = DefaultFont!
        
        
        if let carbs = photo.carbsEstimate{
            finalcell.setCarbsEstimateToValue(carbs, grams: photo.carbsEstimateGrams)
            if let grams = photo.carbsEstimateGrams{
                var dividend = 200
                
                if let currentUser = CSUser.currentUser(){
                    dividend = currentUser.dailyCarbsLimit
                }
                
                finalcell.indicatorRing.progress = CGFloat(grams) / CGFloat(dividend)
            }
        }
        
        cell.hideCarbsEstimate()
        
        return finalcell
    }
    
    func openMealDetailViewController(sender: AnyObject?){

        if let gestureRecognizer = sender as? UIGestureRecognizer{
            if let passedArguments = gestureRecognizer.passedArguments as? NSDictionary{
                if let mealRecord = passedArguments["mealRecord"] as? CSPhoto{
                    
                    
                    if let navigationController = self.navigationController{
                        if let rootViewController = navigationController.cs_rootViewController{
                            rootViewController.openMealDetailViewControllerWithMealRecord(mealRecord, animated: true)
                        }
                    }
                    
                }
            }
        }
    }
    

    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        var supplementaryView = collectionView.dequeueReusableSupplementaryViewOfKind(CSCommunityViewActionsDecorationViewKind, withReuseIdentifier: CSCommunityViewActionsDecorationViewKind, forIndexPath: indexPath) as CSMealRecordActionsCell
        
        let mealRecord = photoAtIndexPath(indexPath)
        
        
        supplementaryView.loveButtonItem.isLoved = mealRecord.hasBeenLikedByUser!
        supplementaryView.loveButtonItem.label.text = mealRecord.likesCount?.description
        
        supplementaryView.loveButtonItem.setTarget(self, action: "loveSelectedMealRecord:", passedArguments: [
            "indexPath" : indexPath
        ])
        
        
        
        supplementaryView.commentButtonItem.label.text = mealRecord.commentsCount?.description
        supplementaryView.commentButtonItem.setTarget(self, action: "commentSelectedMealRecord:", passedArguments: [
            "indexPath" : indexPath
        ])
        
        return supplementaryView
    }
    
    func loveSelectedMealRecord(sender: AnyObject?){
        
        if let argumentableSender = sender as? Argumentable{
            if let passedArgs = argumentableSender.passedArguments as? NSDictionary{
                if let indexPath = passedArgs["indexPath"] as? NSIndexPath{
                    
                    let mealRecord = photoAtIndexPath(indexPath)
                    
                    // Tap on heart
                    if let heartButton = sender as? UIButton{
                        println("liking")
                        
                        
                        if let loveButtonItem = heartButton._parent_ as? CSLoveBarButtonItem{
                            // Is liked
                            if((mealRecord.hasBeenLikedByUser!)){
                                mealRecord.hasBeenLikedByUser = false
                                mealRecord.likesCount! -= 1
                            }else{
                                mealRecord.hasBeenLikedByUser = true
                                mealRecord.likesCount! += 1
                            }
                            
                            loveButtonItem.label.text = "\(mealRecord.likesCount!)"
                            loveButtonItem.isLoved = mealRecord.hasBeenLikedByUser!
                            
                        }
                        
                        let like = CSLike()
                        like.user = CSUser.currentUser()
                        like.mealRecord = mealRecord
                        
                        like.save(success: handleLikeMealRecordRequestSuccess, failure: handleLikeMealRecordRequestFailure)
                    }
                    
                    println("showing likers")
                    
                    // Tap on label
                    if let gesture = sender as? UIGestureRecognizer{
                        println("showing likers")
                        
                        openMealRecordLikesViewForMealRecord(mealRecord)
                    }
                }
            }
        }
        
    }
    
    
    func commentSelectedMealRecord(sender: AnyObject?){
        if let argumentableSender = sender as? Argumentable{
            if let passedArgs = argumentableSender.passedArguments as? NSDictionary{
                if let indexPath = passedArgs["indexPath"] as? NSIndexPath{
                    let mealRecord = photoAtIndexPath(indexPath)
                    
                    self.openMealRecordCommentsViewForMealRecord(mealRecord)
                }
            }
        }
    }
    
    
    func openMealRecordCommentsViewForMealRecord(mealRecord: CSPhoto){
        if let navigationController = self.navigationController{
            let mealRecordCommentsView = CSMealRecordCommentsView()
            mealRecordCommentsView.mealRecord = mealRecord
            
            navigationController.popToRootViewControllerAnimated(false)
            
            navigationController.pushViewController(mealRecordCommentsView, animated: true)
        }
    }
    
    func openMealRecordLikesViewForMealRecord(mealRecord: CSPhoto){
        if let navigationController = self.navigationController{
            let mealRecordLikesController = CSMealRecordLikesView(mealRecord: mealRecord)
            
            navigationController.popToRootViewControllerAnimated(false)
            
            navigationController.pushViewController(mealRecordLikesController, animated: true)
        }
    }
    
    func handleLikeMealRecordRequestSuccess(request: AFHTTPRequestOperation!, response: AnyObject!) -> Void{
        println(response)
    }
    
    func handleLikeMealRecordRequestFailure(request: AFHTTPRequestOperation!, error: NSError!) -> Void{
        println(error)
    }
    
//    override func sectionsCount() -> Int {
//        var count = self.photos.count
//        
//        return count
//    }
//    
//    override func elementsCountForSection(section: Int) -> Int {
//        return 1
//    }
//    
//    
//    override func photoAtIndexPath(indexPath: NSIndexPath) -> CSPhoto {
//        return self.photos[indexPath.section]
//    }
    
    // Auto size height when smart alert
    override func photoBrowser(photoBrowser: CSPhotoBrowser, forCollectionView collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForPhoto photo: CSPhoto, atIndexPath indexPath: NSIndexPath) -> CGSize {
        var size = super.photoBrowser(photoBrowser, forCollectionView: collectionView, layout: collectionViewLayout, sizeForPhoto: photo, atIndexPath: indexPath)

        // If the id is -1 it means that is a smart alert
//        if (photo.id == "-1"){
//            // Crop 35%
//            size.height -= size.height * 0.30
//        }

        return size
    }
}






@objc
protocol BlurBackgroundable{
    var blurredBackgroundImage : UIImage? {get set}
    
    func setBlurredBackgroundImageWithURL(url: NSURL)
}

private var blurredBackgroundImageViewAssociationKey : UInt8 = 0
//extension UICollectionViewController : BlurBackgroundable{
//    
//    
//    
//    var blurredBackgroundImage : UIImage?{
//        get{
//            return blurredBackgroundImageView.image
//        }
//        
//        set{
//            blurredBackgroundImageView.image = newValue
//        }
//    }
//    
//    func setBlurredBackgroundImageWithURL(url: NSURL) {
//        blurredBackgroundImageView.sd_setImageWithURL(url)
//    }
//    
//    private var blurredBackgroundImageView : UIImageView! {
//        get{
//            var imageView = objc_getAssociatedObject(self, &blurredBackgroundImageViewAssociationKey) as UIImageView!
//            
//            if(imageView == nil){
//                
//                let mainScreenBounds = UIScreen.mainScreen().bounds
//                
//                imageView = UIImageView(frame: mainScreenBounds)
//                imageView.contentMode = .Center
//                
//                let blackOverlay = UIView(frame: mainScreenBounds)
//                blackOverlay.backgroundColor = UIColorFromHex(0x000000, alpha: 0.6)
//                imageView.addSubview(blackOverlay)
//                
//                collectionView?.backgroundView = imageView
//                
//                objc_setAssociatedObject(self, &blurredBackgroundImageViewAssociationKey, imageView, objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN))
//            }
//            
//            return imageView
//        }
//    }
//    
//}

extension UIViewController : BlurBackgroundable{
    
    var blurredBackgroundImage : UIImage?{
        get{
            return blurredBackgroundImageView.image
        }
        
        set{
            blurredBackgroundImageView.image = newValue
        }
    }
    
    func setBlurredBackgroundImageWithURL(url: NSURL) {
        blurredBackgroundImageView.sd_setImageWithURL(url)
    }
    
    private var blurredBackgroundImageView : UIImageView! {
        get{
            var imageView = objc_getAssociatedObject(self, &blurredBackgroundImageViewAssociationKey) as UIImageView!
            
            if(imageView == nil){
                
                let mainScreenBounds = UIScreen.mainScreen().bounds
                
                imageView = UIImageView(frame: mainScreenBounds)
                imageView.contentMode = UIViewContentMode.ScaleAspectFill
                
                let blackOverlay = UIView(frame: mainScreenBounds)
                blackOverlay.backgroundColor = UIColorFromHex(0x000000, alpha: 0.6)
                imageView.addSubview(blackOverlay)
                
                if let isCollectionViewController = self as? UICollectionViewController{
                    isCollectionViewController.collectionView?.backgroundView = imageView
                }else if let isTableViewController = self as? UITableViewController{
                    isTableViewController.tableView?.backgroundView = imageView
                }else if let isSLKTextViewController = self as? SLKTextViewController{
                    isSLKTextViewController.collectionView?.backgroundView = imageView
                    isSLKTextViewController.tableView?.backgroundView = imageView
                }else{
                    self.view.addSubview(imageView)
                }

                objc_setAssociatedObject(self, &blurredBackgroundImageViewAssociationKey, imageView, objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN))
            }
            
            return imageView
        }
    }
    
}


