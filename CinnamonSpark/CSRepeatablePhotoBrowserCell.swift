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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    func setPhotoWithThumbURL(thumbURL: NSURL, originalURL: NSURL){
        // First load the thumb image
        self.photo.sd_setImageWithURL(thumbURL, completed: { (image: UIImage!, error: NSError!, cache: SDImageCacheType, url: NSURL!) -> Void in
            // Then load the full image
            self.photo.sd_setImageWithURL(originalURL, placeholderImage: image)
        })
        
    }

}
