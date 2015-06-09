//
//  CSRefreshableCollectionViewController.swift
//  Cinnamon
//
//  Created by Alessio Santo on 09/06/15.
//  Copyright (c) 2015 Cinnamon. All rights reserved.
//

import UIKit

class CSRefreshableCollectionViewController: UICollectionViewController, UIScrollViewDelegate {

    var refreshControl: UIRefreshControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Do any additional setup after loading the view.
        refreshControl = UIRefreshControl()
        self.refreshControl.addTarget(self, action: "refreshData", forControlEvents: UIControlEvents.ValueChanged)
        self.collectionView?.addSubview(refreshControl)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func refreshData(){
        self.refreshDataWithRefreshControl(self.refreshControl)
    }
    
    func refreshDataWithRefreshControl(refreshControlOrNil: UIRefreshControl?){
        // Do your stuff here
    }
    
    override init(){
        super.init()
    }

    override init(collectionViewLayout layout: UICollectionViewLayout!) {
        super.init(collectionViewLayout: layout)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}





private var isAlreadyFetchingAssociationKey: UInt8 = 0
private var pageIndexAssociationKey: UInt8 = 0
extension CSRefreshableCollectionViewController{
    private var isAlreadyFetching : Bool {
        get{
            var value: AnyObject! = objc_getAssociatedObject(self, &isAlreadyFetchingAssociationKey)
            var boolValue = false
            
            if let v = value as? Bool{
                boolValue = v
            }
            
            return boolValue
        }
        
        set{
            objc_setAssociatedObject(self, &isAlreadyFetchingAssociationKey, newValue, objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN))
        }
    }
    
    private var pageIndex : Int {
        get{
            var value: AnyObject! = objc_getAssociatedObject(self, &pageIndexAssociationKey)
            var intValue = 1
            
            if let v = value as? Int{
                intValue = v
            }
            
            return intValue
        }
        
        set{
            objc_setAssociatedObject(self, &pageIndexAssociationKey, newValue, objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN))
        }
    }
    
    // Allows the controller to know that now he can fetch another page
    func endPageFetching(){
        self.isAlreadyFetching = false
    }
    
    // This is only called when new pages are available
    func fetchPageWithIndex(index: Int){
        // Do your stuff here using index
    }
    
    // Method called to determine if there are some pages still left
    func shouldContinueToFetchPages() -> Bool{
        return true
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        
        let collectionView = self.collectionView!
        
        let didScrollToBottom = (collectionView.contentOffset.y > (collectionView.contentSize.height - collectionView.bounds.size.height))
        
        if (didScrollToBottom && !isAlreadyFetching){
            println("scrolling")
            if(shouldContinueToFetchPages()){
                println("scrolling best")
                self.isAlreadyFetching = true
                
                self.pageIndex++
                self.fetchPageWithIndex(self.pageIndex)
            }
            
        }
        
    }

}





extension UICollectionViewController{
    func refreshControlEndRefreshing(){
        if let selfRefreshable = self as? CSRefreshableCollectionViewController{
            selfRefreshable.refreshControl.endRefreshing()
        }else{
            println("Tried to end refreshing but controller is not type of 'CSRefreshableCollectionViewController'.")
        }
    }
}