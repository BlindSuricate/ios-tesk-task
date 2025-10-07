//
//  Rate.swift
//  TransactionsTestTask
//
//  Created by CodingMeerkat on 06.10.2025.
//

import Foundation

// MARK: - Rate Model
struct Rate: Identifiable, Codable {
    let id: UUID
    let rate: Double
    let date: Date
    
    init(rate: Double, date: Date = Date()) {
        self.id = UUID()
        self.rate = rate
        self.date = date
    }
    
    init(id: UUID, rate: Double, date: Date) {
        self.id = id
        self.rate = rate
        self.date = date
    }
}
