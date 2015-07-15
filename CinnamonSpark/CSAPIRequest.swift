//
//  CSAPIRequest.swift
//  CinnamonSpark
//
//  Created by Alessio Santo on 26/03/15.
//  Copyright (c) 2015 Cinnamon. All rights reserved.
//

import UIKit
import AdSupport

class CSAPIRequest: ASAPIRequest {
    
    // MARK: - Constants and Variables
    private let apiEndpoint : NSURL = NSURL(string: APP_API_ACTIVE_ENDPOINT)!
    
    override init() {
        super.init(baseURL: apiEndpoint)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Interface methods
    
    override func APIPathDictionary() -> [String : String] {
        return [
            "User"          : "/users/:id.json",
            "MealRecord"    : "/meal_records/:id.json",
            "Like"          : "/likes/:id.json",
            "Meal"          : "/meals/:id.json",
            "Comment"       : "/comments/:id.json",
            "Dashboard"     : "/dashboard/:id.json"
        ]
    }
    
    
    override func currentUser(userDictionary: NSDictionary?, handleResponseForEvent: Bool) {
        if let userD = userDictionary{
            CSUser.setCurrentUser(dictionary: userD)
        }
    }
    
    func updateCurrentUserWithDictionary(userDictionary: NSDictionary?) {
        if let userD = userDictionary{
            
            let params = [
                "user": userD
            ]
            
            let userPath : String = self.getAPIPath("User", withRecordId: self.uniqueIdentifier())
            
            self.PUT(userPath,
                parameters: params,
                success: { (request: AFHTTPRequestOperation!, responseObject: AnyObject!) -> Void in
                    println("Current user fields have been updated. \n \(responseObject)")
                },
                failure: { (request: AFHTTPRequestOperation!, error: NSError!) -> Void in
                    println("Error when updating the user record: \n \(error)")
                    
                    self.updateCurrentUserWithDictionary(userDictionary)
                }
            )
            
        }
    }
    
    // MARK: - HTTP custom requests methods
    
    func getUserDashboard(userId: String, success: ((AFHTTPRequestOperation!, AnyObject!) -> Void), failure: ((AFHTTPRequestOperation!, NSError!) -> Void)){
        let userDashboardPath : String = "/api/v1/" + self.getAPICombinedPath("User", withParentRecordId: userId, andModel: "Dashboard")
        
        self.GET(userDashboardPath, parameters: [], success: success, failure: failure)
    }
    
    func getUserDashboard(success: ((AFHTTPRequestOperation!, AnyObject!) -> Void), failure: ((AFHTTPRequestOperation!, NSError!) -> Void)){
        self.getUserDashboard(self.uniqueIdentifier(), success: success, failure: failure)
    }
    

    /**
    Creates a new MealRecord object, assigning it to the current user, and upload its image to server.
    
    :param: mealSize The size of the photographed meal
    :param: withImageData The NSData object of the image to be uploaded
    :param: delegate (optional) An object that conforms to CSCameraDelegate. To be used to communicate the request success or failure
    */
    
    func createMealRecord(params: NSDictionary, withImageData imageData: NSData, delegate: CSBaseDelegate?){
        let userMealRecordPath : String = self.getAPICombinedPath("User", withParentRecordId: self.uniqueIdentifier(), andModel: "MealRecord")
        
        self.POST(userMealRecordPath,
            parameters: params,
            constructingBodyWithBlock: { (formData: AFMultipartFormData!) -> Void in
                formData.appendPartWithFileData(imageData, name: "meal_record[photo]", fileName: "meal_photo.jpeg", mimeType: "image/jpeg")
            },
            success: { (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) -> Void in
                let responseDictionary = responseObject as NSDictionary
                
                println("Meal record uploaded.")
                if let apiRequestDelegate = delegate as? CSAPIRequestDelegate{
                    apiRequestDelegate.didSuccessfullyCreateMealRecord!(responseDictionary)
                }
                
            },
            failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println("Error uploading the file")
                println(error)
                
                // Try again until it works :D
                self.createMealRecord(params, withImageData: imageData, delegate: delegate)
            }
        )
        
    }
    
    var backgroundTask: UIBackgroundTaskIdentifier = UIBackgroundTaskInvalid

    func createMealRecord(params: NSDictionary, withImageData imageData: NSData, success: ((AFHTTPRequestOperation!, AnyObject!) -> Void)){
        
        let userMealRecordPath : String = self.getAPICombinedPath("User", withParentRecordId: self.uniqueIdentifier(), andModel: "MealRecord")
        
        let mealRecordParams = [
            "meal_record": params,
            "ignore_if_duplicate": true
        ]
        
        self.POST(userMealRecordPath,
            parameters: mealRecordParams,
            constructingBodyWithBlock: { (formData: AFMultipartFormData!) -> Void in
                formData.appendPartWithFileData(imageData, name: "meal_record[photo]", fileName: "meal_photo.jpeg", mimeType: "image/jpeg")
            },
            success: { (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) -> Void in
                let responseDictionary = responseObject as NSDictionary
                
                println("CSAPIRequest - Meal record uploaded.")
                success(operation, responseObject)
                
                self.endBackgroundTask()
            },
            failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println("CSAPIRequest - Error uploading the file")
                println(error)
                
                self.endBackgroundTask()
                // Try again until it works :D
//                self.createMealRecord(params, withImageData: imageData, success: success)
            }
        )
        
        registerBackgroundTask()
        
    }
    
    func registerBackgroundTask() {
        backgroundTask = UIApplication.sharedApplication().beginBackgroundTaskWithExpirationHandler {
            [unowned self] in
            self.endBackgroundTask()
        }
        assert(backgroundTask != UIBackgroundTaskInvalid)
    }
    
    func endBackgroundTask() {
        NSLog("Background task ended.")
        UIApplication.sharedApplication().endBackgroundTask(backgroundTask)
        backgroundTask = UIBackgroundTaskInvalid
    }
    
    
    
    func getUserMealRecords(userId: String, success: ((AFHTTPRequestOperation!, AnyObject!) -> Void), failure: ((AFHTTPRequestOperation!, NSError!) -> Void)) {
        
        let userMealRecordPath : String = self.getAPICombinedPath("User", withParentRecordId: userId, andModel: "MealRecord")
        
        self.GET(userMealRecordPath, parameters: ["page": 1], success: success, failure: failure)
        
    }
    
    func getUserMealRecords(userId: String, page: Int, success: ((AFHTTPRequestOperation!, AnyObject!) -> Void), failure: ((AFHTTPRequestOperation!, NSError!) -> Void)) {
        
        let userMealRecordPath : String = self.getAPICombinedPath("User", withParentRecordId: userId, andModel: "MealRecord")
        
        self.GET(userMealRecordPath, parameters: ["page": page], success: success, failure: failure)
        
    }
    
    func getUserMealRecords(success: ((AFHTTPRequestOperation!, AnyObject!) -> Void), failure: ((AFHTTPRequestOperation!, NSError!) -> Void)) {
        
        self.getUserMealRecords(self.uniqueIdentifier(), success: success, failure: failure)
    }
    
    /**
    Fetch MealRecords first page. Default page size from server is 25
    */
    func getOthersMealRecords(success: ((AFHTTPRequestOperation!, AnyObject!) -> Void), failure: ((AFHTTPRequestOperation!, NSError!) -> Void)){

        self.getOthersMealRecordsWithPage(1, success: success, failure: failure)
    }
    
    /**
    Fetch MealRecords with page number. Default page size from server is 25
    */
    func getOthersMealRecordsWithPage(page: Int, success: ((AFHTTPRequestOperation!, AnyObject!) -> Void), failure: ((AFHTTPRequestOperation!, NSError!) -> Void)){
        
        let mealRecordPath : String = self.getAPIPath("MealRecord")
        let params = [
            "page": page,
            "per_page": 5,
            "requesting_user_id": self.uniqueIdentifier()
        ]
        
        self.GET(mealRecordPath, parameters: params, success: success, failure: failure)
        
    }
    
    
    func getMealRecordWithId(id: String, success: ((AFHTTPRequestOperation!, AnyObject!) -> Void), failure: ((AFHTTPRequestOperation!, NSError!) -> Void)){
        let mealRecordPath : String = self.getAPIPath("MealRecord", withRecordId: id)
        
        self.GET(mealRecordPath, parameters: [], success: success, failure: failure)
        
    }
    
    
    func getUserMeals(userId: String, page: Int, success: ((AFHTTPRequestOperation!, AnyObject!) -> Void), failure: ((AFHTTPRequestOperation!, NSError!) -> Void)){
        let mealsPath : String = self.getAPICombinedPath("User", withParentRecordId: userId, andModel: "Meal")
        
        let params = [
            "page": page,
            "per_page": 5
        ]
        
        self.GET(mealsPath, parameters: params, success: success, failure: failure)
    }
    
    func getUserMeals(#page: Int, success: ((AFHTTPRequestOperation!, AnyObject!) -> Void), failure: ((AFHTTPRequestOperation!, NSError!) -> Void)){
        self.getUserMeals(self.uniqueIdentifier(), page: page, success: success, failure: failure)
    }
    
    
    // Likes
    
    func likeMealRecordWithId(id: String, success: ((AFHTTPRequestOperation!, AnyObject!) -> Void), failure: ((AFHTTPRequestOperation!, NSError!) -> Void)){
        let likesPath : String = "/api/v1" + self.getAPIPath("Like")
        
        let params = [
            "like": [
                "meal_record_id": id,
                "user_id": self.uniqueIdentifier()
            ],
            "delete_if_duplicate": true
        ]
        
        self.POST(likesPath, parameters: params, success: success, failure: failure)
    }
    
    func createLikeWithDictionary(dictionary: NSDictionary, success: ((AFHTTPRequestOperation!, AnyObject!) -> Void), failure: ((AFHTTPRequestOperation!, NSError!) -> Void)){
        let likesPath : String = "/api/v1" + self.getAPIPath("Like")
    
        let params = [
            "like": dictionary,
            "delete_if_duplicate": true
        ]
    
        self.POST(likesPath, parameters: params, success: success, failure: failure)
    }
    
    
    func getMealRecordLikes(mealRecordId: String, success: ((AFHTTPRequestOperation!, AnyObject!) -> Void), failure: ((AFHTTPRequestOperation!, NSError!) -> Void)){
        let likesPath : String = "/api/v1" + self.getAPICombinedPath("MealRecord", withParentRecordId: mealRecordId, andModel: "Like")
        
        self.GET(likesPath, parameters: [], success: success, failure: failure)
    }

    
    // Comments
    
    func createCommentWithDictionary(dictionary: NSDictionary, success: ((AFHTTPRequestOperation!, AnyObject!) -> Void), failure: ((AFHTTPRequestOperation!, NSError!) -> Void)){
        let commentsPath : String = "/api/v1" + self.getAPIPath("Comment")
        
        let params = [
            "comment": dictionary
        ]
        
        self.POST(commentsPath, parameters: params, success: success, failure: failure)
    }
    
    func getMealRecordComments(mealRecordId: String, success: ((AFHTTPRequestOperation!, AnyObject!) -> Void), failure: ((AFHTTPRequestOperation!, NSError!) -> Void)){
        let commentsPath : String = "/api/v1" + self.getAPICombinedPath("MealRecord", withParentRecordId: mealRecordId, andModel: "Comment")
        
        self.GET(commentsPath, parameters: [], success: success, failure: failure)
    }
}