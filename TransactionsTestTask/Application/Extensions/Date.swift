//
//  Date+Extensions.swift
//  TransactionsTestTask
//
//  Created by CodingMeerkat on 07.10.2025.
//

import Foundation

extension Date {
    
    // MARK: - Time Formatting
    var shortTimeString: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: self)
    }
    
    // MARK: - Date Formatting
    var shortDateString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: self)
    }
    
    var mediumDateString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: self)
    }
    
    // MARK: - Combined Date and Time Formatting
    var shortDateTimeString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: self)
    }
    
    // MARK: - Section Title Formatting
    var sectionTitle: String {
        let calendar = Calendar.current
        let today = Date()
        
        if calendar.isDate(self, inSameDayAs: today) {
            return "Today"
        } else if calendar.isDate(self, inSameDayAs: calendar.date(byAdding: .day, value: -1, to: today) ?? today) {
            return "Yesterday"
        } else {
            return mediumDateString
        }
    }
}
