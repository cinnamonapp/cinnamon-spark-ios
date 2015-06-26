//
//  CSCommunityViewLayout.swift
//  CinnamonSpark
//
//  Created by Alessio Santo on 02/04/15.
//  Copyright (c) 2015 Cinnamon. All rights reserved.
//

import UIKit

let CSCommunityViewActionsDecorationViewKind = "mealRecordActionsCell"
class CSCommunityViewLayout: CSVerticalImageRowLayout {
    
    var elementsAttributes : [UICollectionViewLayoutAttributes]!
    
    override init(){
        super.init()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareLayout() {
        super.prepareLayout()
        
//        self.registerNib(UINib(nibName: "CSMealRecordActionsCell", bundle: nil), forDecorationViewOfKind: CSCommunityViewActionsDecorationViewKind)
        
        elementsAttributes = []
        
        let sectionsCount = self.collectionView?.numberOfSections()
        
        for(var sectionIndex = 0; sectionIndex < sectionsCount; sectionIndex++){
            let itemsCount = self.collectionView?.numberOfItemsInSection(sectionIndex)
            
            for(var itemIndex = 0; itemIndex < itemsCount; itemIndex++){
                let indexPath = NSIndexPath(forItem: itemIndex, inSection: sectionIndex)
                let itemAttributes = self.layoutAttributesForItemAtIndexPath(indexPath)
                
                // Add a header before the item
                // TODO: - Transform this into the decoration view for the ring indicator
                if(itemIndex == 0){
                    let headerViewAttributes = self.layoutAttributesForSupplementaryViewOfKind(UICollectionElementKindSectionHeader, atIndexPath: indexPath)
                    if(headerViewAttributes !== nil){
                        elementsAttributes.append(headerViewAttributes)
                    }
                }
                
                elementsAttributes.append(itemAttributes)
                
                // If it's the last item of the section
                // Add a decoration action view
//                let actionsViewAttributes = self.layoutAttributesForDecorationViewOfKind(CSCommunityViewActionsDecorationViewKind, atIndexPath: indexPath)
//                
//                if(actionsViewAttributes !== nil){
//                    elementsAttributes.append(actionsViewAttributes)
//                }

            
            
                let actionsViewAttributes = self.layoutAttributesForSupplementaryViewOfKind(CSCommunityViewActionsDecorationViewKind, atIndexPath: indexPath)
                
                if(actionsViewAttributes !== nil){
                    elementsAttributes.append(actionsViewAttributes)
                }

            }
        }
        
    }
    
    
    override func layoutAttributesForDecorationViewOfKind(elementKind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes! {
        var attributes = super.layoutAttributesForDecorationViewOfKind(elementKind, atIndexPath: indexPath)
        
        
        return attributes
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [AnyObject]? {
        
        var elementsattributes = elementsAttributes
        var finalAttributes : [UICollectionViewLayoutAttributes]! = []
        
        for elementattributes in elementsattributes{
            if(CGRectIntersectsRect(elementattributes.frame, rect)){
                finalAttributes.append(elementattributes)
            }
        }
        
        return finalAttributes
    }
    
    
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes! {
        return super.layoutAttributesForItemAtIndexPath(indexPath)
    }
    
    override func layoutAttributesForSupplementaryViewOfKind(elementKind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes! {
        var attributes = super.layoutAttributesForSupplementaryViewOfKind(elementKind, atIndexPath: indexPath)
        
        if(elementKind == CSCommunityViewActionsDecorationViewKind){
            if(attributes == nil){
                // Create new attributes
                attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: CSCommunityViewActionsDecorationViewKind, withIndexPath: indexPath)
            }
            
            if let itemAttributes = self.layoutAttributesForItemAtIndexPath(indexPath){
                attributes.frame = itemAttributes.frame
                attributes.frame.origin.y = CGRectGetMaxY(itemAttributes.frame)
            }
            
            attributes.frame.size.height = 50

            attributes.frame.size.width = collectionViewContentSize().width
            attributes.frame.origin.y -= attributes.frame.size.height
            
            attributes.zIndex = 10
            
        }
        
        return attributes
    }
    
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return !(CGSizeEqualToSize(newBounds.size, self.collectionView!.frame.size))
    }
    
}