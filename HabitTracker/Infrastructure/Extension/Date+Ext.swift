//
//  Date+Ext.swift
//  HabitTracker
//
//  Created by Wan-lun Zheng on 2021/11/19.
//

import Foundation

extension Date {
    var isToday: Bool {
        return self.toString() == Date().toString()
    }
    
    var isYesterday: Bool {
        guard let yesterday = Date().addDay(-1) else { return false }
        
        return self.toString() == yesterday.toString()
    }
    
    var isTomorrow: Bool {
        guard let tomorrow = Date().addDay(1) else { return false }
        
        return self.toString() == tomorrow.toString()
    }
    
    func toString(_ format: String = "YYYY-MM-dd") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
    func addDay(_ numberOfDay: Int) -> Date? {
        return Calendar.current.date(byAdding: .day, value: numberOfDay, to: self)
    }
}
