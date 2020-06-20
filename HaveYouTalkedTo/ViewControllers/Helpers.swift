//
//  Helpers.swift
//  HaveYouTalkedTo
//
//  Created by Michael Luckeneder on 6/19/20.
//  Copyright © 2020 optiminimalist. All rights reserved.
//

import Foundation

extension Date {

    /// Create a date from specified parameters
    ///
    /// - Parameters:
    ///   - year: The desired year
    ///   - month: The desired month
    ///   - day: The desired day
    /// - Returns: A `Date` object
    static func from(_ year: Int, _ month: Int, _ day: Int) -> Date? {
        let calendar = Calendar(identifier: .gregorian)
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        return calendar.date(from: dateComponents) ?? nil
    }

    func stripTime() -> Date {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: self)
        let date = Calendar.current.date(from: components)
        return date!
    }
}

func formatDate(_ date: Date?) -> String? {
    let dateFormatterGet = DateFormatter()
    dateFormatterGet.dateFormat = "MM/dd/yyyy"
    
    if let d = date {
        return dateFormatterGet.string(from: d)
    }
    
    return nil
   
}

//func generateRandomDate(daysBack: Int)-> Date?{
//    let day = arc4random_uniform(UInt32(daysBack))+1
//    let hour = arc4random_uniform(23)
//    let minute = arc4random_uniform(59)
//
//    let today = Date(timeIntervalSinceNow: 0)
//    let gregorian  = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)
//    var offsetComponents = DateComponents()
//    offsetComponents.day = -1 * Int(day - 1)
//    offsetComponents.hour = -1 * Int(hour)
//    offsetComponents.minute = -1 * Int(minute)
//
//    let randomDate = gregorian?.date(byAdding: offsetComponents, to: today, options: .init(rawValue: 0) )
//    return randomDate
//}
