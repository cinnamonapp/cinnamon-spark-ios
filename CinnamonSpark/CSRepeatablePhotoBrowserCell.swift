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
    @IBOutlet var titleAndHashtags: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.photo.frame.size.height = self.photo.frame.width
    }

    
    func setPhotoWithThumbURL(thumbURL: NSURL, originalURL: NSURL){
        // First load the thumb image
        let thumb = NSURL(string: originalURL.description.stringByReplacingOccurrencesOfString("original", withString: "thumbnail"))
        
        self.photo.sd_setImageWithURL(thumb, completed: { (image: UIImage!, error: NSError!, cache: SDImageCacheType, url: NSURL!) -> Void in
            
            // Then load the full image
            self.photo.sd_setImageWithURL(originalURL, placeholderImage: image)
        })
        
    }
    
    func setCarbsEstimateToValue(value: CSPhotoMealCarbsEstimate){
        let images = ["CarbsLow", "CarbsMedium", "CarbsHigh"]
        let image = UIImage(named: images[value.hashValue])
        
        self.carbsEstimate.image = image
    }

}
