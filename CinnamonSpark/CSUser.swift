//
//  CSUser.swift
//  CinnamonSpark
//
//  Created by Alessio Santo on 10/04/15.
//  Copyright (c) 2015 Cinnamon. All rights reserved.
//

import UIKit

class CSUser: CSModel {
    var id : String?
    var username : String!
    
    // From smallest to biggest
    var nanoProfilePictureURL : NSURL!
    var microProfilePictureURL : NSURL!
    var profilePictureURL : NSURL!

    var dailyCarbsLimit : Int!
    
    var mealRecordsCount : Int!
    
    
    override init(){
        super.init()
        
        username = ""
        mealRecordsCount = 0
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
        if let dailyCarbsLimitInt = user["daily_carbs_need"] as? Int{
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
        
        if let mealRecordsCountInt = user["meal_records_count"] as? Int{
            self.mealRecordsCount = mealRecordsCountInt
        }
        
    }
    
    override func toDictionary() -> NSDictionary! {
        var dictionary = NSMutableDictionary(dictionary: super.toDictionary())
        
        dictionary.addEntriesFromDictionary([
            "username": self.username!,
            "daily_carbs_need": self.dailyCarbsLimit,
            "meal_records_count": self.mealRecordsCount
        ])
        
        if let id = self.id{
            dictionary.addEntriesFromDictionary([
                "id": id
            ])
        }
        
        return dictionary
    }
    
}

private var _currentUser : CSUser?
private let cachedCurrentUserDictionaryKey = "cachedCurrentUserDictionary"
extension CSUser{
    class var currentUserMealRecordsCount : Int{
        get{
            if let cUser = currentUser(){
                return cUser.mealRecordsCount
            }else{
                return -1
            }
        }
        
        set{
            if let cUser = currentUser(){
                cUser.mealRecordsCount = newValue
                // Update currentUser
                CSUser.setCurrentUser(user: cUser)
            }
        }
    }
    
    class func currentUser() -> CSUser?{
        var result : CSUser?
        
        if let cUser = _currentUser{ }
        else
        if let cachedCurrentUserDictionary = NSUserDefaults.standardUserDefaults().dictionaryForKey(cachedCurrentUserDictionaryKey){
            let cachedUser = CSUser(dictionary: cachedCurrentUserDictionary)

            _currentUser = cachedUser
            
        }
        
        result = _currentUser
        
        return result
    }
    
    class func setCurrentUserOnce(#dictionary: NSDictionary){
        let user = CSUser(dictionary: dictionary)
        
        setCurrentUserOnce(user: user)
    }
    
    class func setCurrentUser(#dictionary: NSDictionary){
        let user = CSUser(dictionary: dictionary)
        
        setCurrentUser(user: user)
    }
    
    class func setCurrentUserOnce(#user: CSUser){
        if let current = currentUser(){}
        else{
            setCurrentUser(user: user)
        }
    }
    
    // For internal use only
    class func setCurrentUser(#user: CSUser){
        let computedUserDictionary = [
            "user": user.toDictionary()
        ]
        
        NSUserDefaults.standardUserDefaults().setObject(computedUserDictionary, forKey: cachedCurrentUserDictionaryKey)
        
        _currentUser = user
    }
//    private var _currentUser
}