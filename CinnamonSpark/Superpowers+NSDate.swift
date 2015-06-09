//
//  Superpowers+NSDate.swift
//  Cinnamon
//
//  Created by Alessio Santo on 09/06/15.
//  Copyright (c) 2015 Cinnamon. All rights reserved.
//

import Foundation

extension NSDate{
    func toDefaultStringRepresentation() -> String{
        var string = ""
        var date = self
        var fullDayOfWeekName = fullDayOfWeekNameFromInt(getDayOfWeek(date)!)
        var dateWithFormat = date.formattedDateWithFormat("dd.MM.yyyy")
        
        let today = NSDate()
        let yesterday = NSDate(year: today.year(), month: today.month(), day: today.day() - 1)
        
        if(date.compare(today, unitGranularity: NSCalendarUnit.DayCalendarUnit) == NSComparisonResult.OrderedSame){
            fullDayOfWeekName = "Today"
        }else if(date.compare(yesterday, unitGranularity: NSCalendarUnit.DayCalendarUnit) == NSComparisonResult.OrderedSame){
            fullDayOfWeekName = "Yesterday"
        }
        
        string += "\(fullDayOfWeekName)"
        string += " \(dateWithFormat)"
        
        return string
    }
    
    func compare(date: NSDate, unitGranularity: NSCalendarUnit) -> NSComparisonResult {
        let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        
        let dif : NSComparisonResult = calendar.compareDate(self, toDate: date, toUnitGranularity: unitGranularity)
        
        return dif
    }
}


private func dateFromString(dateString: String) -> NSDate?{
    let formatter  = NSDateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    if let date = formatter.dateFromString(dateString) {
        return date
    } else {
        return nil
    }
}

private func getDayOfWeek(dateString:String)->Int? {
    if let date = dateFromString(dateString){
        return getDayOfWeek(date)
    } else {
        return nil
    }
}

private func getDayOfWeek(date: NSDate) -> Int?{
    let myCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
    let myComponents = myCalendar.components(.CalendarUnitWeekday, fromDate: date)
    let weekDay = myComponents.weekday
    
    return weekDay
}

private func dayOfWeekNameFromInt(index: Int) -> String{
    let array = [
        "Sun",
        "Mon",
        "Tue",
        "Wed",
        "Thu",
        "Fri",
        "Sat"
    ]
    
    return array[index - 1]
}

private func fullDayOfWeekNameFromInt(index: Int) -> String{
    let array = [
        "Sunday",
        "Monday",
        "Tuesday",
        "Wednesday",
        "Thursday",
        "Friday",
        "Saturday"
    ]
    
    return array[index - 1]
}
