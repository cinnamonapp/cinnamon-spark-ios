//
//  DashboardViewCell.swift
//  Cinnamon
//
//  Created by Alessio Santo on 13/05/15.
//  Copyright (c) 2015 Cinnamon. All rights reserved.
//

import UIKit

class DashboardViewCell: UICollectionViewCell {
    
    @IBOutlet var backgroundImage: UIImageView!

    @IBOutlet var ringDisplayView: RingView!
    @IBOutlet var lastMealRecordView: CircleImageView!
    @IBOutlet var lastMealRecordCarbsContainerView: UIView!
    @IBOutlet var lastMealRecordCarbsIndicatorView: UILabel!
    @IBOutlet var carbsIndicatorView: UILabel!
    @IBOutlet var carbsIndicatorSupportTextView: UILabel!
    @IBOutlet var messageView: UILabel!
    @IBOutlet var streakDotsView: DotsScrollView!
    
    var ringDisplayViewTapGesture : UITapGestureRecognizer{
        get{
            return _ringDisplayViewTapGesture
        }
    }
    let _ringDisplayViewTapGesture = UITapGestureRecognizer()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        ringDisplayView?.progress = 0
        carbsIndicatorView?.text = "200g"
        carbsIndicatorSupportTextView?.text = "left"
        lastMealRecordView.contentMode = UIViewContentMode.Center
        
        ringDisplayView.addGestureRecognizer(ringDisplayViewTapGesture)
        
        setLastMealRecord(nil)
    }

    
    func setLastMealRecord(mealRecordOrNil: CSPhoto?){
        if let mealRecord = mealRecordOrNil{
            lastMealRecordView.hidden = false
            lastMealRecordCarbsContainerView.hidden = false
            
            self.setPhotoWithThumbURL(mealRecord.photoURL(CSPhotoPhotoStyle.Thumbnail), originalURL: mealRecord.photoURL(CSPhotoPhotoStyle.Large), andMealSize: mealRecord.size)
            
            if let carbsEstimateGrams = mealRecord.carbsEstimateGrams{
                lastMealRecordCarbsIndicatorView.text = "\(carbsEstimateGrams)"
            }else{
                lastMealRecordCarbsIndicatorView.text = "?"
            }

            
        }else{
            lastMealRecordView.hidden = true
            lastMealRecordCarbsContainerView.hidden = true
        }
        
        
        // Force hide the carbs number
        lastMealRecordCarbsContainerView.hidden = true
    }
    
    
    func setPhotoWithThumbURL(thumbURL: NSURL, originalURL: NSURL, andMealSize size: CSPhotoMealSize) {
        // First load the thumb image
        
        self.lastMealRecordView.sd_setImageWithURL(thumbURL, completed: { (image: UIImage!, error: NSError!, cache: SDImageCacheType, url: NSURL!) -> Void in
            
            self.lastMealRecordView.image = self.scaleImageWithImage(image, withMealSize: size)
            
//            // Then load the full image
            self.lastMealRecordView.sd_setImageWithURL(originalURL, placeholderImage: self.lastMealRecordView.image, completed: { (originalImage: UIImage!, error: NSError!, cache: SDImageCacheType, url: NSURL!) -> Void in
                let scaledImage = self.scaleImageWithImage(originalImage, withMealSize: size)
                self.lastMealRecordView.image = scaledImage
            })
        })
        
    }
    
    func sizeForMealSize(size: CSPhotoMealSize) -> CGSize{
        var newSize = self.lastMealRecordView.bounds.size
        
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

    
    
    
    func setRingProgress(progress: CGFloat, withColor color: UIColor){
        ringDisplayView.progress = progress
        ringDisplayView.fillColor = color
    }
    
    func setRingProgress(progress: CGFloat, withStatus statusOrNil: Int?){
        var color = UIColor()
        
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
    
    func setStreak(streak: [StreakDay]){
        var colors : [UIColor] = []
        for streakDay in streak{
            var color : UIColor = UIColor.clearColor()
            if(streakDay.mealRecordsCount > 0){
                // Above
                if(streakDay.dailyUsedCarbs > streakDay.dailyCarbsLimit){
                    color = ColorPalette.AboveColor
                }
                // Below
                else if(streakDay.dailyUsedCarbs < streakDay.dailyCarbsLimit - 50){
                    color = ColorPalette.BelowColor
                }
                // Within
                else{
                    color = ColorPalette.WithinColor
                }
            }
            
            colors.append(color)
        }
        
        streakDotsView.colorDotsWithColors(colors)
    }
}
