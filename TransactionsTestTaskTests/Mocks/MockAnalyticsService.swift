//
//  MockAnalyticsService.swift
//  TransactionsTestTaskTests
//
//  Created by CodingMeerkat on 08.10.2025.
//

import Foundation
@testable import TransactionsTestTask

class MockAnalyticsService: AnalyticsService {
    var trackedEvents: [AnalyticsEventProtocol] = []
    
    func trackEvent(name: String, parameters: [String: String]) {
        trackedEvents.append(MockAnalyticsEvent(name: name, params: parameters))
    }
    
    func trackEvent(_ event: AnalyticsEventProtocol) {
        trackedEvents.append(event)
    }
    
    func getEvents(name: String?, fromDate: Date?, toDate: Date?) -> [AnalyticsEvent] {
        return []
    }
    
    func getEvents() -> [AnalyticsEvent] {
        return []
    }
    
    func clearEvents() {
        trackedEvents.removeAll()
    }
}
