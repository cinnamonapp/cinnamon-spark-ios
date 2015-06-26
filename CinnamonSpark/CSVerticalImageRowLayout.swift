//
//  CSVerticalSocialLayout.swift
//  CinnamonSpark
//
//  Created by Alessio Santo on 02/04/15.
//  Copyright (c) 2015 Cinnamon. All rights reserved.
//

import UIKit

class CSVerticalImageRowLayout: UICollectionViewFlowLayout {
    
    override init(){
        super.init()
        let mainScreenBounds = UIScreen.mainScreen().bounds
        
        let itemWidth  : CGFloat = mainScreenBounds.width
        let rowHeight  : CGFloat = 30
        let itemHeight : CGFloat = itemWidth + rowHeight * 2
        
        self.itemSize = CGSizeMake(itemWidth, itemHeight)
        
        self.minimumInteritemSpacing = 1.0
        self.minimumLineSpacing = 0

        
//        self.estimatedItemSize = CGSizeMake(itemWidth - 100, itemHeight)
//        self.sectionInset = UIEdgeInsetsMake(20, 0, 20, 0)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes! {
        return super.layoutAttributesForItemAtIndexPath(indexPath)
    }
    
    override func layoutAttributesForSupplementaryViewOfKind(elementKind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes! {
        return super.layoutAttributesForSupplementaryViewOfKind(elementKind, atIndexPath: indexPath)
    }
    
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return !(CGSizeEqualToSize(newBounds.size, self.collectionView!.frame.size))
    }
}


private var cellSizesAssociationKey: UInt8 = 0
extension UICollectionView{
    
    // In the form of ["<section index>+<item index>" : "<width>,<height>"]
    private var cellSizes : NSMutableDictionary {
        get{
            var value: AnyObject! = objc_getAssociatedObject(self, &cellSizesAssociationKey)
            var defaultValue = NSMutableDictionary()
            
            if let v = value as? NSMutableDictionary{
                defaultValue = v
            }
            
            return defaultValue
        }
        
        set{
            objc_setAssociatedObject(self, &cellSizesAssociationKey, newValue, objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN))
        }
    }
    
    func retreiveStoredSizeForItemAtIndexPath(indexPath: NSIndexPath) -> CGSize? {
        var size : CGSize? = nil

        let key = "\(indexPath.section)+\(indexPath.item)"
        
        if let newsizeString = cellSizes[key] as? String{
            size = CGSize()
            
            let sizeArray = split(newsizeString){$0 == ","}
            let width = CGFloat((sizeArray[0] as NSString).floatValue)
            let height = CGFloat((sizeArray[1] as NSString).floatValue)
            
            size!.width = width
            size!.height = height
        }
        
        return size
    }
    
    func setStoredSize(size: CGSize, forItemAtIndexPath indexPath: NSIndexPath){
        let key = "\(indexPath.section)+\(indexPath.item)"
        let value = "\(size.width),\(size.height)"
        
        cellSizes.setObject(value, forKey: key)
    }
}

extension UICollectionViewCell{
    func computedSize() -> CGSize{
        return frame.size
    }
}