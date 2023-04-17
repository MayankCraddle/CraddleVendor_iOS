//
//  Date+Extensions.swift
//  SaharaGo_Vendor
//
//  Created by ChawTech Solutions on 18/10/22.
//

import Foundation

extension Date {
    func convertTimeInterval(format: String? = "h:mm a") -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
    //        dateFormatter.timeZone = TimeZone(abbreviation: "Australia/Sydney")
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
        
    }
}

