//
//  CSPhoto.swift
//  CinnamonSpark
//
//  Created by Alessio Santo on 03/04/15.
//  Copyright (c) 2015 Cinnamon. All rights reserved.
//

import UIKit

class CSPhoto: NSObject {
    var URL : NSURL!
    var title : String!
    var username : String!
    var profilePictureURL : NSURL!
    var createdAtDate : NSDate!
    
    convenience init(dictionary: NSDictionary){
        self.init()
        
        self.URL = NSURL(string: dictionary["photo_original_url"] as String)
        
        self.createdAtDate = self.dateFromString(dictionary["created_at"] as String)
        
        if let title = dictionary["title"] as? String{
            self.title = title
        }else{
            self.title = ""
        }
        
        if let user = dictionary["user"] as NSDictionary!{
            self.username = user["username"] as String
            
            self.profilePictureURL = NSURL(string: user["profile_picture_nano_url"] as String)
        }

    }
    
    private func dateFromString(string: String) -> NSDate{
        var count = countElements(string) - 5
        var dateString = (string as NSString).stringByReplacingCharactersInRange(NSMakeRange(count, 5), withString: "")
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        // Let's assume this is always GMT for now
        var date : NSDate = dateFormatter.dateFromString(dateString)!
        
        let systemZone = NSTimeZone.systemTimeZone()
        date = date.dateByAddingTimeInterval(NSTimeInterval(systemZone.secondsFromGMT))

        return date
    }
}