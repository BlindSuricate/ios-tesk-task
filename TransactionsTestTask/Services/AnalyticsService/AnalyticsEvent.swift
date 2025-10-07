//
//  AnalyticsEvent.swift
//  TransactionsTestTask
//
//

import Foundation

// MARK: - Analytics Event
struct AnalyticsEvent: Codable, Identifiable {
    let id: UUID
    let name: String
    let parameters: [String: String]
    let date: Date
    
    init(name: String, parameters: [String: String] = [:]) {
        self.id = UUID()
        self.name = name
        self.parameters = parameters
        self.date = Date()
    }
}
