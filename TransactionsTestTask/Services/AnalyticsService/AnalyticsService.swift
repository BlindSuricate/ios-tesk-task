//
//  AnalyticsService.swift
//  TransactionsTestTask
//
//

import Foundation

/// Analytics Service is used for events logging
/// The list of reasonable events is up to you
/// It should be possible not only to track events but to get it from the service
/// The minimal needed filters are: event name and date range
/// The service should be covered by unit tests
protocol AnalyticsService: AnyObject {
    func trackEvent(name: String, parameters: [String: String])
    func getEvents() -> [AnalyticsEvent]
    func clearEvents()
}

// MARK: - Analytics Service Implementation
final class AnalyticsServiceImpl: AnalyticsService {
    
    // MARK: - Properties
    private let storage: AnalyticsStorageProtocol
    private let queue = DispatchQueue(label: "analytics.service.queue", attributes: .concurrent)
    
    // MARK: - Initialization
    init(storage: AnalyticsStorageProtocol = InMemoryAnalyticsStorage()) {
        self.storage = storage
    }
    
    // MARK: - AnalyticsService
    func trackEvent(name: String, parameters: [String: String]) {
        let event = AnalyticsEvent(name: name, parameters: parameters)
        queue.async { [weak self] in
            self?.storage.saveEvent(event)
            print("Analytics Event: \(event.name) - \(event.parameters)")
        }
    }
    
    func getEvents() -> [AnalyticsEvent] {
        return storage.getEvents()
    }
    
    func clearEvents() {
        queue.async(flags: .barrier) { [weak self] in
            self?.storage.clearEvents()
        }
    }
}
