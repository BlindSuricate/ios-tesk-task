//
//  AnalyticsManager.swift
//  TransactionsTestTask
//
//  Created by CodingMeerkat on 06.10.2025.
//

import Foundation

// MARK: - Analytics Manager
final class AnalyticsManager {
    
    // MARK: - Singleton
    static let shared = AnalyticsManager()
    
    // MARK: - Properties
    private let analyticsService: AnalyticsService
    
    // MARK: - Initialization
    private init() {
        self.analyticsService = AnalyticsServiceImpl(storage: InMemoryAnalyticsStorage())
    }
    
    // MARK: - Public Methods
    func trackEvent(name: String, parameters: [String: String] = [:]) {
        analyticsService.trackEvent(name: name, parameters: parameters)
    }
    
    func getEvents() -> [AnalyticsEvent] {
        return analyticsService.getEvents()
    }
    
    func clearEvents() {
        analyticsService.clearEvents()
    }
}
