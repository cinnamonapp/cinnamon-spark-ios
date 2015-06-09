//
//  CSPhotoBrowserViewController.swift
//  CinnamonSpark
//
//  Created by Alessio Santo on 20/03/15.
//  Copyright (c) 2015 Cinnamon. All rights reserved.
//

import Foundation


let mealViewDishCellIdentifier = "mealViewDishCell";
let mealViewDishSupplementaryCellIdentifier = "mealViewDishSupplementaryCell";
let mealViewDishSupplementaryRingCellIdentifier = "mealViewDishSupplementaryRingCell";

class CSUserPhotoFeedViewController: CSRefreshableCollectionViewController, UICollectionViewDelegateFlowLayout, CSMealViewDelegateFlowLayout {
    
    var meals : [CSMeal] = []
    
    var lastRetrievedMealsCount = 0
    
    var backgroundImageView : UIImageView!
    var blackLayer : UIView!
    
    override init(){
        super.init(collectionViewLayout: CSMealViewFlowLayout())
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        let collectionV = collectionView!
//        collectionV.frame.size.width = collectionV.frame.width - 80
        collectionView?.registerClass(CSMealViewDishCell.self, forCellWithReuseIdentifier: mealViewDishCellIdentifier)
        collectionView?.registerClass(CSMealViewHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: mealViewDishSupplementaryCellIdentifier)
        collectionView?.registerClass(CSIndicatorRingReusableView.self, forSupplementaryViewOfKind: CSMealViewElementKindSectionRing, withReuseIdentifier: mealViewDishSupplementaryRingCellIdentifier)
        
        refreshDataWithRefreshControl(nil)
        
        backgroundImageView = UIImageView()
        backgroundImageView.contentMode = .Center
        
        blackLayer = UIView()
        blackLayer.backgroundColor = UIColorFromHex(0x000000, alpha: 0.8)
        backgroundImageView.addSubview(blackLayer)
        
        collectionView?.backgroundView = backgroundImageView
        collectionView?.alwaysBounceVertical = true
    }
    
    
    override func refreshDataWithRefreshControl(refreshControlOrNil: UIRefreshControl?) {
        meals = []
        CSAPIRequest().getUserMeals(page: 1, success: handleMealsRequestSuccess, failure: handleMealsRequestFailure)
    }
    
    override func fetchPageWithIndex(index: Int) {
        CSAPIRequest().getUserMeals(page: index, success: handleMealsRequestSuccess, failure: handleMealsRequestFailure)
    }
    
    func openMealDetailViewControllerWithPhotoId(photoId: String, animated: Bool){
        
        let mealDetailViewController = CSMealRecordDetailView(photoId: photoId)
        //        let navController = UINavigationController(rootViewController: mealDetailViewController)
        
        self.presentViewController(mealDetailViewController, animated: animated, completion: nil)
    }
    
    func openMealDetailViewControllerWithMealRecord(mealRecord: CSPhoto, animated: Bool){
        
        let mealDetailViewController = CSMealRecordDetailView(photo: mealRecord)
        //        let navController = UINavigationController(rootViewController: mealDetailViewController)
        
        self.presentViewController(mealDetailViewController, animated: animated, completion: nil)
    }
    
    func handleMealsRequestSuccess(request: AFHTTPRequestOperation!, response: AnyObject!) {
        let mealsArray = (response as NSDictionary)["meals"] as [NSDictionary]
        
        lastRetrievedMealsCount = mealsArray.count
        
//        if let page = (response as NSDictionary)["page"] as? Int{
//            if(page == 1){
//                meals = []
//            }
//        }
        
        for mealDictionary in mealsArray{
            meals.append(CSMeal(dictionary: mealDictionary))
        }
        
        if(meals.count > 0){
            backgroundImageView.sd_setImageWithURL(meals.first?.mealRecords.first?.photoURL(.BlurredBackground))
        }
        
        collectionView?.reloadData()
        
        endPageFetching()
        refreshControlEndRefreshing()
        
//        let lastIndexPath = NSIndexPath(forItem: (meals.last?.mealRecords.count)! - 1, inSection: (meals.count - 1))
//        collectionView?.scrollToItemAtIndexPath(lastIndexPath, atScrollPosition: UICollectionViewScrollPosition.Bottom, animated: true)
    }
    
    override func shouldContinueToFetchPages() -> Bool {
        println(lastRetrievedMealsCount != 0)
        return (lastRetrievedMealsCount != 0)
    }
    
    func handleMealsRequestFailure(request: AFHTTPRequestOperation!, response: AnyObject!) {
        endPageFetching()
        refreshControlEndRefreshing()
    }
    
    
    
    // MARK: - CollectionView data source
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // Here goes the number of meals
        return meals.count
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return meals[section].mealRecords.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier(mealViewDishCellIdentifier, forIndexPath: indexPath) as CSMealViewDishCell
        
        var meal = meals[indexPath.section]
        var mealRecord = meal.mealRecords[indexPath.item]
        
        cell.setImageViewImageWithMealRecord(mealRecord)
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        var cell : UICollectionReusableView!
        
        if(kind == UICollectionElementKindSectionHeader){
            let newcell = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: mealViewDishSupplementaryCellIdentifier, forIndexPath: indexPath) as CSMealViewHeaderView
            
            var meal = meals[indexPath.section]
            newcell.dateLabel.text = meal.createdAt.toDefaultStringRepresentation()
            newcell.dateLabel.font = newcell.dateLabel.font.fontWithSize(12)
            
            if(indexPath.section > 0){
                let previousMeal = meals[indexPath.section - 1]
                if(meal.createdAt.compare(previousMeal.createdAt, unitGranularity: NSCalendarUnit.DayCalendarUnit) == NSComparisonResult.OrderedSame){
                    newcell.dateLabel.text = nil
                }
            }
            
            cell = newcell
        }
        
        if(kind == CSMealViewElementKindSectionRing){
            let newcell = collectionView.dequeueReusableSupplementaryViewOfKind(CSMealViewElementKindSectionRing, withReuseIdentifier: mealViewDishSupplementaryRingCellIdentifier, forIndexPath: indexPath) as CSIndicatorRingReusableView
            
            var meal = meals[indexPath.section]
            
            newcell.ringView.progress = CGFloat(meal.carbsEstimateGrams) / CGFloat(meal.user.dailyCarbsLimit)
            newcell.ringView.text = meal.carbsEstimateGrams.description

            
            cell = newcell
        }
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        var meal = meals[indexPath.section]
        var mealRecord = meal.mealRecords[indexPath.item]
        openMealDetailViewControllerWithPhotoId(mealRecord.id, animated: true)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        var size = CGSizeMake(collectionView.frame.width, 50)
        
        if(section > 0){
            let meal = meals[section]
            let previousMeal = meals[section - 1]
            if(meal.createdAt.compare(previousMeal.createdAt, unitGranularity: NSCalendarUnit.DayCalendarUnit) == NSComparisonResult.OrderedSame){
                size.height = 20
            }
        }
        
        return size
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        var meal = meals[indexPath.section]
        var mealRecord = meal.mealRecords[indexPath.item]
        
        if(mealRecord.size == CSPhotoMealSize.ExtraSmall){
            return CGSizeMake(80, 80)
        }
        
        if(mealRecord.size == CSPhotoMealSize.Small){
            return CGSizeMake(100, 100)
        }
        
        if(mealRecord.size == CSPhotoMealSize.Medium){
            return CGSizeMake(125, 125)
        }
        
        if(mealRecord.size == CSPhotoMealSize.Large){
            return CGSizeMake(150, 150)
        }
        
        return CGSizeMake(150, 150)
    }
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 15, 0, 100)
    }

//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, availableWidthSpaceForItemAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        return collectionView.bounds.width
//    }
    
    override func viewWillLayoutSubviews() {
        backgroundImageView.frame = view.bounds
        blackLayer.frame = backgroundImageView.bounds
    }
}



