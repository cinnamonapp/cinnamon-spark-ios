//
//  DashboardViewController.swift
//  Cinnamon
//
//  Created by Alessio Santo on 12/05/15.
//  Copyright (c) 2015 Cinnamon. All rights reserved.
//

import UIKit

let dashboardCellReuseIdentifier = "dashboardViewCell"

class DashboardViewController: UICollectionViewController, UIViewControllerTransitioningDelegate, DotsScrollViewDelegate {
    
    var dashboardObject : CSDashboard? {
        get{
            return _dashboardObject
        }
        
        set{
            _dashboardObject = newValue
        }
    }
    var _dashboardObject : CSDashboard?
    
    var selectedStreakDay : StreakDay?
    
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
    
    func setReloadCollectionView(){
        collectionView?.reloadData()
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
    
    func openLastMealDetailViewController(){
        
        if let streakDay = selectedStreakDay{
            if let lastMealRecord = streakDay.lastMealRecord{
                let mealDetailViewController = CSMealRecordDetailView(photo: lastMealRecord)

                self.presentViewController(mealDetailViewController, animated: true, completion: nil)
            }
            return 
        }
        
        if let dashboard = dashboardObject{
            
            if let lastMealRecord = dashboard.lastMealRecord{
                let mealDetailViewController = CSMealRecordDetailView(photo: lastMealRecord)
//                let navController = UINavigationController(rootViewController: mealDetailViewController)
        
                self.presentViewController(mealDetailViewController, animated: true, completion: nil)
            }
            
        }
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(dashboardCellReuseIdentifier, forIndexPath: indexPath) as DashboardViewCell
        
        // Configure the cell
        if(indexPath.section == 0){
            if(indexPath.item == 0){
                
                // Set self as dots delegate
                cell.streakDotsView.delegate = self
                cell.ringDisplayViewTapGesture.addTarget(self, action: "openLastMealDetailViewController")
                
                // The user selected a streakDay
                if let streakDay = selectedStreakDay{
                    let progress : CGFloat = CGFloat(streakDay.dailyUsedCarbs) / CGFloat(streakDay.dailyCarbsLimit)
                    cell.setRingProgress(progress, withStatus: streakDay.status)
                    
                    // Carbs indicator
                    let dailyRemainingCarbs = streakDay.dailyRemainingCarbs
                    cell.carbsIndicatorView.text = "\(dailyRemainingCarbs)g"
                    cell.carbsIndicatorSupportTextView.text = "left"
                    
                    if(dailyRemainingCarbs < 0){
                        cell.carbsIndicatorView.text = "+\(-dailyRemainingCarbs)g"
                        cell.carbsIndicatorSupportTextView.text = "above"
                    }
                    
                    cell.messageView.text = "\(streakDay.fullWeekDay) \(streakDay.date.day()).\(streakDay.date.month()).\(streakDay.date.year())"
                    
                    cell.setLastMealRecord(streakDay.lastMealRecord)
                    
                    if let lastMealRecord = streakDay.lastMealRecord{
                        cell.setBackgroundImageWithURL(lastMealRecord.photoURL(CSPhotoPhotoStyle.BlurredBackground))
                    }
                    
                    return cell
                }
                
                // Dashboard data is there
                if let dashboard = dashboardObject{
                    
                    // Ring progress
                    let dailyRemainingCarbs = dashboard.dailyRemainingCarbs

                    let progress : CGFloat = CGFloat(dashboard.dailyUsedCarbs) / CGFloat(dashboard.dailyCarbsLimit)
                    
                    cell.setRingProgress(progress, withStatus: dashboard.currentStatusAtTime)
                    
                    // Carbs indicator
                    
                    cell.carbsIndicatorView.text = "\(dailyRemainingCarbs)g"
                    cell.carbsIndicatorSupportTextView.text = "left"
                    
                    if(dailyRemainingCarbs < 0){
                        cell.carbsIndicatorView.text = "+\(-dailyRemainingCarbs)g"
                        cell.carbsIndicatorSupportTextView.text = "above"
                    }
                    
                    // Last meal
                    cell.setLastMealRecord(dashboard.lastMealRecord)
                    
                    // Set cell background
                    if let backgroundImageURL = dashboard.backgroundImageURL{
                        cell.setBackgroundImageWithURL(backgroundImageURL)
                    }else if let lastMealRecord = dashboard.lastMealRecord{
                        cell.setBackgroundImageWithURL(lastMealRecord.photoURL(CSPhotoPhotoStyle.BlurredBackground))
                    }
                    
                    if let currentStreak = dashboard.currentStreak{
                        cell.setStreak(currentStreak)
                    }
                    
                    if let smartAlertMessage = dashboard.smartAlertMessage{
                        cell.messageView.text = smartAlertMessage
                    }
                    
                }
            }
        }
    
        return cell
    }

    
    // MARK: - DotsScrollViewDelegate methods
    
    func dotsScrollView(dotsScrollView: DotsScrollView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        if let dashboard = dashboardObject{
            if let streak = dashboard.currentStreak{
                if (indexPath.item == streak.count - 1){
                    // Select the current day
                    selectedStreakDay = nil
                }else{
                    selectedStreakDay = streak[indexPath.item]
                }
            }
        }
        
        setReloadCollectionView()
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
