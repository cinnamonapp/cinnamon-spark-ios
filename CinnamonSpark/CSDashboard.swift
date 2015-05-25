//
//  CSDashboard.swift
//  Cinnamon
//
//  Created by Alessio Santo on 14/05/15.
//  Copyright (c) 2015 Cinnamon. All rights reserved.
//

import UIKit

class CSDashboard: NSObject {
    var dailyCarbsLimit : Int!
    var dailyUsedCarbs : Int!
    var dailyRemainingCarbs : Int{
        get{
            return dailyCarbsLimit - dailyUsedCarbs
        }
    }
    var currentStatusAtTime : Int?
    
    var backgroundImageURL : NSURL!
    
    var lastMealRecord : CSPhoto?
    
    var user : CSUser?
    
    var smartAlertMessage : String?
    var currentStreak : [StreakDay]?
    
    convenience init(dictionary: NSDictionary){
        self.init()
        
        var dashboard : NSDictionary = dictionary
        
        if let d = dictionary["dashboard"] as? NSDictionary{
            dashboard = d
        }
        
        dailyCarbsLimit     = dashboard["daily_carbs_limit"]        as Int
        dailyUsedCarbs      = dashboard["daily_used_carbs"]         as Int
//        dailyRemainingCarbs = dashboard["daily_remaining_carbs"]    as Int
        
        if let currentStatusAtTimeInt = dashboard["current_status_at_time"] as? Int{
            currentStatusAtTime = currentStatusAtTimeInt
        }
        
        if let backgroundImageURLString = dashboard["background_image"] as? String{
            backgroundImageURL = NSURL(string: backgroundImageURLString)
        }
        
        if let lastMealRecordDictionary = dashboard["last_meal_record"] as? NSDictionary{
            lastMealRecord = CSPhoto(dictionary: lastMealRecordDictionary)
        }
        
        if let userDictionary = dashboard["user"] as? NSDictionary{
            user = CSUser(dictionary: userDictionary)
        }
        
        if let smartAlertMessageString = dashboard["smart_alert_message"] as? String{
            smartAlertMessage = smartAlertMessageString
        }
        
        if let currentStreakArray = dashboard["current_streak"] as? [NSDictionary]{
            // Each object of the streak should have the following:
            // date: YYYY-MM-DD
            // daily_used_carbs: Int
            // daily_carbs_limit: Int
            currentStreak = []
            for streakDay in currentStreakArray{
                currentStreak!.append(StreakDay(dictionary: streakDay))
            }
        }
    }

}


class StreakDay : NSObject{
    var date : NSDate!
    var dailyUsedCarbs : Int!
    var dailyCarbsLimit : Int!
    var mealRecordsCount : Int!
    
    convenience init(dictionary: NSDictionary){
        self.init()
        
        var streak : NSDictionary = dictionary
        
        if let s = dictionary["streak"] as? NSDictionary{
            streak = s
        }

        if let dailyCarbsLimitInt = streak["daily_carbs_limit"] as? Int{
            dailyCarbsLimit = dailyCarbsLimitInt
        }

        if let dailyUsedCarbsInt = streak["daily_used_carbs"] as? Int{
            dailyUsedCarbs = dailyUsedCarbsInt
        }

        if let mealRecordsCountInt = streak["meal_records_count"] as? Int{
            mealRecordsCount = mealRecordsCountInt
        }
    }
}