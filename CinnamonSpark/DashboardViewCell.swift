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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        ringDisplayView?.progress = 0
        carbsIndicatorView?.text = "150g"
        carbsIndicatorSupportTextView?.text = "left"
        lastMealRecordView.contentMode = UIViewContentMode.Center
        
        setLastMealRecord(nil)
    }

    
    func setLastMealRecord(mealRecordOrNil: CSPhoto?){
        if let mealRecord = mealRecordOrNil{
            lastMealRecordView.hidden = false
            lastMealRecordCarbsContainerView.hidden = false
            
            lastMealRecordView.sd_setImageWithURL(mealRecord.URL, completed: { (image: UIImage!, error: NSError!, cache: SDImageCacheType, url: NSURL!) -> Void in
                var newSize = self.lastMealRecordView.bounds.size
                
                if(mealRecord.size == CSPhotoMealSize.Small){
                    newSize.height *= 2.7
                    newSize.width *= 2.7
                }
                
                if(mealRecord.size == CSPhotoMealSize.Medium){
                    newSize.height *= 1.7
                    newSize.width *= 1.7
                }
                
                if(mealRecord.size == CSPhotoMealSize.Large){
                    newSize.height *= 1.2
                    newSize.width *= 1.2
                }
                
                let newImage = image.imageScaledToSize(newSize)
                
                self.lastMealRecordView.image = newImage
            })
            
            
            
            
            if let carbsEstimateGrams = mealRecord.carbsEstimateGrams{
                lastMealRecordCarbsIndicatorView.text = "\(carbsEstimateGrams)"
            }else{
                lastMealRecordCarbsIndicatorView.text = "?"
            }

            
        }else{
            lastMealRecordView.hidden = true
            lastMealRecordCarbsContainerView.hidden = true
        }
    }
}
