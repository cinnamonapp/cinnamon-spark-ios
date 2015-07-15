//
//  CSMealRecordLikeCell.swift
//  Cinnamon
//
//  Created by Alessio Santo on 30/06/15.
//  Copyright (c) 2015 Cinnamon. All rights reserved.
//

import UIKit

class CSMealRecordLikeCell: UITableViewCell {

    @IBOutlet var userProfilePicture: UIImageView!
    @IBOutlet var userProfileName: UILabel!
    
    func configure(){
        backgroundColor = UIColor.clearColor()
    }
    
    
    func configure(#like: CSLike){
        configure()
        
        userProfilePicture.sd_setImageWithURL(like.user.profilePictureURL)
        userProfileName.text = like.user.username
        
        if(userProfileName.text == ""){
            userProfileName.text = "Anonymous"
        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        userProfilePicture.layer.borderColor = UIColor.whiteColor().CGColor
        userProfilePicture.layer.borderWidth = 1
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
