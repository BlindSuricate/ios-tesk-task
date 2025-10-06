//
//  Category.swift
//  TransactionsTestTask
//
//  Created by CodingMeerkat on 06.10.2025.
//

import UIKit

enum TransactionCategiry: String {
    case groceries
    case taxi
    case electronics
    case restaurant
    case other
    
    var title: String {
        return self.rawValue.capitalized
    }
    
    var icon: UIImage? {
        return UIImage()
    }
}
