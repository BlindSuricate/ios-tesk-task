//
//  CurrentBalance.swift
//  TransactionsTestTask
//
//  Created by CodingMeerkat on 06.10.2025.
//

import Foundation

struct CurrentBalance: Codable, Identifiable {
    let id: UUID
    let balance: Double
    let lastUpdated: Date
    
    init(id: UUID = UUID(), balance: Double, lastUpdated: Date = Date()) {
        self.id = id
        self.balance = balance
        self.lastUpdated = lastUpdated
    }
}