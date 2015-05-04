//
//  CSPhotoBrowser.swift
//  CinnamonSpark
//
//  Created by Alessio Santo on 02/04/15.
//  Copyright (c) 2015 Cinnamon. All rights reserved.
//

import UIKit

let topInterfaceReuseIdentifier = "TopInterfaceCell"
let mealRecordFeedItemReuseIdentifier = "feedItemRepeatablePhotoBrowserCell"


class CSPhotoBrowser: UICollectionViewController, UICollectionViewDelegateFlowLayout, CSPhotoBrowserDelegate {

    var photos : [CSPhoto] = []
    var delegate : CSPhotoBrowserDelegate?
    var refreshControl : UIRefreshControl?
    
    override init(){
        // TODO: - Allow the developer to set this from inheritance
        super.init(collectionViewLayout: CSVerticalImageRowLayout() )
        
        // By default set the delegate to self
        self.delegate = self
        
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.registerNib(UINib(nibName: "CSRepeatablePhotoBrowserCell", bundle: nil), forCellWithReuseIdentifier:  mealRecordFeedItemReuseIdentifier)
        self.collectionView!.registerClass(CSPhotoBrowserCell.self, forCellWithReuseIdentifier: topInterfaceReuseIdentifier)
        self.collectionView!.backgroundColor = viewsInsideBackgroundColor

        self.collectionView?.alwaysBounceVertical = true
        
        // Do any additional setup after loading the view.
        self.loadPhotos()
        
        
        if let delegate = self.delegate?{
            
            // Set a refresh control in the collection view if this method has been implemented
            if(delegate.respondsToSelector("userRequiredRefreshWithRefreshControl:")){
                
                self.refreshControl = UIRefreshControl()
                
                self.refreshControl?.addTarget(self, action: "userRequiredRefreshWithRefreshControl:", forControlEvents: UIControlEvents.ValueChanged)
                
                
                self.collectionView?.addSubview(self.refreshControl!)
            }
            
        }
        
    }
    
    /**
        This function is vital. It is called automatically by the CSPhotoBrowser to fill up the photos array.
    */
    func loadPhotos(){
        self.collectionView?.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UICollectionViewDataSource

    private func elementsCountForSection(section: Int) -> Int{
        var count = 0
        
        // If wants top interface and is the first section
        if(self.wantsCustomizableTopViewInterface() && section == 0){
            count = 1
        }else{
            count = self.photos.count
        }
        
        return count
    }
    
    private func sectionsCount() -> Int{
        var count = 1
        
        if(self.wantsCustomizableTopViewInterface()){
            count = 2
        }
        
        return count
    }
    
    /**
    Returns true/false if the developer has/has not implemented some specific methods to delegate
    */
    private func wantsCustomizableTopViewInterface() -> Bool{
        var has = false
        
        if let delegate = self.delegate?{
            if(delegate.respondsToSelector("photoBrowser:customizableTopViewInterface:")){
                has = true
            }
        }
        
        return has
    }
    
    private func wantsCustomizableTopViewInterfaceWithIndexPath(indexPath: NSIndexPath) -> Bool{
        var value = false
        
        if(self.wantsCustomizableTopViewInterface() && indexPath.section == 0){
            value = true
        }
        
        return value
    }
    
    private func hasDelegate() -> Bool{
        var response = false
        
        if let delegate = self.delegate?{
            response = true
        }
        
        return true
    }
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        //#warning Incomplete method implementation -- Return the number of sections
        return self.sectionsCount()
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //#warning Incomplete method implementation -- Return the number of items in the section
        return self.elementsCountForSection(section)
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier(mealRecordFeedItemReuseIdentifier, forIndexPath: indexPath) as CSRepeatablePhotoBrowserCell
        
        // If the developer wants a top interface space give him what he wants
        if(self.wantsCustomizableTopViewInterfaceWithIndexPath(indexPath)){
            
            let delegate = self.delegate!
            
            // Initialize a new cell for the top interface
            var newcell = collectionView.dequeueReusableCellWithReuseIdentifier(topInterfaceReuseIdentifier, forIndexPath: indexPath) as CSPhotoBrowserCell
            newcell.setPhotoBrowser(photoBrowser: self)
            newcell = delegate.photoBrowser!(self, customizableTopViewInterface: newcell)
            
            return newcell
        }else{
            
//            cell.setPhotoBrowser(photoBrowser: self)

            let photo : CSPhoto = self.photos[indexPath.item] as CSPhoto
            
            // Check if there's delegate
            if let delegate = self.delegate?{
                // If the function has been implemented
                if(delegate.respondsToSelector("photoBrowser:forCollectionView:customizablePhotoBrowserCell:atIndexPath:withPhoto:")){
                    cell = delegate.photoBrowser!(self, forCollectionView: collectionView, customizablePhotoBrowserCell: cell, atIndexPath: indexPath, withPhoto: photo)
                }
            }
            
        }
            
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        let reusableView = UICollectionReusableView()
        println("hello there!!!")
        
        return reusableView
    }

    
    // MARK: - UICollectionViewDelegateFlowLayout methods
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        var size : CGSize!
        
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout{
            size = layout.itemSize
        }
        
        if let layout = collectionViewLayout as? CSVerticalImageRowLayout{
            size = layout.itemSize
        }
        
        if let layout = collectionViewLayout as? CSGridImageTagLayout{
            size = layout.itemSize
        }
        
        // This checks also the presence of the delegate
        if(self.wantsCustomizableTopViewInterfaceWithIndexPath(indexPath)){
            
            size = CGSizeMake(collectionView.frame.width, collectionView.frame.width)
            
            // I know delegate is there
            let delegate = self.delegate!
            
            if(delegate.respondsToSelector("sizeForCustomizableTopViewInterface:itemSize:")){
                size = delegate.sizeForCustomizableTopViewInterface!(self, itemSize: size)
            }
            
            
        }else if let delegate = self.delegate{
            
            if(delegate.respondsToSelector("photoBrowser:forCollectionView:layout:sizeForPhoto:atIndexPath:")){
                var photo : CSPhoto
                photo = self.photos[indexPath.item]
                
                size = delegate.photoBrowser!(self, forCollectionView: collectionView, layout: collectionViewLayout, sizeForPhoto: photo, atIndexPath: indexPath)
            }
            
        }
        
        return size
    }
    
    // MARK: - CSPhotoBrowserDelegate methods
    func photoBrowser(photoBrowser: CSPhotoBrowser, forCollectionView collectionView: UICollectionView, customizablePhotoBrowserCell cell: CSRepeatablePhotoBrowserCell, atIndexPath indexPath: NSIndexPath, withPhoto photo: CSPhoto) -> CSRepeatablePhotoBrowserCell {
        return cell
    }
    
    
    func photoBrowser(photoBrowser: CSPhotoBrowser, forCollectionView collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForPhoto photo: CSPhoto, atIndexPath indexPath: NSIndexPath) -> CGSize{
        var size : CGSize!
        
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout{
            size = layout.itemSize
        }
        
        if let layout = collectionViewLayout as? CSVerticalImageRowLayout{
            size = layout.itemSize
        }
        
        if let layout = collectionViewLayout as? CSGridImageTagLayout{
            size = layout.itemSize
        }
        
        return size
    }
    
}

@objc
protocol CSPhotoBrowserDelegate : NSObjectProtocol{
    
    /**
        Implement this method if you need a refresh control to the collection view.
        You must call refreshControl.endRefreshing() when done.
    */
    optional func userRequiredRefreshWithRefreshControl(refreshControl: UIRefreshControl)
    
    /**
        This method is called by collectionView(_: cellForItemAtIndexPath:) when building the cell. Use this method to get a cell to customize, customize it and return it.
    
        :param: photoBrowser The photobrowser instance in use
        :param: cell The cell that needs customization
        :param: indexPath The index path of the customizable cell
        :param: photo The photo from the array
    */
    optional func photoBrowser( photoBrowser:                       CSPhotoBrowser,
                                forCollectionView collectionView:   UICollectionView,
                                customizablePhotoBrowserCell cell:  CSRepeatablePhotoBrowserCell,
                                atIndexPath indexPath:              NSIndexPath,
                                withPhoto photo:                    CSPhoto) -> CSRepeatablePhotoBrowserCell
    
    /**
        When overridden, this method allows you to customize a special cell that will stay always on top of your collection view where you will be able to add custom UI. Commonly used for defining custom actions, custom headers etc.
    
        :param: photoBrowser The photoBrowser instance in use
        :param: cell The cell that needs customization
    */
    optional func photoBrowser(photoBrowser: CSPhotoBrowser, customizableTopViewInterface cell: CSPhotoBrowserCell) -> CSPhotoBrowserCell
    
    /**
        Override to give custom size to top view interface
    */
    optional func sizeForCustomizableTopViewInterface(photoBrowser: CSPhotoBrowser, itemSize: CGSize) -> CGSize
    
    /**
        Customize cell size at indexPath with photo
    */
    optional func photoBrowser( photoBrowser: CSPhotoBrowser,
                                forCollectionView collectionView: UICollectionView,
                                layout collectionViewLayout: UICollectionViewLayout,
                                sizeForPhoto photo: CSPhoto,
                                atIndexPath indexPath: NSIndexPath) -> CGSize
    
}

