//
//  CSMealRecordDetailCell.swift
//  Cinnamon
//
//  Created by Alessio Santo on 22/05/15.
//  Copyright (c) 2015 Cinnamon. All rights reserved.
//

import UIKit

class CSMealRecordDetailCell: CSRepeatablePhotoBrowserCell {

    @IBOutlet var indicatorRing: IndicatorRingView!
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    override func awakeFromNib() {
        super.awakeFromNib()
        photo.contentMode = .Center
    }
    
    override func setCarbsEstimateToValue(value: CSPhotoMealCarbsEstimate, grams: Int?) {
        super.setCarbsEstimateToValue(value, grams: grams)
        
        if(value == CSPhotoMealCarbsEstimate.Low){
            indicatorRing.fillColor = ColorPalette.BelowColor
        }
        if(value == CSPhotoMealCarbsEstimate.Medium){
            indicatorRing.fillColor = ColorPalette.WithinColor
        }
        if(value == CSPhotoMealCarbsEstimate.High){
            indicatorRing.fillColor = ColorPalette.AboveColor
        }
        
        if let g = grams{
            indicatorRing.text = "\(g)g"
        }
    }
    
    func setPhotoWithThumbURL(thumbURL: NSURL, originalURL: NSURL, andMealSize size: CSPhotoMealSize) {
        // First load the thumb image
        
        self.photo.sd_setImageWithURL(thumbURL, completed: { (image: UIImage!, error: NSError!, cache: SDImageCacheType, url: NSURL!) -> Void in
            
            if(image !== nil){
                self.photo.image = self.scaleImageWithImage(image, withMealSize: size)
            }
            
            // Then load the full image
            self.photo.sd_setImageWithURL(originalURL, placeholderImage: self.photo.image, completed: { (originalImage: UIImage!, error: NSError!, cache: SDImageCacheType, url: NSURL!) -> Void in
                
                if(originalImage !== nil){
                    self.photo.image = self.scaleImageWithImage(originalImage, withMealSize: size)
                }
            })
        })
        
    }
    
    
    func scaleImageWithImage(image: UIImage, withMealSize size: CSPhotoMealSize) -> UIImage{
        var newSize = self.photo.bounds.size
        
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
        
        let newImage = image.imageScaledToSize(newSize)
        
        return newImage
    }

}
