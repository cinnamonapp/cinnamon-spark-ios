//
//  CSAPIRequest.swift
//  CinnamonSpark
//
//  Created by Alessio Santo on 26/03/15.
//  Copyright (c) 2015 Cinnamon. All rights reserved.
//

import UIKit
import AdSupport

class CSAPIRequest: AFHTTPRequestOperationManager {
    
    private let deviceUniqueIdentifier = ASIdentifierManager.sharedManager().advertisingIdentifier.UUIDString
    private let APIEndpoint : NSURL = NSURL(string: apiEndpoints.production)!
    
    private let APIPathDictionary : [String : String] = [
        "User" : "/users/:id.json",
        "MealRecord" : "/meal_records/:id.json"
    ]

    // default initiator with default base url
    init(){
        super.init(baseURL: self.APIEndpoint)
    }
    
    override init(baseURL url: NSURL!) {
        super.init(baseURL: url)
    }
    
    func getAPIPath(model: String) -> String{
        return self.getAPIPath(model, withRecordId: nil)
    }
    
    // Retrieves stuff from the dictionary and parses it
    func getAPIPath(model: String, withRecordId recordId: String?) -> String{
        var path : String = self.APIPathDictionary[model]!
        
        if recordId != nil{
            path = path.stringByReplacingOccurrencesOfString(":id", withString: recordId!)
        }else{
            path = path.stringByReplacingOccurrencesOfString("/:id", withString: "")
        }
        
        return path
    }
    
    func getAPICombinedPath(parentModel: String, withParentRecordId parentRecordId: String, andModel model: String) -> String{
        var path : String = self.getAPIPath(parentModel, withRecordId: parentRecordId)
        var appendPath : String = self.getAPIPath(model)
        
        path = path.stringByReplacingOccurrencesOfString(".json", withString: appendPath)
        
        return path
    }
    
    func getAPICombinedPath(parentModel: String, withParentRecordId parentRecordId: String, andModel model: String, withRecordId recordId: String?) -> String{
        var path : String = self.getAPIPath(parentModel, withRecordId: parentRecordId)
        var appendPath : String = self.getAPIPath(model, withRecordId: recordId)
        
        path = path.stringByReplacingOccurrencesOfString(".json", withString: appendPath)
        
        return path
    }
    

    // MARK: - HTTP custom requests methods
    
    /**
        Creates a new MealRecord object, assigning it to the current user, and upload its image to server.
    
        :param: mealSize The size of the photographed meal
        :param: withImageData The NSData object of the image to be uploaded
        :param: delegate (optional) An object that conforms to CSCameraDelegate. To be used to communicate the request success or failure
    */
    
    func createMealRecord(mealSize: Int, withImageData imageData: NSData, delegate: CSBaseDelegate?){
        let userMealRecordPath : String = self.getAPICombinedPath("User", withParentRecordId: self.deviceUniqueIdentifier, andModel: "MealRecord")
        
        let params : NSDictionary = [
            "meal_record": [
                "size": mealSize
            ]
        ]
        
        self.POST(userMealRecordPath,
            parameters: params,
            constructingBodyWithBlock: { (formData: AFMultipartFormData!) -> Void in
                formData.appendPartWithFileData(imageData, name: "meal_record[photo]", fileName: "meal_photo.jpeg", mimeType: "image/jpeg")
            },
            success: { (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) -> Void in
                let responseDictionary = responseObject as NSDictionary
                
                
                if let apiRequestDelegate = delegate as? CSAPIRequestDelegate{
                    apiRequestDelegate.didSuccessfullyCreateMealRecord!(responseDictionary)
                }
                
            },
            failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println("Error uploading the file")
                
                // TODO: - Add delegate methods to inform of failure
            }
        )
        
    }
    
    func getUserMealRecords(success: ((AFHTTPRequestOperation!, AnyObject!) -> Void), failure: ((AFHTTPRequestOperation!, NSError!) -> Void)) {
        
        let userMealRecordPath : String = self.getAPICombinedPath("User", withParentRecordId: self.deviceUniqueIdentifier, andModel: "MealRecord")

        self.GET(userMealRecordPath, parameters: [], success: success, failure: failure)
    
    }
    
    func getOthersMealRecords(success: ((AFHTTPRequestOperation!, AnyObject!) -> Void), failure: ((AFHTTPRequestOperation!, NSError!) -> Void)){
        
        let mealRecordPath : String = self.getAPIPath("MealRecord")
        let params = [
            "except_user_id": self.deviceUniqueIdentifier
        ]
        
        self.GET(mealRecordPath, parameters: params, success: success, failure: failure)
        
    }
    
    
    
    /** 
        Use the device UUID to authenticate the user.
        It will create a new user if the UUID is not found.
    */
    func checkCurrentUserInUsingDeviceUUID(){
        let userPath : String = self.getAPIPath("User")
        
        let params : NSDictionary = [
            "user": [
                "device_uuid": self.deviceUniqueIdentifier
            ]
        ]
        
        self.POST(userPath,
            parameters: params,
            success: { (request: AFHTTPRequestOperation!, sender: AnyObject!) -> Void in
                println("User has been created/retrieved")
            },
            failure: { (request: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println("Error in api")
//                fatalError("Fix this!")
            }
        )
        
    }

    /**
        Save the currentUser's remote notification token on the server.
    
        :param: deviceToken The token received from the AppDelegate.
    */
    func updateCurrentUserNotificationToken(deviceToken : NSData){
        println(deviceToken)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
