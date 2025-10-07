//
//  AnalyticsServiceTests.swift
//  TransactionsTestTaskTests
//
//  Created by CodingMeerkat on 06.10.2025.
//

import XCTest
@testable import TransactionsTestTask

final class AnalyticsServiceTests: XCTestCase {
    
    // MARK: - Properties
    private var analyticsService: AnalyticsService!
    
    // MARK: - Setup & Teardown
    override func setUp() {
        super.setUp()
        analyticsService = AnalyticsServiceImpl()
    }
    
    override func tearDown() {
        analyticsService = nil
        super.tearDown()
    }
    
    // MARK: - trackEvent(name:parameters:) Tests
    
    func testTrackEventWithNameAndParameters_ShouldSaveEventToStorage() {
        // Given
        let eventName = "test_event"
        let parameters = ["key1": "value1", "key2": "value2"]
        
        // When
        analyticsService.trackEvent(name: eventName, parameters: parameters)
        
        // Then
        let savedEvents = analyticsService.getEvents()
        XCTAssertEqual(savedEvents.count, 1)
        let savedEvent = savedEvents.first!
        XCTAssertEqual(savedEvent.name, eventName)
        XCTAssertEqual(savedEvent.parameters, parameters)
        XCTAssertNotNil(savedEvent.date)
    }
    
    func testTrackEventWithNameAndParameters_ShouldHandleEmptyParameters() {
        // Given
        let eventName = "test_event"
        let parameters: [String: String] = [:]
        
        // When
        analyticsService.trackEvent(name: eventName, parameters: parameters)
        
        // Then
        let savedEvents = analyticsService.getEvents()
        XCTAssertEqual(savedEvents.count, 1)
        let savedEvent = savedEvents.first!
        XCTAssertEqual(savedEvent.name, eventName)
        XCTAssertEqual(savedEvent.parameters, parameters)
    }
    
    func testTrackEventWithNameAndParameters_ShouldHandleMultipleEvents() {
        // Given
        let eventName1 = "test_event_1"
        let parameters1 = ["key1": "value1"]
        let eventName2 = "test_event_2"
        let parameters2 = ["key2": "value2"]
        
        // When
        analyticsService.trackEvent(name: eventName1, parameters: parameters1)
        analyticsService.trackEvent(name: eventName2, parameters: parameters2)
        
        // Then
        let savedEvents = analyticsService.getEvents()
        XCTAssertEqual(savedEvents.count, 2)
        XCTAssertEqual(savedEvents[1].name, eventName1)
        XCTAssertEqual(savedEvents[1].parameters, parameters1)
        XCTAssertEqual(savedEvents[0].name, eventName2)
        XCTAssertEqual(savedEvents[0].parameters, parameters2)
    }
    
    // MARK: - trackEvent(_:) Tests
    
    func testTrackEventWithProtocol_ShouldSaveCoreDataErrorEvent() {
        // Given
        let operation = "fetchTransactions"
        let error = "CoreData error"
        let additionalParameters = ["page": "1"]
        let event = CoreDataErrorEvent(
            operation: operation,
            error: error,
            additionalParameters: additionalParameters
        )
        
        // When
        analyticsService.trackEvent(event)
        
        // Then
        let savedEvents = analyticsService.getEvents()
        XCTAssertEqual(savedEvents.count, 1)
        let savedEvent = savedEvents.first!
        XCTAssertEqual(savedEvent.name, "coredata_error")
        XCTAssertEqual(savedEvent.parameters["operation"], operation)
        XCTAssertEqual(savedEvent.parameters["error"], error)
        XCTAssertEqual(savedEvent.parameters["page"], "1")
        XCTAssertNotNil(savedEvent.parameters["timestamp"])
    }
    
    func testTrackEventWithProtocol_ShouldSaveBitcoinRateEvent() {
        // Given
        let event = BitcoinRateEventFactory.periodicUpdatesStarted(interval: 120)
        
        // When
        analyticsService.trackEvent(event)
        
        // Then
        let savedEvents = analyticsService.getEvents()
        XCTAssertEqual(savedEvents.count, 1)
        let savedEvent = savedEvents.first!
        XCTAssertEqual(savedEvent.name, "bitcoin_rate_periodic_updates_started")
        XCTAssertEqual(savedEvent.parameters["interval_seconds"], "120.0")
        XCTAssertNotNil(savedEvent.parameters["timestamp"])
    }
    
    func testTrackEventWithProtocol_ShouldSaveBitcoinRateEventWithError() {
        // Given
        let errorMessage = "Network error"
        let event = BitcoinRateEventFactory.onlineFailure(error: errorMessage)
        
        // When
        analyticsService.trackEvent(event)
        
        // Then
        let savedEvents = analyticsService.getEvents()
        XCTAssertEqual(savedEvents.count, 1)
        let savedEvent = savedEvents.first!
        XCTAssertEqual(savedEvent.name, "bitcoin_rate_update_online_failure")
        XCTAssertEqual(savedEvent.parameters["source"], "internet")
        XCTAssertEqual(savedEvent.parameters["error"], errorMessage)
        XCTAssertNotNil(savedEvent.parameters["timestamp"])
    }
    
    func testTrackEventWithProtocol_ShouldHandleCustomBitcoinRateEvent() {
        // Given
        let event = BitcoinRateEvent(
            eventName: "custom_bitcoin_event",
            additionalParameters: [
                "custom_param": "custom_value",
                "rate": "50000.0"
            ]
        )
        
        // When
        analyticsService.trackEvent(event)
        
        // Then
        let savedEvents = analyticsService.getEvents()
        XCTAssertEqual(savedEvents.count, 1)
        let savedEvent = savedEvents.first!
        XCTAssertEqual(savedEvent.name, "custom_bitcoin_event")
        XCTAssertEqual(savedEvent.parameters["custom_param"], "custom_value")
        XCTAssertEqual(savedEvent.parameters["rate"], "50000.0")
        XCTAssertNotNil(savedEvent.parameters["timestamp"])
    }
    
    // MARK: - getEvents() Tests
    
    func testGetEvents_ShouldReturnAllSavedEvents() {
        // Given
        analyticsService.trackEvent(name: "event1", parameters: ["key1": "value1"])
        analyticsService.trackEvent(name: "event2", parameters: ["key2": "value2"])
        
        // When
        let retrievedEvents = analyticsService.getEvents()
        
        // Then
        XCTAssertEqual(retrievedEvents.count, 2)
        XCTAssertEqual(retrievedEvents[1].name, "event1")
        XCTAssertEqual(retrievedEvents[1].parameters, ["key1": "value1"])
        XCTAssertEqual(retrievedEvents[0].name, "event2")
        XCTAssertEqual(retrievedEvents[0].parameters, ["key2": "value2"])
    }
    
    func testGetEvents_ShouldReturnEmptyArrayWhenNoEvents() {
        // Given & When
        let retrievedEvents = analyticsService.getEvents()
        
        // Then
        XCTAssertEqual(retrievedEvents.count, 0)
    }
    
    // MARK: - getEvents(name:fromDate:toDate:) Tests
    
    func testGetEventsWithFilters_ShouldFilterByName() {
        // Given
        analyticsService.trackEvent(name: "event1", parameters: ["key1": "value1"])
        analyticsService.trackEvent(name: "event2", parameters: ["key2": "value2"])
        analyticsService.trackEvent(name: "event1", parameters: ["key3": "value3"])
        
        // When
        let filteredEvents = analyticsService.getEvents(name: "event1", fromDate: nil, toDate: nil)
        
        // Then
        XCTAssertEqual(filteredEvents.count, 2)
        XCTAssertEqual(filteredEvents[0].name, "event1")
        XCTAssertEqual(filteredEvents[1].name, "event1")
    }
    
    func testGetEventsWithFilters_ShouldFilterByDateRange() {
        // Given
        let now = Date()
        let yesterday = now.addingTimeInterval(-24 * 60 * 60)
        let tomorrow = now.addingTimeInterval(24 * 60 * 60)
        
        analyticsService.trackEvent(name: "event1", parameters: ["key1": "value1"])
        
        // When
        let filteredEvents = analyticsService.getEvents(name: nil, fromDate: yesterday, toDate: tomorrow)
        
        // Then
        XCTAssertEqual(filteredEvents.count, 1)
        XCTAssertEqual(filteredEvents[0].name, "event1")
    }
    
    func testGetEventsWithFilters_ShouldFilterByDateRangeAndName() {
        // Given
        let now = Date()
        let yesterday = now.addingTimeInterval(-24 * 60 * 60)
        let tomorrow = now.addingTimeInterval(24 * 60 * 60)
        
        analyticsService.trackEvent(name: "event1", parameters: ["key1": "value1"])
        analyticsService.trackEvent(name: "event2", parameters: ["key2": "value2"])
        
        // When
        let filteredEvents = analyticsService.getEvents(name: "event1", fromDate: yesterday, toDate: tomorrow)
        
        // Then
        XCTAssertEqual(filteredEvents.count, 1)
        XCTAssertEqual(filteredEvents[0].name, "event1")
    }
    
    func testGetEventsWithFilters_ShouldReturnEmptyArrayWhenNoMatches() {
        // Given
        analyticsService.trackEvent(name: "event1", parameters: ["key1": "value1"])
        
        // When
        let filteredEvents = analyticsService.getEvents(name: "nonexistent", fromDate: nil, toDate: nil)
        
        // Then
        XCTAssertEqual(filteredEvents.count, 0)
    }
    
    func testGetEventsWithFilters_ShouldHandleEmptyName() {
        // Given
        analyticsService.trackEvent(name: "event1", parameters: ["key1": "value1"])
        
        // When
        let filteredEvents = analyticsService.getEvents(name: "", fromDate: nil, toDate: nil)
        
        // Then
        XCTAssertEqual(filteredEvents.count, 1)
        XCTAssertEqual(filteredEvents[0].name, "event1")
    }
    
    func testGetEventsWithFilters_ShouldHandleNilParameters() {
        // Given
        analyticsService.trackEvent(name: "event1", parameters: ["key1": "value1"])
        analyticsService.trackEvent(name: "event2", parameters: ["key2": "value2"])
        
        // When
        let filteredEvents = analyticsService.getEvents(name: nil, fromDate: nil, toDate: nil)
        
        // Then
        XCTAssertEqual(filteredEvents.count, 2)
    }
    
    func testGetEventsWithFilters_ShouldFilterByFromDateOnly() {
        // Given
        let now = Date()
        let oneHourAgo = now.addingTimeInterval(-60 * 60)
        
        analyticsService.trackEvent(name: "event1", parameters: ["key1": "value1"])
        
        // When
        let filteredEvents = analyticsService.getEvents(name: nil, fromDate: oneHourAgo, toDate: nil)
        
        // Then
        XCTAssertEqual(filteredEvents.count, 1)
        XCTAssertEqual(filteredEvents[0].name, "event1")
    }
    
    func testGetEventsWithFilters_ShouldFilterByToDateOnly() {
        // Given
        let now = Date()
        let oneHourFromNow = now.addingTimeInterval(60 * 60)
        
        analyticsService.trackEvent(name: "event1", parameters: ["key1": "value1"])
        
        // When
        let filteredEvents = analyticsService.getEvents(name: nil, fromDate: nil, toDate: oneHourFromNow)
        
        // Then
        XCTAssertEqual(filteredEvents.count, 1)
        XCTAssertEqual(filteredEvents[0].name, "event1")
    }
    
    func testGetEventsWithFilters_ShouldReturnEmptyArrayWhenDateRangeExcludesAllEvents() {
        // Given
        let now = Date()
        let oneHourAgo = now.addingTimeInterval(-60 * 60)
        let twoHoursAgo = now.addingTimeInterval(-2 * 60 * 60)
        
        analyticsService.trackEvent(name: "event1", parameters: ["key1": "value1"])
        
        // When
        let filteredEvents = analyticsService.getEvents(name: nil, fromDate: twoHoursAgo, toDate: oneHourAgo)
        
        // Then
        XCTAssertEqual(filteredEvents.count, 0)
    }
    
    // MARK: - clearEvents() Tests
    
    func testClearEvents_ShouldRemoveAllEvents() {
        // Given
        analyticsService.trackEvent(name: "event1", parameters: ["key1": "value1"])
        analyticsService.trackEvent(name: "event2", parameters: ["key2": "value2"])
        
        // When
        analyticsService.clearEvents()
        
        // Then
        let events = analyticsService.getEvents()
        XCTAssertEqual(events.count, 0)
    }
    
    func testClearEvents_ShouldHandleEmptyStorage() {
        // Given & When
        analyticsService.clearEvents()
        
        // Then
        let events = analyticsService.getEvents()
        XCTAssertEqual(events.count, 0)
    }
    
    // MARK: - Thread Safety Tests
    
    func testTrackEvent_ShouldBeThreadSafe() {
        // Given
        let expectation = XCTestExpectation(description: "All events tracked")
        let eventCount = 100
        expectation.expectedFulfillmentCount = eventCount
        
        // When
        DispatchQueue.concurrentPerform(iterations: eventCount) { index in
            self.analyticsService.trackEvent(
                name: "concurrent_event_\(index)",
                parameters: ["index": "\(index)"]
            )
            expectation.fulfill()
        }
        
        // Then
        wait(for: [expectation], timeout: 5.0)
        
        let events = analyticsService.getEvents()
        XCTAssertEqual(events.count, eventCount)
    }
    
    // MARK: - Integration Tests
    
    func testFullWorkflow_ShouldWorkCorrectly() {
        // Given
        let eventName = "workflow_test"
        let parameters = ["step": "1"]
        let coreDataEvent = CoreDataErrorEvent(operation: "test_operation", error: "test_error")
        let bitcoinEvent = BitcoinRateEventFactory.onlineSuccess()
        
        // When
        analyticsService.trackEvent(name: eventName, parameters: parameters)
        analyticsService.trackEvent(coreDataEvent)
        analyticsService.trackEvent(bitcoinEvent)
        
        let allEvents = analyticsService.getEvents()
        
        analyticsService.clearEvents()
        
        let eventsAfterClear = analyticsService.getEvents()
        
        // Then
        XCTAssertEqual(allEvents.count, 3)
        XCTAssertEqual(eventsAfterClear.count, 0)
    }
    
    // MARK: - Edge Cases Tests
    
    func testTrackEventWithNilValues_ShouldHandleCorrectly() {
        // Given
        let eventName = "nil_values_event"
        let parameters = [
            "nil_key": "",
            "empty_key": "",
            "valid_key": "valid_value"
        ]
        
        // When
        analyticsService.trackEvent(name: eventName, parameters: parameters)
        
        // Then
        let savedEvents = analyticsService.getEvents()
        XCTAssertEqual(savedEvents.count, 1)
        let savedEvent = savedEvents.first!
        XCTAssertEqual(savedEvent.name, eventName)
        XCTAssertEqual(savedEvent.parameters, parameters)
    }
    
    // MARK: - Max Events Limit Tests
    
    func testTrackEvent_ShouldRespectMaxEventsLimit() {
        // Given
        let maxEvents = 100
        
        // When
        for i in 0..<maxEvents {
            analyticsService.trackEvent(
                name: "event_\(i)",
                parameters: ["index": "\(i)"]
            )
        }
        
        // Then
        let events = analyticsService.getEvents()
        XCTAssertLessThanOrEqual(events.count, maxEvents)
    }
}
