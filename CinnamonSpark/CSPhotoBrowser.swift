//
//  CSPhotoBrowser.swift
//  CinnamonSpark
//
//  Created by Alessio Santo on 02/04/15.
//  Copyright (c) 2015 Cinnamon. All rights reserved.
//

import UIKit

let reuseIdentifier = "Cell"

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
        self.collectionView!.registerClass(CSPhotoBrowserCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView!.backgroundColor = viewsBackgroundColor

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

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        //#warning Incomplete method implementation -- Return the number of sections
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //#warning Incomplete method implementation -- Return the number of items in the section
        return self.photos.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as CSPhotoBrowserCell
    
        cell.setPhotoBrowser(photoBrowser: self)
        
        // Configure the cell
        
        let photo : CSPhoto = self.photos[indexPath.row] as CSPhoto
        
        // Check if there's delegate
        if let delegate = self.delegate?{
            // If the function has been implemented
            if(delegate.respondsToSelector("photoBrowser:customizablePhotoBrowserCell:atIndexPath:withPhoto:")){
                cell = delegate.photoBrowser!(self, customizablePhotoBrowserCell: cell, atIndexPath: indexPath, withPhoto: photo)
            }
        }
    
        return cell
    }

    
    // MARK: - CSPhotoBrowserDelegate methods
    func photoBrowser(photoBrowser: CSPhotoBrowser, customizablePhotoBrowserCell cell: CSPhotoBrowserCell, atIndexPath indexPath: NSIndexPath, withPhoto photo: CSPhoto) -> CSPhotoBrowserCell {
        return cell
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
    optional func photoBrowser(photoBrowser: CSPhotoBrowser, customizablePhotoBrowserCell cell: CSPhotoBrowserCell, atIndexPath indexPath: NSIndexPath, withPhoto photo: CSPhoto) -> CSPhotoBrowserCell
}

