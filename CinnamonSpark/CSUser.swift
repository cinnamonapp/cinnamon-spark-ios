//
//  CSUser.swift
//  CinnamonSpark
//
//  Created by Alessio Santo on 10/04/15.
//  Copyright (c) 2015 Cinnamon. All rights reserved.
//

import UIKit

class CSUser: NSObject {
    var id : String?
    var username : String!
    
    // From smallest to biggest
    var nanoProfilePictureURL : NSURL!
    var microProfilePictureURL : NSURL!
    var profilePictureURL : NSURL!

    var dailyCarbsLimit : Int!
    
    
    
    override init(){
        super.init()
        
        username = ""
    }
    
    convenience init(dictionary: NSDictionary){
        self.init()

        var user : NSDictionary = dictionary
        
        if let u = dictionary["user"] as? NSDictionary{
            user = u
        }
        
        if let idString = user["id"] as? String{
            id = idString
        }else if let idInt = user["id"] as? Int{
            id = idInt.description
        }
        
        if let usernameString = user["username"] as? String{
            username = usernameString
        }

        if let dailyCarbsLimitInt = user["daily_carbs_limit"] as? Int{
            self.dailyCarbsLimit = dailyCarbsLimitInt
        }
        
        if let profilePictureNanoUrlString = user["profile_picture_nano_url"] as? String{
            self.nanoProfilePictureURL = NSURL(string: profilePictureNanoUrlString)
        }
        
        if let microProfilePictureUrlString = user["profile_picture_micro_url"] as? String{
            self.microProfilePictureURL = NSURL(string: microProfilePictureUrlString)
        }
        
        if let profilePictureUrlString = user["profile_picture_thumbnail_url"] as? String{
            self.profilePictureURL = NSURL(string: profilePictureUrlString)
        }
        
    }
    
}

private var _currentUser : CSUser?
private let cachedCurrentUserDictionaryKey = "cachedCurrentUserDictionary"
extension CSUser{
    class func currentUser() -> CSUser?{
        if let cachedCurrentUserDictionary = NSUserDefaults.standardUserDefaults().dictionaryForKey(cachedCurrentUserDictionaryKey){
            let cachedUser = CSUser(dictionary: cachedCurrentUserDictionary)

            return cachedUser
        }
        
        return _currentUser
    }
    
    class func setCurrentUserOnce(#dictionary: NSDictionary){
        let user = CSUser(dictionary: dictionary)
        
        setCurrentUserOnce(user: user)
    }
    
    class func setCurrentUserOnce(#user: CSUser){
        if let current = currentUser(){}
        else{
            let computedUserDictionary = [
                "user": [
                    "id": user.id!,
                    "username": user.username!,
                    "daily_carbs_limit": user.dailyCarbsLimit
                ]
            ]
            
            NSUserDefaults.standardUserDefaults().setObject(computedUserDictionary, forKey: cachedCurrentUserDictionaryKey)
            
            _currentUser = user
        }
    }
//    private var _currentUser
}