//
//  SimpleDateFormatter.swift
//  rememberbreast
//
//  Created by Rodrigo Villamil Pérez on 18/7/18.
//  Copyright © 2018 Rodrigo Villamil Pérez. All rights reserved.
//

import Foundation

/*
 https://medium.com/ios-os-x-development/build-an-stopwatch-with-swift-3-0-c7040818a10f
 http://stackoverflow.max-everyday.com/2018/01/ios-how-to-get-the-current-time-as-datetime-in-swift/
*/
class SimpleDateFormatter {
    
    // e.g. 00 h 02 m 35 s
    static func secondsToHHmmss(_ time:Int) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i h %02i m %02i s", hours, minutes, seconds)
    }
    // e.g. 00 h 02 m 35 s
    static func secondsToHHmmss(_ time:TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i h %02i m %02i s", hours, minutes, seconds)
    }
    
    // e.g. May 26, 1976 12:34:20
    static func dateToString (_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy HH:mm:ss"
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        dateFormatter.locale = Locale.autoupdatingCurrent
        
        return dateFormatter.string(from: date)
    }

    // e.g. Date object
    static func stringToDate (_ strDate:String ) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy HH:mm:ss"
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        dateFormatter.locale = Locale.autoupdatingCurrent
        
        return dateFormatter.date(from: strDate)!
    }
    
    static func durationBetweenStringDates (strDateFrom:String,
                                            strDateTo: String ) -> String {
      
        return secondsToHHmmss (durationBetweenStringDatesAsInt (
            strDateFrom: strDateFrom,
            strDateTo: strDateTo))
    }
    
    static func durationBetweenStringDatesAsInt (
                                strDateFrom:String,
                                strDateTo: String ) -> Int {
        let dateFrom = self.stringToDate (strDateFrom)
        let dateTo = self.stringToDate (strDateTo)
        if (dateFrom > dateTo) {
            return 0
        }
        let dateInterval = DateInterval(start: dateFrom, end: dateTo)
        return Int(dateInterval.duration)
    }
    
    // e.g. "October 8, 2016"
    static func dateToStringMMMddyyy (_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .none
        dateFormatter.dateStyle = .long
        dateFormatter.timeZone  = TimeZone.autoupdatingCurrent
        dateFormatter.locale    = Locale.autoupdatingCurrent
        
        return dateFormatter.string(from: date)
    }
}
