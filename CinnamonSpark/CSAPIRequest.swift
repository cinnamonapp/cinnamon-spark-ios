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
    private let apiEndpoint : NSURL = NSURL(string: primaryAPIEndpoint)!
    
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
            "Dashboard"     : "/dashboard"
        ]
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
    
    func createMealRecord(params: NSDictionary, withImageData imageData: NSData, success: ((AFHTTPRequestOperation!, AnyObject!) -> Void)){
        let userMealRecordPath : String = self.getAPICombinedPath("User", withParentRecordId: self.uniqueIdentifier(), andModel: "MealRecord")
        
        self.POST(userMealRecordPath,
            parameters: params,
            constructingBodyWithBlock: { (formData: AFMultipartFormData!) -> Void in
                formData.appendPartWithFileData(imageData, name: "meal_record[photo]", fileName: "meal_photo.jpeg", mimeType: "image/jpeg")
            },
            success: { (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) -> Void in
                let responseDictionary = responseObject as NSDictionary
                
                println("Meal record uploaded.")
                success(operation, responseObject)
                
            },
            failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println("Error uploading the file")
                println(error)
                
                // Try again until it works :D
                self.createMealRecord(params, withImageData: imageData, success: success)
            }
        )
        
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
        
        let mealRecordPath : String = self.getAPIPath("MealRecord")
        let params = [
            "page": 1
        ]
        
        self.GET(mealRecordPath, parameters: params, success: success, failure: failure)
        
    }
    
    /**
    Fetch MealRecords with page number. Default page size from server is 25
    */
    func getOthersMealRecordsWithPage(page: Int, success: ((AFHTTPRequestOperation!, AnyObject!) -> Void), failure: ((AFHTTPRequestOperation!, NSError!) -> Void)){
        
        let mealRecordPath : String = self.getAPIPath("MealRecord")
        let params = [
            "page": page
        ]
        
        self.GET(mealRecordPath, parameters: params, success: success, failure: failure)
        
    }
    
    
    func getMealRecordWithId(id: String, success: ((AFHTTPRequestOperation!, AnyObject!) -> Void), failure: ((AFHTTPRequestOperation!, NSError!) -> Void)){
        let mealRecordPath : String = self.getAPIPath("MealRecord", withRecordId: id)
        
        self.GET(mealRecordPath, parameters: [], success: success, failure: failure)
        
    }
    
}
