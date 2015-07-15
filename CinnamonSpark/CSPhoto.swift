//
//  CSPhoto.swift
//  CinnamonSpark
//
//  Created by Alessio Santo on 03/04/15.
//  Copyright (c) 2015 Cinnamon. All rights reserved.
//

import UIKit

enum CSPhotoPhotoStyle : String{
    case Thumbnail          = "thumbnail"
    case Medium             = "medium"
    case Large              = "large"
    case Original           = "original"
    case BlurredBackground  = "blurred_background"
}

enum CSPhotoMealSize{
    case ExtraSmall
    case Small
    case Medium
    case Large
}

enum CSPhotoServing{
    case Cup
    case Piece
}

enum CSPhotoMealCarbsEstimate{
    case Low
    case Medium
    case High
}

class CSPhoto: CSModel {
    var id : String!
    
    /**
    Used when creating a new csPhoto from scratch
    */
    var image : UIImage?
    
    var URL : NSURL!
    var title : String!
    var user : CSUser!
    var createdAtDate : NSDate!
    var size : CSPhotoMealSize!
    var serving : CSPhotoServing!
    var carbsEstimate : CSPhotoMealCarbsEstimate?
    var carbsEstimateGrams : Int?
    var likesCount : Int?
    var commentsCount : Int?
    var hasBeenLikedByUser : Bool?
    var status : Int?
    
    override init(){
        // Init default values
        self.title = ""
        self.size = CSPhotoMealSize.Small
        
        self.createdAtDate = NSDate()
        
        self.carbsEstimate = CSPhotoMealCarbsEstimate.Low
        self.carbsEstimateGrams = 0
        self.serving = CSPhotoServing.Cup
        
        self.user = CSUser()
        
    }
    
    convenience init(dictionary: NSDictionary){
        self.init()
        
        var mealRecord : NSDictionary = unwrapDictionaryObject(dictionary, withKey: "meal_record")
        
        if let idInt = mealRecord["id"] as? Int{
            self.id = idInt.description
        }
        
        if let createdAtString = mealRecord["created_at"] as? String{
            self.createdAtDate = dateFromString(createdAtString)
        }else if let createdAtNSDate = mealRecord["created_at"] as? NSDate{
            self.createdAtDate = createdAtNSDate
        }
        
        if let photoOriginalUrlString = mealRecord["photo_original_url"] as? String{
            self.URL = NSURL(string: photoOriginalUrlString)
        }
        
        if let size = mealRecord["size"] as? Int{
            self.size = self.evaluateSize(size)
        }
        
        if let serving = mealRecord["serving"] as? Int{
            self.serving = self.evaluateServing(serving)
        }
        
        if let likesCountInt = mealRecord["likes_count"] as? Int{
            self.likesCount = likesCountInt
        }
        
        if let commentsCountInt = mealRecord["comments_count"] as? Int{
            self.commentsCount = commentsCountInt
        }
        
        if let statusInt = mealRecord["status"] as? Int{
            self.status = statusInt
        }
        
        if let hasBeenLikedByUserBool = mealRecord["has_been_liked_by_user"] as? Bool{
            self.hasBeenLikedByUser = hasBeenLikedByUserBool
        }
        
        
        if let carbs = mealRecord["carbs_estimate"] as? Int{
            self.carbsEstimate = self.evaluateCarbsEstimate(carbs)
        }
        
        if let carbsGrams = mealRecord["carbs_estimate_grams"] as? Int{
            if(carbsGrams == 0){
                self.carbsEstimateGrams = nil
            }else{
                self.carbsEstimateGrams = carbsGrams
            }
        }
        
        
        if let title = mealRecord["title"] as? String{
            self.title = title
        }
        
        if let user = mealRecord["user"] as NSDictionary!{
            self.user = CSUser(dictionary: user)
        }

        
        // Force size at max size
        self.size = CSPhotoMealSize.Large
    }
    
    func setSizeWithIntSize(intSize: Int){
        var size = CSPhotoMealSize.Small
        
        switch intSize{
        case 1:
            size = .ExtraSmall
            break
        case 2:
            size = .Small
            break
        case 3:
            size = .Medium
            break
        case 4:
            size = .Large
            break
        default:
            size = .Small
        }
        
        self.size = size
    }
    
    private func evaluateSize(intSize : Int) -> CSPhotoMealSize{
        var size = CSPhotoMealSize.Small
        
        switch intSize{
        case 1:
            size = .ExtraSmall
            break
        case 2:
            size = .Small
            break
        case 3:
            size = .Medium
            break
        case 4:
            size = .Large
            break
        default:
            size = .Small
        }
        
        return size
    }
    
    private func evaluateServing(intServing : Int) -> CSPhotoServing{
        var serving = CSPhotoServing.Cup
        
        switch intServing{
        case 1:
            serving = .Cup
            break
        case 2:
            serving = .Piece
            break
        default:
            serving = .Cup
        }
        
        return serving
    }
    
    private func evaluateCarbsEstimate(intEstimate: Int) -> CSPhotoMealCarbsEstimate{
        var estimate = CSPhotoMealCarbsEstimate.Medium
        
        switch intEstimate{
        case 1:
            estimate = .Low
            break
        case 2:
            estimate = .Medium
            break
        case 3:
            estimate = .High
            break
        default:
            estimate = .Medium
        }
        
        
        return estimate
    }

    private func dateFromString(string: String) -> NSDate{
        var count = countElements(string) - 5
        var dateString = (string as NSString).stringByReplacingCharactersInRange(NSMakeRange(count, 5), withString: "")
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        // Let's assume this is always GMT for now
        var date : NSDate = dateFormatter.dateFromString(dateString)!
        
        let systemZone = NSTimeZone.systemTimeZone()
//        date = date.dateByAddingTimeInterval(NSTimeInterval(systemZone.secondsFromGMT))

        return date
    }
    
    func photoURL(style: CSPhotoPhotoStyle) -> NSURL{
        var urlString = self.URL.description
        urlString = urlString.stringByReplacingOccurrencesOfString("original", withString: style.rawValue)
        
        return NSURL(string: urlString)!
    }
    
    private func imageData() -> NSData?{
        if let image = self.image{
            let imageData = UIImageJPEGRepresentation(image, 0.7)
            return imageData
        }
    
        return nil
    }
    
    override func toDictionary() -> NSDictionary{
        var dictionary : NSMutableDictionary = [
            "title": title,
            "created_at": createdAtDate,
            "size": size.hashValue + 1,
            "serving": serving.hashValue + 1
        ]
//        
//        if let user = self.user{
//            if let userId = user.id{
//                dictionary.setObject(userId, forKey: "user_id")
//            }
//        }
        
        return dictionary
    }

    override func save(#success: ((AFHTTPRequestOperation!, AnyObject!) -> Void), failure: ((AFHTTPRequestOperation!, NSError!) -> Void)) {
        println("Trying save")
        if let imageData = imageData(){
            println("image data is present")
            CSAPIRequest().createMealRecord(toDictionary(), withImageData: imageData, success: wrapSuccessResponse(success))
        }else{
            println("Image is not present. Dequeue")
            self.dequeue()
        }
    }
    
    
    // unstable code
    
    
    
    convenience init(dequeuedDictionary: NSDictionary){
        self.init(dictionary: dequeuedDictionary)
        
        var mealRecord : NSDictionary = dequeuedDictionary
        
        if let m = dequeuedDictionary["meal_record"] as? NSDictionary{
            mealRecord = m
        }
        
        if let cachedImagePathString = mealRecord["cached_image_path"] as? String{
            println("reading image \(cachedImagePathString)")
            
            let cachedImage = FCFileManager.readFileAtPathAsImage(cachedImagePathString)
            
            if(cachedImage !== nil){
                self.image = cachedImage.imageRotatedByDegrees(90, flip: false)
            }

        }
        
        if let queueableKeyString = mealRecord["queueable_key"] as? String{
            self.queueableUniqueKey = queueableKeyString
        }
        
        if let userIdString = mealRecord["user_id"] as? String{
            self.user = CSUser(dictionary: [
                "id": userIdString
                ])
        }
    }
    
}






private var queueableUniqueKeyAssociationKey : UInt8 = 0
extension CSPhoto : Queueable{
    
    typealias CSQueue = NSArray

    class var queueUniqueKey : String! {
        get{ return "cached_meal_records_key" }
    }
    
    class func queuedObjects() -> [Queueable] {
        var queue : [Queueable] = []
        
        if let q = NSUserDefaults.standardUserDefaults().objectForKey(queueUniqueKey) as? NSArray{
            
            for item in q{
                if let dictionary = item as? NSDictionary{
                    let mealRecord = CSPhoto(dequeuedDictionary: dictionary)
                    
                    queue.append(mealRecord)
                }
            }
            
        }
        
        return queue
    }
    
    class func currentQueue() -> CSQueue{
        var queue : CSQueue = []
        
        if let currentQueue = NSUserDefaults.standardUserDefaults().objectForKey(queueUniqueKey) as? CSQueue{
            queue = currentQueue
        }

        return queue
    }
    

    
    class func updateCurrentQueue(newQueue: CSQueue){
        NSUserDefaults.standardUserDefaults().setObject(newQueue, forKey: queueUniqueKey)
    }
    
    class func addObjectToQueue(object: Queueable, withKey queueableUniqueKey: String) -> [Queueable] {
        var newQueue : NSMutableArray = NSMutableArray(array: currentQueue())
        
        newQueue.addObject(object.toQueueableDictionaryForKey!(queueableUniqueKey))
        
        // Override queue with new queue
        updateCurrentQueue(newQueue)
        
        if let mealRecord = object as? CSPhoto{
            println("Creating file at path \(APP_DEFAULT_MEAL_RECORD_CACHE_FOLDER)\(queueableUniqueKey).jpg")
            
            let filePath = "\(APP_DEFAULT_MEAL_RECORD_CACHE_FOLDER)\(queueableUniqueKey).jpg"
            FCFileManager.createFileAtPath(filePath, withContent: mealRecord.image)
        }

        return queuedObjects()
    }
    
    class func removeObjectFromQueueWithKey(key: String) -> Queueable? {
        var correctIndex : Int? = nil
        var finalQueueable : Queueable? = nil
        
        if let queue = NSUserDefaults.standardUserDefaults().objectForKey(queueUniqueKey) as? NSArray{
            
            for (index, object) in enumerate(queue){
                
                if let item = object as? NSDictionary{
                    
                    let queueable = CSPhoto(dequeuedDictionary: item)
                    
                    if (queueable.queueableUniqueKey == key){
                        correctIndex = index
                    }
                    
                    // Remove the cached file from the file system
                    FCFileManager.removeItemAtPath("\(APP_DEFAULT_MEAL_RECORD_CACHE_FOLDER)\(queueable.queueableUniqueKey).jpg")
                }
                
            }
            
            if let index = correctIndex{
                var newQueue = NSMutableArray(array: queue)
                
                newQueue.removeObjectAtIndex(index)
                
                updateCurrentQueue(newQueue)
            }
            
        }
        
        return finalQueueable
    }

    class func dequeueObjectWithKey(key: String){
        removeObjectFromQueueWithKey(key)
    }
    
    class func dequeueLastObject() -> Queueable?{
        let queue = queuedObjects()
        
        if(queue.count >= 1){
            let object = queue[0]
            println("Dequeuing object \(object)")
            object.retry()
            
            return object
        }
        
        return nil
    }
    
    class func dequeueObjects(){
        println("Dequeueing objects!!")
        if let queue = NSUserDefaults.standardUserDefaults().objectForKey(queueUniqueKey) as? NSArray{
            println("Count = \(queue.count)")
            for (index, object) in enumerate(queue){
                if(index == 0){
                    if let item = object as? NSDictionary{
                        println("Retrying on first object: \(item)")

                        let image = FCFileManager.readFileAtPathAsImage(item["cached_image_path"] as String)
                        println("With image: \(image)")
                        
                        
                        let mealRecord = CSPhoto(dequeuedDictionary: item)
                        mealRecord.retry()
                        
                    }
                }
                
            }
        }
    }
    
    
    
    var queueableUniqueKey : String? {
        get{
            return objc_getAssociatedObject(self, &queueableUniqueKeyAssociationKey) as String?
        }
        
        set{
            objc_setAssociatedObject(self, &queueableUniqueKeyAssociationKey, newValue, objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN))
        }
    }
    
    
    func dequeue(){
        if let queueableUniqueKey = self.queueableUniqueKey{
            FCFileManager.removeItemAtPath("\(APP_DEFAULT_MEAL_RECORD_CACHE_FOLDER)\(queueableUniqueKey).jpg")
            CSPhoto.dequeueObjectWithKey(queueableUniqueKey)
        }
    }
    
    private func wrapSuccessResponse(callback: ((AFHTTPRequestOperation!, AnyObject!) -> Void) ) -> ((AFHTTPRequestOperation!, AnyObject!) -> Void){
        return { (request: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            self.dequeue()
            
            callback(request, response)
            
        }
    }

    func toQueueableDictionaryForKey(key: String) -> NSDictionary{
        var mutableDictionary : NSMutableDictionary = NSMutableDictionary(dictionary: toDictionary())
        
        
        mutableDictionary.setObject(key                                     ,   forKey: "queueable_key")
        mutableDictionary.setObject("\(APP_DEFAULT_MEAL_RECORD_CACHE_FOLDER)\(key).jpg",   forKey: "cached_image_path")
        
        return mutableDictionary
    }
    
    func retry() {
        println("Retrying save")
        save()
    }
    
    
    func queue(){
        let now = NSDate()
        
        queueableUniqueKey = "cached_meal_record_\(now.timeIntervalSinceNow)"
        
        CSPhoto.addObjectToQueue(self, withKey: queueableUniqueKey!)
        
        self.save()
    }
    
    func queue(#success: ((AFHTTPRequestOperation!, AnyObject!) -> Void), failure: ((AFHTTPRequestOperation!, NSError!) -> Void)) {
        let now = NSDate()
        
        queueableUniqueKey = "cached_meal_record_\(now.timeIntervalSinceNow)"
        
        CSPhoto.addObjectToQueue(self, withKey: queueableUniqueKey!)
        
        self.save(success: success, failure: failure)
    }
}