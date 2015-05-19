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

class CSPhoto: NSObject {
    var id : String!
    var URL : NSURL!
    var title : String!
    var user : CSUser!
    var createdAtDate : NSDate!
    var size : CSPhotoMealSize!
    var serving : CSPhotoServing!
    var carbsEstimate : CSPhotoMealCarbsEstimate?
    var carbsEstimateGrams : Int?
    
    convenience init(dictionary: NSDictionary){
        self.init()
        
        
        // Init default values
        self.title = ""
        self.size = CSPhotoMealSize.Small
        
        
        self.id = (dictionary["id"] as Int).description
        
        self.URL = NSURL(string: dictionary["photo_original_url"] as String)
        
        if(self.id != "-1"){
            self.createdAtDate = self.dateFromString(dictionary["created_at"] as String)
        }else{

        }
        
        if let size = dictionary["size"] as? Int{
            self.size = self.evaluateSize(size)
        }
        
        if let serving = dictionary["serving"] as? Int{
            self.serving = self.evaluateServing(serving)
        }
        
        
        if let carbs = dictionary["carbs_estimate"] as? Int{
            self.carbsEstimate = self.evaluateCarbsEstimate(carbs)
        }
        
        if let carbsGrams = dictionary["carbs_estimate_grams"] as? Int{
            if(carbsGrams == 0){
                self.carbsEstimateGrams = nil
            }else{
                self.carbsEstimateGrams = carbsGrams
            }
        }
        
        
        if let title = dictionary["title"] as? String{
            self.title = title
        }
        
        if let user = dictionary["user"] as NSDictionary!{
            self.user = CSUser(dictionary: user)
        }

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
        date = date.dateByAddingTimeInterval(NSTimeInterval(systemZone.secondsFromGMT))

        return date
    }
    
    func photoURL(style: CSPhotoPhotoStyle) -> NSURL{
        var urlString = self.URL.description
        urlString = urlString.stringByReplacingOccurrencesOfString("original", withString: style.rawValue)
        
        return NSURL(string: urlString)!
    }
}