//
//  CSMeal.swift
//  Cinnamon
//
//  Created by Alessio Santo on 03/06/15.
//  Copyright (c) 2015 Cinnamon. All rights reserved.
//

import UIKit

class CSMeal: NSObject {
    // Properties
    var createdAt : NSDate!
    var mealRecords : [CSPhoto]!
    var user : CSUser!
    var carbsEstimateGrams : Int!
    var status : Int!
    
    // Computed
    var dailyCarbsNeed : Int{
        get{
            return self.user.dailyCarbsLimit
        }
    }

    override init(){
        super.init()
        
        createdAt = NSDate()
        mealRecords = []
        status = 0
        carbsEstimateGrams = 0
    }
    
    convenience init(dictionary: NSDictionary){
        self.init()
        
        
        if let createdAtString = dictionary["created_at"] as? String{
            createdAt = dateFromString(createdAtString)
        }
        
        if let statusInt = dictionary["status"] as? Int{
            status = statusInt
        }
        
        if let carbsEstimateGramsInt = dictionary["carbs_estimate_grams"] as? Int{
            carbsEstimateGrams = carbsEstimateGramsInt
        }
        
        if let mealRecordsDictionaryArray = dictionary["meal_records"] as? [NSDictionary]{
            for mealRecordDictionary in mealRecordsDictionaryArray{
                mealRecords.append(CSPhoto(dictionary: mealRecordDictionary))
            }
        }
        
        if let userDictionary = dictionary["user"] as? NSDictionary{
            user = CSUser(dictionary: userDictionary)
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
