//
//  CSModel.swift
//  Cinnamon
//
//  Created by Alessio Santo on 24/06/15.
//  Copyright (c) 2015 Cinnamon. All rights reserved.
//

import Foundation

class CSModel: NSObject, APIable {
//    var id : String?
//    
//    override init(){
//        
//    }
    
    func unwrapDictionaryObject(dictionaryObject: AnyObject, withKey: String) -> NSDictionary{
        
        var resultDictionary = NSDictionary()
        
        if let dictionary = dictionaryObject as? NSDictionary{
            resultDictionary = dictionary
            
            if let unwrappedDictionary = dictionary[withKey] as? NSDictionary{
                resultDictionary = unwrappedDictionary
            }
        }
        
        return resultDictionary
        
    }
    
    func toDictionary() -> NSDictionary! {
        return NSDictionary()
    }
    
    func save(#success: ((AFHTTPRequestOperation!, AnyObject!) -> Void), failure: ((AFHTTPRequestOperation!, NSError!) -> Void)) {
        // Perform basic operations
    }
    
    func save() {
        save(success: { (request: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            
        }) { (request: AFHTTPRequestOperation!, error: NSError!) -> Void in
            
        }
    }
}
//
//
//class CSQueueableModel : CSModel, Queueable{
//    // Has methods to queue properly object in memory
//    // overrides methods to save the object with the api
//    // has methods to retreive queued objects
//    // has methods to retry all the uploads in the queue
//    
//    class var className : String {
//        get{ return "Model" }
//    }
//    
//    class func addObjectToQueue(object: Queueable) -> [Queueable] {
//        return []
//    }
//    class func queuedObjects() -> [Queueable] {
//        return []
//    }
//    
//    class func retryQueuedObjects() {
//        
//    }
//    
//    func queue() {
//        CSQueueableModel.addObjectToQueue(self)
//    }
//    
//    func retry() {
//        
//    }
//    
//    override func save(#success: ((AFHTTPRequestOperation!, AnyObject!) -> Void), failure: ((AFHTTPRequestOperation!, NSError!) -> Void)) {
//
//    }
//}


@objc protocol APIable{
//    var id : String? {get set}
    
    // Turns the model into a dictionary
    func toDictionary() -> NSDictionary!
    
    // Saves with callbacks
    func save(#success: ((AFHTTPRequestOperation!, AnyObject!) -> Void), failure: ((AFHTTPRequestOperation!, NSError!) -> Void))
    
    // Saves without callbacks
    func save()
}




@objc
protocol Queueable: APIable{
    optional class var queueUniqueKey : String! { get }
    
    optional class func queuedObjects() -> [Queueable]
    optional class func retryQueuedObjects()
    optional class func addObjectToQueue(object: Queueable, withKey queueableUniqueKey: String) -> [Queueable]
    optional class func removeObjectFromQueueWithKey(key: String) -> Queueable?
    
    optional var queueableUniqueKey : String? { get set }

    optional func toQueueableDictionaryForKey(key: String) -> [NSDictionary]
    
    func retry()
    /**
    Add the object to the main queue
    */
    optional func queue()
    
}

