//
//  CSLike.swift
//  Cinnamon
//
//  Created by Alessio Santo on 23/06/15.
//  Copyright (c) 2015 Cinnamon. All rights reserved.
//

import Foundation

class CSLike: NSObject {
    
    // Properties
    var id : String?
    var user : CSUser!
    var mealRecord : CSPhoto!
    
    override init(){
        super.init()
        
        user = CSUser()
        mealRecord = CSPhoto()
    }
    
    convenience init(dictionary: NSDictionary){
        self.init()
        
        if let idInt = dictionary["id"] as? Int{
            id = idInt.description
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
            "user_id": user.id!,
            "meal_record_id": mealRecord.id
        ]
    }
    
    // Experimental code
    func save(#success: ((AFHTTPRequestOperation!, AnyObject!) -> Void), failure: ((AFHTTPRequestOperation!, NSError!) -> Void)){
        if let id = self.id{
            // Update like
            println("Feature not implemented")
        }else{
            // Create a new like
            CSAPIRequest().createLikeWithDictionary(self.toDictionary(), success: success, failure: failure)
        }
    }
    
    func save(){
        save(success: { (request: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            
        }) { (request: AFHTTPRequestOperation!, error: NSError!) -> Void in
                
        }
    }
}
