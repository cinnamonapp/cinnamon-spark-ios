//
//  DashboardViewController.swift
//  Cinnamon
//
//  Created by Alessio Santo on 12/05/15.
//  Copyright (c) 2015 Cinnamon. All rights reserved.
//

import UIKit

let dashboardCellReuseIdentifier = "dashboardViewCell"

class DashboardViewController: UICollectionViewController {
    
    var dashboardObject : CSDashboard? {
        get{
            return _dashboardObject
        }
        
        set{
            _dashboardObject = newValue
        }
    }
    var _dashboardObject : CSDashboard?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        collectionView!.registerNib(UINib(nibName: "DashboardViewCell", bundle: nil), forCellWithReuseIdentifier: dashboardCellReuseIdentifier)
        
        collectionView!.bounces = true
        
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        refreshDashboard()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func refreshDashboard(){
        // Get data for the dashboard
        CSAPIRequest().getUserDashboard(handleRequestSuccessResponse, handleRequestFailureResponse)
    }
    
    // MARK: - Data handling
    
    func handleRequestSuccessResponse(request: AFHTTPRequestOperation!, responseObject: AnyObject!){
        dashboardObject = CSDashboard(dictionary: responseObject as NSDictionary)
        
        collectionView?.reloadData()
    }
    
    func handleRequestFailureResponse(request: AFHTTPRequestOperation!, error: NSError!){
        
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
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(dashboardCellReuseIdentifier, forIndexPath: indexPath) as DashboardViewCell
        
        // Configure the cell
        if(indexPath.section == 0){
            if(indexPath.item == 0){
                
                if let dashboard = dashboardObject{
                    
                    let dailyCarbsLimit = dashboard.dailyCarbsLimit
                    let dailyUsedCarbs = dashboard.dailyUsedCarbs
                    
                    let progress : CGFloat = CGFloat(dailyUsedCarbs) / CGFloat(dailyCarbsLimit)
                    
                    cell.ringDisplayView.progress = progress
                    
                    
                    cell.carbsIndicatorView.text = "\(dashboard.dailyRemainingCarbs)g"
                    
                    cell.setLastMealRecord(dashboard.lastMealRecord)
                    
                    cell.backgroundImage.sd_setImageWithURL(dashboard.backgroundImageURL)
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
