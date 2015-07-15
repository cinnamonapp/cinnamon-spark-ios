//
//  Constants.swift
//  Cinnamon
//
//  Created by Alessio Santo on 23/04/15.
//  Copyright (c) 2015 Cinnamon. All rights reserved.
//

import Foundation


// Change the app environment here
let APP_ENVIRONMENT = "production"


private let APP_API_ENDPOINTS = [
    "local":            "http://localhost:3000",
    "development":      "http://alessio.local:3000",
    "staging":          "http://cinnamon-staging.herokuapp.com",
    "production":       "http://cinnamon-production.herokuapp.com"
]

let APP_API_ACTIVE_ENDPOINT                 = APP_API_ENDPOINTS[APP_ENVIRONMENT]!

let APP_DEFAULT_CACHE_FOLDER                = "cinnamon_\(APP_ENVIRONMENT)_cache/"
let APP_DEFAULT_MEAL_RECORD_CACHE_FOLDER    = "\(APP_DEFAULT_CACHE_FOLDER)meal_records_cache/"

let USER_HAS_ALREADY_ONBOARDED_KEY          = "user_\(APP_ENVIRONMENT)_has_already_onboarded_new2_key"
let USER_HAS_COMPLETED_SIGNUP_KEY           = "user_\(APP_ENVIRONMENT)_has_completed_signup_new2_key"



// UI customizations
let ColorPalette = (
    AboveColor:                     UIColorFromHex(0x743D3C, alpha: 1.0),
    WithinColor:                    UIColorFromHex(0x75A87F, alpha: 1.0),
    BelowColor:                     UIColorFromHex(0xDA967C, alpha: 1.0),
    DefaultTextColor:               UIColor.whiteColor(),
    DefaultButtonBackgroundColor:   UIColorFromHex(0x75A87F, alpha: 1.0)
)

let DefaultFont = UIFont(name: "Futura", size: 18)


let viewsBackgroundColor = UIColor.blackColor()
let viewsInsideBackgroundColor = UIColor.whiteColor()

let mainActionColor = UIColor(red: 169/255, green: 179/255, blue: 140/255, alpha: 1)
