//
//  Date.swift
//  Evomo
//
//  Created by David Moeller on 07.10.17.
//  Copyright © 2017 Evomo. All rights reserved.
//

import Foundation

extension Date {
    
    func timeSinceToday() -> String {
        
        let components = Calendar.current.dateComponents([.day, .month, .year], from: self, to: Date())
        
        var labelText = ""
        
        if let days = components.day, let months = components.month, let years = components.year, days > 7
            || months > 1 || years > 1 {
            
            if years > 0 {
                let localizedString = NSLocalizedString("%d years ago", comment: "X Years ago")
                labelText = String(format: localizedString, locale: Locale.current, arguments: [years])
            } else if months > 0 {
                let localizedString = NSLocalizedString("%d months ago", comment: "X Months ago")
                labelText = String(format: localizedString, locale: Locale.current, arguments: [months])
            } else if days > 0 {
                let localizedString = NSLocalizedString("%d days ago", comment: "X Days ago")
                labelText = String(format: localizedString, locale: Locale.current, arguments: [days])
            }
            
        } else {
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEEE"
            
            // let dayOfWeek = (Calendar.current.component(.weekday, from: self) + 7 - Calendar.current.firstWeekday) % 7 + 1
            
            // let weekDay = DateFormatter().weekdaySymbols[dayOfWeek]
            labelText = dateFormatter.string(from: self)
        }
        return labelText
    }
    
}
