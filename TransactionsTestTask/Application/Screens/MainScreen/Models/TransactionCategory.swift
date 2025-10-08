//
//  Category.swift
//  TransactionsTestTask
//
//  Created by CodingMeerkat on 06.10.2025.
//

import UIKit

enum TransactionCategory: String, Codable {
    case groceries
    case taxi
    case electronics
    case restaurant
    case other
    case enrollment
    
    var title: String {
        self.rawValue.capitalized
    }
    
    var emoji: String {
        switch self {
        case .groceries:
            return "🛒"
        case .taxi:
            return "🚕"
        case .electronics:
            return "📱"
        case .restaurant:
            return "🍽️"
        case .other:
            return "📝"
        case .enrollment:
            return "💰"
        }
    }
    
    var displayTitle: String {
        return "\(emoji) \(title)"
    }
    
    var isEnrollment: Bool {
        self == .enrollment
    }
    
    static var expenseTransaction: [TransactionCategory] {
        [.groceries, .taxi, .electronics, .restaurant]
    }
    
    static var incomeTransaction: [TransactionCategory] {
        [.enrollment]
    }
}
