//
//  AnalyticsStorage.swift
//  TransactionsTestTask
//
//  Created by CodingMeerkat on 06.10.2025.
//

import Foundation

// MARK: - Analytics Storage Protocol
protocol AnalyticsStorageProtocol {
    func saveEvent(_ event: AnalyticsEvent)
    func getEvents() -> [AnalyticsEvent]
    func clearEvents()
    func getEventCount() -> Int
}

// MARK: - In-Memory Analytics Storage
final class InMemoryAnalyticsStorage: AnalyticsStorageProtocol {
    
    // MARK: - Properties
    private var events: [AnalyticsEvent] = []
    private let queue = DispatchQueue(label: "analytics.storage.queue", attributes: .concurrent)
    private let maxEventsCount: Int
    
    // MARK: - Initialization
    init(maxEventsCount: Int = 10000) {
        self.maxEventsCount = maxEventsCount
    }
    
    // MARK: - AnalyticsStorageProtocol
    func saveEvent(_ event: AnalyticsEvent) {
        queue.async(flags: .barrier) { [weak self] in
            guard let self else { return }
            
            self.events.append(event)
            if self.events.count > self.maxEventsCount {
                let excessCount = self.events.count - self.maxEventsCount
                self.events.removeFirst(excessCount)
            }
        }
    }
    
    func getEvents() -> [AnalyticsEvent] {
        queue.sync {
            events.sorted { $0.date > $1.date }
        }
    }
    
    func clearEvents() {
        queue.async(flags: .barrier) { [weak self] in
            self?.events.removeAll()
        }
    }
    
    func getEventCount() -> Int {
        queue.sync {
            events.count
        }
    }
}

