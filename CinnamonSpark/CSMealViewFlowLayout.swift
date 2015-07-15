//
//  CSMealViewFlowLayout.swift
//  Cinnamon
//
//  Created by Alessio Santo on 03/06/15.
//  Copyright (c) 2015 Cinnamon. All rights reserved.
//

import UIKit

let CSMealViewElementKindSectionRing = "CSMealViewElementKindDecorationRing"

class CSMealViewFlowLayout: UICollectionViewFlowLayout {
    
    var elementsAttributes : [UICollectionViewLayoutAttributes]!
    
    override func prepareLayout() {
        super.prepareLayout()
        
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
                    let headerView = self.layoutAttributesForSupplementaryViewOfKind(UICollectionElementKindSectionHeader, atIndexPath: indexPath)
                    elementsAttributes.append(headerView)
                }
                
                elementsAttributes.append(itemAttributes)
                
                // If it's the last item of the section
                // Add a decoration ring view
                if(itemIndex == itemsCount! - 1){
                    let decorationRingView = self.layoutAttributesForSupplementaryViewOfKind(CSMealViewElementKindSectionRing, atIndexPath: indexPath)
                    elementsAttributes.append(decorationRingView)
                }
            }
        }
        
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
    
    
    override func layoutAttributesForSupplementaryViewOfKind(elementKind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes! {
        var attributes = super.layoutAttributesForSupplementaryViewOfKind(elementKind, atIndexPath: indexPath)
        
        if(elementKind == CSMealViewElementKindSectionRing){
            let firstItemAttributeOfSection = self.layoutAttributesForItemAtIndexPath(NSIndexPath(forItem: 0, inSection: indexPath.section))
            
            attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: CSMealViewElementKindSectionRing, withIndexPath: indexPath)
            
            attributes.frame = CGRectMake(0, 0, 60, 60)
            
            if let collectionView = self.collectionView{
                let spaceNeededToCenterVertically = (firstItemAttributeOfSection.frame.height - attributes.frame.height) / 2
                attributes.frame.origin = CGPointMake(CGRectGetMaxX(collectionView.bounds) - attributes.frame.width - 5, firstItemAttributeOfSection.frame.origin.y + spaceNeededToCenterVertically)
            }
            
        }
        
        if(elementKind == UICollectionElementKindSectionHeader){
            let firstItemOfSection = self.layoutAttributesForItemAtIndexPath(NSIndexPath(forItem: 0, inSection: indexPath.section))
            attributes.frame.origin.y = CGRectGetMinY(firstItemOfSection.frame) - attributes.frame.height
        }
        
        return attributes
    }

    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes! {
        
        // Calculate the available space
        var availableSpace = UIScreen.mainScreen().bounds.width
        
        if let collectionView = self.collectionView{
            availableSpace = collectionView.bounds.width
            
            // If the delegate method is present, use it
            if let delegate = collectionView.delegate as? CSMealViewDelegateFlowLayout{
                if(delegate.respondsToSelector("collectionView:layout:availableWidthSpaceForItemAtIndexPath:")){
                    availableSpace = delegate.collectionView!(collectionView, layout: self, availableWidthSpaceForItemAtIndexPath: indexPath)
                }
            }
        }
        
        // TODO: - Subtract the edgeInsets from the available space
        var edgeInsetsForSection = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        if let collectionView = self.collectionView{
            if let delegate = collectionView.delegate as? UICollectionViewDelegateFlowLayout{
                edgeInsetsForSection = delegate.collectionView!(collectionView, layout: self, insetForSectionAtIndex: indexPath.section)
            }
        }
        
        availableSpace -= edgeInsetsForSection.left * 2 + edgeInsetsForSection.right
        
//        println(availableSpace)
        
        // Get current collection view's situation
        let itemsInSection = self.collectionView?.numberOfItemsInSection(indexPath.section)
        let stepInSection  = availableSpace / CGFloat(itemsInSection!)
        
        // Prepare attributes for the wanted object
        var attributes = super.layoutAttributesForItemAtIndexPath(indexPath)
        
        attributes.zIndex = indexPath.item
        
        // TODO: - Start with the left edgeInset
        attributes.frame.origin.x = edgeInsetsForSection.left
        
        // If it's the first item of every section (except the first one)
        if(indexPath.section > 0 && indexPath.item == 0){
            let previousSectionFirstItemAttributes = self.layoutAttributesForItemAtIndexPath(NSIndexPath(forItem: 0, inSection: indexPath.section - 1))
            let previousSectionFirstItemMaxY = CGRectGetMaxY(previousSectionFirstItemAttributes.frame)
            let sectionHeader = super.layoutAttributesForSupplementaryViewOfKind(UICollectionElementKindSectionHeader, atIndexPath: indexPath)
            
            attributes.frame.origin.y = previousSectionFirstItemMaxY + sectionHeader.frame.height
        }
        
        // If it's an item greater than 0
        if(indexPath.item > 0){
            let firstItemOfSectionAttributes = self.layoutAttributesForItemAtIndexPath(NSIndexPath(forItem: 0, inSection: indexPath.section))
            let firstItemOfSectionMinY = CGRectGetMinY(firstItemOfSectionAttributes.frame)
            let spaceNeededToCenterVertically = (firstItemOfSectionAttributes.frame.height - attributes.frame.height) / 2
            
            // Get the previous item
            var previousItemAttributes = self.layoutAttributesForItemAtIndexPath(NSIndexPath(forItem: indexPath.item - 1, inSection: indexPath.section))
            let previousItemMaxX = CGRectGetMaxX(previousItemAttributes.frame)
            
            attributes.frame.origin.x += CGFloat(indexPath.item) * stepInSection //CGRectGetMaxX(previousItemAttributes.frame)// - 100
            attributes.frame.origin.y = firstItemOfSectionMinY + spaceNeededToCenterVertically
            
            if(attributes.frame.origin.x >= previousItemMaxX){
                attributes.frame.origin.x = previousItemMaxX - attributes.frame.width * 0.3
            }
            
        }
        
        return attributes
    }
    
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return !(CGSizeEqualToSize(newBounds.size, self.collectionView!.frame.size))
    }

    override func collectionViewContentSize() -> CGSize {
        var newSize = super.collectionViewContentSize()
        
        if let lastItemAttributes = elementsAttributes.last{
            newSize.height = CGRectGetMaxY(lastItemAttributes.frame) + 150.0
        }
        
        return newSize
    }
}

@objc
protocol CSMealViewDelegateFlowLayout : UICollectionViewDelegateFlowLayout{
    optional func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, availableWidthSpaceForItemAtIndexPath indexPath: NSIndexPath) -> CGFloat
}

class CSMealViewHeaderView: UICollectionReusableView{
    
    var dateLabel : UILabel!
    
    override init() {
        super.init()
        configure()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    func configure(){
        dateLabel = UILabel(frame: bounds)
        
        self.addSubview(dateLabel)
        self.prepareForReuse()
    }
//    
    override func layoutSubviews() {
        dateLabel.frame = bounds
    }
//
    override func prepareForReuse() {
        super.prepareForReuse()
        
        dateLabel.textAlignment = NSTextAlignment.Center
        dateLabel.font = DefaultFont
        dateLabel.textColor = ColorPalette.DefaultTextColor
        dateLabel.text = "Today"
    }
    
}


class CSMealViewDishCell: UICollectionViewCell{
    var imageView : CircleImageView!

    override init() {
        super.init()
        configure()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    func configure(){
        imageView = CircleImageView(frame: bounds)
        imageView.borderWidth = 5
        imageView.contentMode = UIViewContentMode.Center
        self.addSubview(imageView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = bounds
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    func setImageViewImageWithMealRecord(mealRecord: CSPhoto){
        let URL     = mealRecord.photoURL(.Medium)
        let size    = CSPhotoMealSize.Large //mealRecord.size
        
        imageView.sd_setImageWithURL(URL, completed: { (image: UIImage!, error: NSError!, cache: SDImageCacheType, url: NSURL!) -> Void in
            if(image !== nil){
                self.imageView.image = self.scaleImageWithImage(image, withMealSize: size)
            }else{
                println("Error setting image of a meal record's cell of the meal view (image = nil)")
            }
        })
        
        self.setNeedsLayout()
    }
    
    func sizeForMealSize(size: CSPhotoMealSize) -> CGSize{
        var newSize = imageView.bounds.size
        
        if(size == CSPhotoMealSize.ExtraSmall){
            newSize.height *= 2.7
            newSize.width *= 2.7
        }
        
        if(size == CSPhotoMealSize.Small){
            newSize.height *= 2
            newSize.width *= 2
        }
        
        if(size == CSPhotoMealSize.Medium){
            newSize.height *= 1.5
            newSize.width *= 1.5
        }
        
        if(size == CSPhotoMealSize.Large){
            newSize.height *= 1.2
            newSize.width *= 1.2
        }
        
        return newSize
    }
    
    func scaleImageWithImage(image: UIImage, withMealSize size: CSPhotoMealSize) -> UIImage{
        let newImage = image.imageScaledToSize(self.sizeForMealSize(size))
        
        return newImage
    }
    
}



class CSIndicatorRingReusableView: UICollectionReusableView{
    var ringView : IndicatorRingView!
    
    override init() {
        super.init()
        configure()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    func configure(){
        ringView = IndicatorRingView(frame: bounds)
        self.addSubview(ringView)

        self.prepareForReuse()
    }
    
    override func layoutSubviews() {
        ringView.frame = bounds
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        ringView.font = DefaultFont!
        ringView.fillColor = ColorPalette.WithinColor
        ringView.progress = 0
        ringView.textColor = ColorPalette.DefaultTextColor
        ringView.text = "0"
    }
    
    
    func setRingProgress(progress: CGFloat, withColor color: UIColor){
        ringView.progress = progress
        ringView.fillColor = color
    }
    
    func setRingProgress(progress: CGFloat, withStatus statusOrNil: Int?){
        var color = ColorPalette.WithinColor
        
        if let status = statusOrNil{
            // Below
            if(status < 0){
                color = ColorPalette.BelowColor
            }
                // Within
            else if(status == 0){
                color = ColorPalette.WithinColor
            }
                // Above
            else{
                color = ColorPalette.AboveColor
            }
        }
        
        self.setRingProgress(progress, withColor: color)
        
    }

}