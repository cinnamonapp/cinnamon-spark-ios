//
//  CSMealRecordDetailView.swift
//  Cinnamon
//
//  Created by Alessio Santo on 20/04/15.
//  Copyright (c) 2015 Cinnamon. All rights reserved.
//

import UIKit

let mealRecordDetailViewReuseIdentifier = "repeatablePhotoBrowserCell"

class CSMealRecordDetailView: UICollectionViewController {
    
    override init(){
        // TODO: - Allow the developer to set this from inheritance
        super.init(collectionViewLayout: CSVerticalImageRowLayout() )
    }


    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Register cell classes
        self.collectionView!.registerNib(UINib(nibName: "CSRepeatablePhotoBrowserCell", bundle: nil), forCellWithReuseIdentifier: mealRecordDetailViewReuseIdentifier)

        self.collectionView?.backgroundColor = viewsBackgroundColor
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        //#warning Incomplete method implementation -- Return the number of sections
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //#warning Incomplete method implementation -- Return the number of items in the section
        return 1
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(mealRecordDetailViewReuseIdentifier, forIndexPath: indexPath) as CSRepeatablePhotoBrowserCell
    
        // Configure the cell
        cell.photo.sd_setImageWithURL(NSURL(string: "http://s3.amazonaws.com/cinnamon-spark-beta/meal_records/photos/000/000/408/medium/meal_photo.jpeg?1429530443"))
        cell.photo.frame.size.height = cell.photo.frame.width
        
        cell.userProfileName.hidden = true
    
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
