//
//  CSUser.swift
//  CinnamonSpark
//
//  Created by Alessio Santo on 10/04/15.
//  Copyright (c) 2015 Cinnamon. All rights reserved.
//

import UIKit

class CSUser: NSObject {
    var id : String!
    var username : String!
    
    // From smallest to biggest
    var nanoProfilePictureURL : NSURL!
    var microProfilePictureURL : NSURL!
    var profilePictureURL : NSURL!

    convenience init(dictionary: NSDictionary){
        self.init()
        
        self.id = (dictionary["id"] as Int).description
        self.username = dictionary["username"] as String
        
        self.nanoProfilePictureURL = NSURL(string: dictionary["profile_picture_nano_url"] as String)
        self.microProfilePictureURL = NSURL(string: dictionary["profile_picture_micro_url"] as String)
        self.profilePictureURL = NSURL(string: dictionary["profile_picture_thumbnail_url"] as String)
    }
}
