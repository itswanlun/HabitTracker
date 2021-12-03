//
//  String+Ext.swift
//  HabitTracker
//
//  Created by Wan-lun Zheng on 2021/11/19.
//

import Foundation

extension String {
    func toDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        return dateFormatter.date(from: self)
    }
    
    // Example
    static func convertDate(_ date: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        return dateFormatter.date(from: date)
    }
}
