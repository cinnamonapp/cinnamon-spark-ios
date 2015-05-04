//
//  CSRepeatablePhotoBrowserCell.swift
//  Cinnamon
//
//  Created by Alessio Santo on 20/04/15.
//  Copyright (c) 2015 Cinnamon. All rights reserved.
//

import UIKit

class CSRepeatablePhotoBrowserCell: UICollectionViewCell {

    @IBOutlet var timeAgoLabel: UILabel!
    @IBOutlet var photo: UIImageView!
    @IBOutlet var userProfilePicture: UIImageView!
    @IBOutlet var userProfileName: UILabel!
    @IBOutlet var carbsEstimate: UIImageView!
    @IBOutlet var carbsEstimateGrams: UILabel!
    @IBOutlet var titleAndHashtags: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        self.photo.frame.size.height = self.photo.frame.width
        
        // Disable user interaction on carbs grams label
        self.carbsEstimateGrams?.userInteractionEnabled = false
        
        self.carbsEstimate?.hidden = true
        
        let gesture = UITapGestureRecognizer(target: self, action: "toggleCarbsEstimateGramsVisibility")
        self.carbsEstimate?.userInteractionEnabled = true
        self.carbsEstimate?.addGestureRecognizer(gesture)
        
        
        
        let cellWidth = (UIScreen.mainScreen().bounds.width);
        self.photo.addConstraint(NSLayoutConstraint(item: self.photo, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.LessThanOrEqual, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: cellWidth))
//        self.titleAndHashtags.addConstraint(NSLayoutConstraint(item: self.titleAndHashtags, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: cellWidth - 10))
        
    }

    
    func setPhotoWithThumbURL(thumbURL: NSURL, originalURL: NSURL){
        // First load the thumb image
        let thumb = NSURL(string: originalURL.description.stringByReplacingOccurrencesOfString("original", withString: "thumbnail"))
        
        self.photo.sd_setImageWithURL(thumb, completed: { (image: UIImage!, error: NSError!, cache: SDImageCacheType, url: NSURL!) -> Void in
            
            // Then load the full image
            self.photo.sd_setImageWithURL(originalURL, placeholderImage: image)
        })
        
    }
    
    func toggleCarbsEstimateGramsVisibility(){
        self.carbsEstimateGrams.hidden = !self.carbsEstimateGrams.hidden
    }
    
    func setCarbsEstimateToValue(value: CSPhotoMealCarbsEstimate){
        let images = ["CarbsLow", "CarbsMedium", "CarbsHigh"]
        let image = UIImage(named: images[value.hashValue])
        
        self.carbsEstimate.image = image
        
        self.showCarbsEstimate()
    }
    
    func setCarbsEstimateToValue(value: CSPhotoMealCarbsEstimate, grams: Int?){
        self.setCarbsEstimateToValue(value)
        
        if let g = grams{
            self.carbsEstimateGrams.text = "\(g)g"
        }else{
            self.carbsEstimateGrams.text = ""
        }
    }
    
    func showCarbsEstimate(){
        self.carbsEstimate?.hidden = false
        self.carbsEstimateGrams?.hidden = true
    }
    func hideCarbsEstimate(){
        self.carbsEstimate?.hidden = true
        self.carbsEstimateGrams?.hidden = true
    }
}
