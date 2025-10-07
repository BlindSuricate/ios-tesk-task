//
//  AnalyticsEventProtocol.swift
//  TransactionsTestTask
//
//  Created by CodingMeerkat on 06.10.2025.
//

import Foundation

// MARK: - Analytics Event Protocol
protocol AnalyticsEventProtocol {
    var eventName: String { get }
    var parameters: [String: String] { get }
}

// MARK: - CoreData Error Event
struct CoreDataErrorEvent: AnalyticsEventProtocol {
    let eventName: String = "coredata_error"
    let operation: String
    let error: String
    let timestamp: String
    let additionalParameters: [String: String]
    
    var parameters: [String: String] {
        var params: [String: String] = [
            "operation": operation,
            "error": error,
            "timestamp": timestamp
        ]
        params.merge(additionalParameters) { _, new in new }
        return params
    }
    
    init(operation: String = #function, error: String, additionalParameters: [String: String] = [:]) {
        self.operation = operation
        self.error = error
        self.timestamp = "\(Date().timeIntervalSince1970)"
        self.additionalParameters = additionalParameters
    }
}

// MARK: - Bitcoin Rate Event
struct BitcoinRateEvent: AnalyticsEventProtocol {
    let eventName: String
    let timestamp: String
    let additionalParameters: [String: String]
    
    var parameters: [String: String] {
        var params: [String: String] = [
            "timestamp": timestamp
        ]
        params.merge(additionalParameters) { _, new in new }
        return params
    }
    
    init(eventName: String, additionalParameters: [String: String] = [:]) {
        self.eventName = eventName
        self.timestamp = "\(Date().timeIntervalSince1970)"
        self.additionalParameters = additionalParameters
    }
}

// MARK: - Bitcoin Rate Event Factory
struct BitcoinRateEventFactory {
    static func periodicUpdatesStarted(interval: TimeInterval) -> BitcoinRateEvent {
        BitcoinRateEvent(
            eventName: "bitcoin_rate_periodic_updates_started",
            additionalParameters: [
                "interval_seconds": "\(interval)"
            ]
        )
    }
    
    static func periodicUpdatesStopped() -> BitcoinRateEvent {
        BitcoinRateEvent(eventName: "bitcoin_rate_periodic_updates_stopped")
    }
    
    static func forceUpdate() -> BitcoinRateEvent {
        BitcoinRateEvent(eventName: "bitcoin_rate_force_update")
    }
    
    static func onlineAttempt() -> BitcoinRateEvent {
        BitcoinRateEvent(eventName: "bitcoin_rate_update_online_attempt")
    }
    
    static func onlineSuccess() -> BitcoinRateEvent {
        BitcoinRateEvent(
            eventName: "bitcoin_rate_update_online_success",
            additionalParameters: [
                "source": "internet"
            ]
        )
    }
    
    static func onlineFailure(error: String) -> BitcoinRateEvent {
        BitcoinRateEvent(
            eventName: "bitcoin_rate_update_online_failure",
            additionalParameters: [
                "source": "internet",
                "error": error
            ]
        )
    }
    
    static func offlineSuccess() -> BitcoinRateEvent {
        BitcoinRateEvent(
            eventName: "bitcoin_rate_update_offline_success",
            additionalParameters: [
                "source": "coredata"
            ]
        )
    }
    
    static func offlineFailure() -> BitcoinRateEvent {
        BitcoinRateEvent(
            eventName: "bitcoin_rate_update_offline_failure",
            additionalParameters: [
                "source": "coredata"
            ]
        )
    }
}
