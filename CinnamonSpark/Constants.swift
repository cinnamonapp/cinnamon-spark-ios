//
//  Constants.swift
//  Cinnamon
//
//  Created by Alessio Santo on 23/04/15.
//  Copyright (c) 2015 Cinnamon. All rights reserved.
//

import Foundation

// APIEndpoints constant
let apiEndpoints : (local: String, development: String, staging: String, production: String) = (
    local:          "http://localhost:3000",
    development:    "http://192.168.1.12:3000",
    staging:        "http://cinnamon-staging.herokuapp.com",
    production:     "http://cinnamon-production.herokuapp.com"
)

// Change this constant to change the endpoint for entire app
let primaryAPIEndpoint = apiEndpoints.production


let SocialFeedQuirkyMessages = [
    "While you were gone\n others ate healthy.",
    "Ok, let's stalk others'\n healthy food decisions.",
    "Hey, admit it,\n you missed me!",
    "Hello friend,\n nice to see you again."
]

let UserFeedQuirkyMessages = [
    "You are golden,\n my friend",
    "Hello Meal View!"
]

let viewsBackgroundColor = UIColor(red: 239/255, green: 242/255, blue: 230/255, alpha: 1)
let viewsInsideBackgroundColor = UIColor.whiteColor()

let mainActionColor = UIColor(red: 169/255, green: 179/255, blue: 140/255, alpha: 1)