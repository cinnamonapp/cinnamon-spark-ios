//
//  CSComment.swift
//  Cinnamon
//
//  Created by Alessio Santo on 22/06/15.
//  Copyright (c) 2015 Cinnamon. All rights reserved.
//

import Foundation

class CSComment : NSObject{
    // Properties
    var id          : String?
    
    var createdAt   : NSDate!
    var message     : String!
    var user        : CSUser!
    var mealRecord  : CSPhoto!
    
    override init() {
        super.init()
        
        createdAt   = NSDate()
        message     = ""
        user        = CSUser()
        mealRecord  = CSPhoto()
    }
    
    convenience init(dictionary: NSDictionary){
        self.init()
        
        if let idInt = dictionary["id"] as? Int{
            id = idInt.description
        }
        
        if let createdAtString = dictionary["created_at"] as? String{
            createdAt = dateFromString(createdAtString)
        }
        
        if let messageString = dictionary["message"] as? String{
            message = messageString
        }
        
        if let userDictionary = dictionary["user"] as? NSDictionary{
            user = CSUser(dictionary: userDictionary)
        }
        
        if let mealRecordDictionary = dictionary["meal_record"] as? NSDictionary{
            mealRecord = CSPhoto(dictionary: mealRecordDictionary)
        }
        
    }
    
    func toDictionary() -> NSDictionary{
        return [
            "message": message,
            "user_id": user.id!,
            "meal_record_id": mealRecord.id
        ]
    }
    
    // Experimental code
    func save(#success: ((AFHTTPRequestOperation!, AnyObject!) -> Void), failure: ((AFHTTPRequestOperation!, NSError!) -> Void)){
        if let id = self.id{
            // Update the comment
            println("Feature not implemented")
        }else{
            // Create a new comment
            CSAPIRequest().createCommentWithDictionary(self.toDictionary(), success: success, failure: failure)
        }
    }
    
    func save(){
        save(success: { (request: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
        
        }) { (request: AFHTTPRequestOperation!, error: NSError!) -> Void in
            
        }
    }
}


private func dateFromString(string: String) -> NSDate{
    var count = countElements(string) - 5
    var dateString = (string as NSString).stringByReplacingCharactersInRange(NSMakeRange(count, 5), withString: "")
    
    let dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
    
    // Let's assume this is always GMT for now
    var date : NSDate = dateFormatter.dateFromString(dateString)!
    
    //    let systemZone = NSTimeZone.systemTimeZone()
    //    date = date.dateByAddingTimeInterval(NSTimeInterval(systemZone.secondsFromGMT))
    
    return date
}
