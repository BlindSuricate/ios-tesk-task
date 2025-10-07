//
//  Transaction.swift
//  TransactionsTestTask
//
//  Created by CodingMeerkat on 06.10.2025.
//

import Foundation

struct Transaction: Identifiable, Codable {
    let id: UUID
    let category: TransactionCategory
    let amount: Double
    let date: Date
    
    init(category: TransactionCategory, amount: Double, date: Date = Date()) {
        self.id = UUID()
        self.category = category
        self.amount = amount
        self.date = date
    }
    
    init(id: UUID, category: TransactionCategory, amount: Double, date: Date) {
        self.id = id
        self.category = category
        self.amount = amount
        self.date = date
    }
}
