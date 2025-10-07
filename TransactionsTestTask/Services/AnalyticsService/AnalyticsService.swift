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
    func trackEvent(_ event: AnalyticsEventProtocol)
    func getEvents(name: String?, fromDate: Date?, toDate: Date?) -> [AnalyticsEvent]
    func getEvents() -> [AnalyticsEvent]
    func clearEvents()
}

// MARK: - Analytics Service Implementation
final class AnalyticsServiceImpl: AnalyticsService {
    
    // MARK: - Properties
    private var events: [AnalyticsEvent] = []
    private let queue = DispatchQueue(label: "analytics.service.queue", attributes: .concurrent)
    private let maxEventsCount: Int = 10000
    
    // MARK: - Initialization
    init() {}
    
    // MARK: - AnalyticsService
    func trackEvent(name: String, parameters: [String: String]) {
        let event = AnalyticsEvent(name: name, parameters: parameters)
        queue.async(flags: .barrier) { [weak self] in
            guard let self else { return }
            
            self.events.append(event)
            if self.events.count > self.maxEventsCount {
                let excessCount = self.events.count - self.maxEventsCount
                self.events.removeFirst(excessCount)
            }
            print("Analytics Event: \(event.name) - \(event.parameters)")
        }
    }
    
    func trackEvent(_ event: AnalyticsEventProtocol) {
        let analyticsEvent = AnalyticsEvent(name: event.eventName, parameters: event.parameters)
        queue.async(flags: .barrier) { [weak self] in
            guard let self else { return }
            
            self.events.append(analyticsEvent)
            if self.events.count > self.maxEventsCount {
                let excessCount = self.events.count - self.maxEventsCount
                self.events.removeFirst(excessCount)
            }
            print("Analytics Event: \(analyticsEvent.name) - \(analyticsEvent.parameters)")
        }
    }
    
    func getEvents(name: String?, fromDate: Date?, toDate: Date?) -> [AnalyticsEvent] {
        queue.sync {
            let filteredEvents = events.filter { event in
                if let name, !name.isEmpty {
                    guard event.name == name else { return false }
                }

                if let fromDate {
                    guard event.date >= fromDate else { return false }
                }
                
                if let toDate {
                    guard event.date <= toDate else { return false }
                }
                
                return true
            }
            
            return filteredEvents.sorted { $0.date > $1.date }
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
}
