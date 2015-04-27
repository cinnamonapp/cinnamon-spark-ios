//
//  CSMealRecordDetailView.swift
//  Cinnamon
//
//  Created by Alessio Santo on 20/04/15.
//  Copyright (c) 2015 Cinnamon. All rights reserved.
//

import UIKit

let mealRecordDetailViewReuseIdentifier = "detailRepeatablePhotoBrowserCell"

class CSMealRecordDetailView: UICollectionViewController {
    
    var photo : CSPhoto!
    
    override init(){
        // TODO: - Allow the developer to set this from inheritance
        super.init(collectionViewLayout: CSVerticalImageRowLayout() )
    }

    convenience init(photo: CSPhoto){
        self.init()
        
        self.photo = photo
    }
    
    convenience init(photoId: String){
        self.init()
        
        CSAPIRequest().getMealRecordWithId(photoId, self.handleRequestSuccessResponse, self.handleRequestFailureResponse)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        if(self.photo != nil){
            self.setQuirkyMessageWithPhoto(self.photo)
        }
        
        // Temporary fix for custom navbar
        self.collectionView?.frame.origin.y += 30
        self.collectionView?.frame.size.height -= 30
        // End
        
        // Register cell classes
        self.collectionView!.registerNib(UINib(nibName: "CSRepeatablePhotoBrowserCell", bundle: nil), forCellWithReuseIdentifier: mealRecordDetailViewReuseIdentifier)

        self.collectionView?.backgroundColor = viewsInsideBackgroundColor
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setQuirkyMessageWithPhoto(photo: CSPhoto){
        if let carbs = photo.carbsEstimate{
            switch carbs{
            case .High:
                self.setQuirkyMessage("I hope it was\n delicious at least.")
                break
            case .Medium:
                self.setQuirkyMessage("Quite good my friend,\n quite good.")
                break
            default: // .Low
                self.setQuirkyMessage("This looks like you\n finally learned something.")
            }
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
        
        self.setQuirkyMessageWithPhoto(self.photo)
        
        self.collectionView?.reloadData()
    }
    
    /**
    The handler function for failure meal records responses.
    Override to set custom behaviour for this action.
    */
    func handleRequestFailureResponse(operation: AFHTTPRequestOperation!, error: NSError!){

    }

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        //#warning Incomplete method implementation -- Return the number of sections
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //#warning Incomplete method implementation -- Return the number of items in the section
        if(self.photo != nil){
            return 1
        }else{
            return 0
        }
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(mealRecordDetailViewReuseIdentifier, forIndexPath: indexPath) as CSRepeatablePhotoBrowserCell
    
        // Configure the cell
        if(indexPath.section == 0){
            if(indexPath.item == 0){
                
                cell.setPhotoWithThumbURL(self.photo.URL, originalURL: self.photo.URL)
                
                cell.userProfileName.hidden = true
                cell.userProfilePicture.hidden = true
                
                cell.timeAgoLabel.text = self.photo.createdAtDate.timeAgoSinceNow()
                
                cell.titleAndHashtags.text = photo.title
                
                if let carbs = photo.carbsEstimate{
                    cell.setCarbsEstimateToValue(carbs)
                }

            }
        }

        
    
        return cell
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
