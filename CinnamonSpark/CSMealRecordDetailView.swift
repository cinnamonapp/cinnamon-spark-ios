//
//  CSMealRecordDetailView.swift
//  Cinnamon
//
//  Created by Alessio Santo on 20/04/15.
//  Copyright (c) 2015 Cinnamon. All rights reserved.
//

import UIKit

let mealRecordDetailViewReuseIdentifier = "mealRecordDetailCell"

class CSMealRecordDetailView: CSRefreshableCollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var photo : CSPhoto!
    
    override init(){
        // TODO: - Allow the developer to set this from inheritance
        super.init(collectionViewLayout: CSVerticalImageRowLayout() )
        
        let closeButton = UIButton(frame: CGRectMake(view.bounds.width - 40 - 10, 30, 40, 40))
        let closeButtonImage = UIImageView(image: UIImage(named: "CameraCancelButton"))
        closeButtonImage.frame = closeButton.bounds
        closeButton.addTarget(self, action: "closeViewController", forControlEvents: UIControlEvents.TouchUpInside)
        closeButton.addSubview(closeButtonImage)
        
        self.view.addSubview(closeButton)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle{
        return UIStatusBarStyle.LightContent
    }

    convenience init(photo: CSPhoto){
        self.init()
        
        self.photo = photo
        
        setBackgroundWithPhoto(photo)
        
        // Make an api request anyway
        CSAPIRequest().getMealRecordWithId(photo.id, self.handleRequestSuccessResponse, self.handleRequestFailureResponse)
    }
    
    convenience init(photoId: String){
        self.init()
        
        CSAPIRequest().getMealRecordWithId(photoId, self.handleRequestSuccessResponse, self.handleRequestFailureResponse)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func refreshDataWithRefreshControl(refreshControlOrNil: UIRefreshControl?) {
        CSAPIRequest().getMealRecordWithId(photo.id, self.handleRequestSuccessResponse, self.handleRequestFailureResponse)
    }
    
    func setBackgroundWithPhoto(photo: CSPhoto){
        setBlurredBackgroundImageWithURL(photo.photoURL(CSPhotoPhotoStyle.BlurredBackground))
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        self.collectionView?.bounces = true
        self.collectionView?.alwaysBounceVertical = true
        
        // Register cell classes
        self.collectionView!.registerNib(UINib(nibName: "CSMealRecordDetailCell", bundle: nil), forCellWithReuseIdentifier: mealRecordDetailViewReuseIdentifier)
        
        self.collectionView?.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "calorificCell")
        
        // Do any additional setup after loading the view.
        if let navigationController = self.navigationController{
            let buttonItem = UIBarButtonItem(barButtonSystemItem: .Stop, target: self, action: "closeViewController")
            self.navigationItem.rightBarButtonItem = buttonItem
            navigationController.navigationBarHidden = true
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func closeViewController(){
        if let navigationController = self.navigationController{
            navigationController.dismissViewControllerAnimated(true, completion: nil)
        }else{
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: CSAPIRequest methods
    
    /**
    The handler function for success meal records responses.
    Override to set custom behaviour for this action.
    */
    func handleRequestSuccessResponse(operation: AFHTTPRequestOperation!, responseObject: AnyObject!){
        var mealRecord = responseObject as NSDictionary
        
        self.photo = CSPhoto(dictionary: mealRecord)
        
        self.collectionView?.reloadData()
        
        setBackgroundWithPhoto(photo)
        
        refreshControlEndRefreshing()
    }
    
    /**
    The handler function for failure meal records responses.
    Override to set custom behaviour for this action.
    */
    func handleRequestFailureResponse(operation: AFHTTPRequestOperation!, error: NSError!){
        refreshControlEndRefreshing()
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        //#warning Incomplete method implementation -- Return the number of sections
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //#warning Incomplete method implementation -- Return the number of items in the section
        if(self.photo != nil){
            return 2
        }else{
            return 0
        }
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(mealRecordDetailViewReuseIdentifier, forIndexPath: indexPath) as CSMealRecordDetailCell
    
        cell.backgroundColor = UIColor.clearColor()
        
        // Configure the cell
        if(indexPath.section == 0){
            if(indexPath.item == 0){
                
                cell.setPhotoWithThumbURL(self.photo.photoURL(CSPhotoPhotoStyle.Thumbnail), originalURL: self.photo.photoURL(CSPhotoPhotoStyle.Large), andMealSize: self.photo.size)
                
                cell.setUserWithUser(photo.user)
                
                cell.timeAgoLabel.text = self.photo.createdAtDate.timeAgoSinceNow()
                
                cell.titleAndHashtags.text = photo.title
                
                cell.setCarbsEstimateToValue(CSPhotoMealCarbsEstimate.Low, grams: 0)
                cell.indicatorRing.progress = 0
                cell.indicatorRing.textColor = ColorPalette.DefaultTextColor
                cell.indicatorRing.font = DefaultFont!
                
                
                if let carbs = photo.carbsEstimate{
                    cell.setCarbsEstimateToValue(carbs, grams: photo.carbsEstimateGrams)
                    if let grams = photo.carbsEstimateGrams{
                        var dividend = 200
                        
                        if let currentUser = CSUser.currentUser(){
                            dividend = currentUser.dailyCarbsLimit
                        }
                        
                        cell.indicatorRing.progress = CGFloat(grams) / CGFloat(dividend)
                    }
                }
                
                cell.timeAgoIcon.hidden = true
                cell.timeAgoLabel.hidden = true
                cell.hideCarbsEstimate()
                
                collectionView.setStoredSize(cell.computedSize(), forItemAtIndexPath: indexPath)
            }
            
            if(indexPath.item == 1){
                let newCell = collectionView.dequeueReusableCellWithReuseIdentifier("calorificCell", forIndexPath: indexPath) as UICollectionViewCell
                
                newCell.backgroundColor = UIColor.clearColor()
                
                let backgroundImage = UIImageView()
                backgroundImage.contentMode = UIViewContentMode.ScaleAspectFit
                
                // Hardcoding swaps
                // Chips and crackers
                if (self.photo.id == "1354"){
                    backgroundImage.image = UIImage(named: "swap-chips")
                // Lasagna
                }else if(self.photo.id == "1366"){
                    backgroundImage.image = UIImage(named: "swap-lasagna")
                // Tortillas
                }else if(self.photo.id == "1365"){
                    backgroundImage.image = UIImage(named: "swap-tortilla")
                // Coke
                }else if(self.photo.id == "1370"){
                    backgroundImage.image = UIImage(named: "swap-coke")
                }else{
                    backgroundImage.image = UIImage(named: "FakeCalorific")
                }
                
                backgroundImage.frame = newCell.bounds
                backgroundImage.frame.size.width -= 20
                backgroundImage.frame.origin.x += 10
                newCell.addSubview(backgroundImage)
                
                return newCell
                
            }
        }

        
    
        return cell
    }
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        var size = CGSizeMake(50, 50)
        
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout{
            size = flowLayout.itemSize
        }
        
        if let storedSize = collectionView.retreiveStoredSizeForItemAtIndexPath(indexPath){
            size = storedSize
        }
        
        return size
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */
    
}
