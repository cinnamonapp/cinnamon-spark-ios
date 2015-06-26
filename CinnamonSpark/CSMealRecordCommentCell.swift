//
//  CSMealRecordCommentCell.swift
//  Cinnamon
//
//  Created by Alessio Santo on 19/06/15.
//  Copyright (c) 2015 Cinnamon. All rights reserved.
//

import UIKit

class CSMealRecordCommentCell: UITableViewCell {

    @IBOutlet var createdAtLabel: UILabel!
    @IBOutlet var userProfilePicture: UIImageView!
    @IBOutlet var userProfileName: UILabel!
    @IBOutlet var messageLabel: UILabel!
    
    func configure(){
        backgroundColor = UIColor.clearColor()
    }
    
    
    func configure(#comment: CSComment){
        configure()
        
        userProfilePicture.sd_setImageWithURL(comment.user.profilePictureURL)
        userProfileName.text = comment.user.username
        
        if(userProfileName.text == ""){
            userProfileName.text = "Anonymous"
        }
        
        messageLabel.text = comment.message
        createdAtLabel.text = comment.createdAt.shortTimeAgoSinceNow()
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
