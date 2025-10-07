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
    
    var icon: UIImage? {
        UIImage()
    }
    
    static var expenseTransaction: [TransactionCategory] {
        [.groceries, .taxi, .electronics, .restaurant]
    }
    
    static var incomeTransaction: [TransactionCategory] {
        [.enrollment]
    }
}
