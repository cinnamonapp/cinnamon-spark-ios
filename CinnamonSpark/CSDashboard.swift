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
    var dailyRemainingCarbs : Int!
    
    var backgroundImageURL : NSURL!
    
    var lastMealRecord : CSPhoto?
    
    var user : CSUser?
    
    convenience init(dictionary: NSDictionary){
        self.init()
        
        var dashboard : NSDictionary = dictionary
        
        if let d = dictionary["dashboard"] as? NSDictionary{
            dashboard = d
        }
        
        dailyCarbsLimit     = dashboard["daily_carbs_limit"]        as Int
        dailyUsedCarbs      = dashboard["daily_used_carbs"]         as Int
        dailyRemainingCarbs = dashboard["daily_remaining_carbs"]    as Int
        
        if let backgroundImageURLString = dashboard["background_image"] as? String{
            backgroundImageURL = NSURL(string: backgroundImageURLString)
        }
        
        if let lastMealRecordDictionary = dashboard["last_meal_record"] as? NSDictionary{
            lastMealRecord = CSPhoto(dictionary: lastMealRecordDictionary)
        }
        
        if let userDictionary = dashboard["user"] as? NSDictionary{
            user = CSUser(dictionary: userDictionary)
        }
    }

}
