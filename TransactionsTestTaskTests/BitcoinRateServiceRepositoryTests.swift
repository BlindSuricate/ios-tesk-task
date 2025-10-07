//
//  BitcoinRateServiceRepositoryTests.swift
//  TransactionsTestTaskTests
//
//  Created by CodingMeerkat on 06.10.2025.
//

import XCTest
import CoreData
@testable import TransactionsTestTask

final class BitcoinRateServiceRepositoryTests: XCTestCase {
    
    // MARK: - Properties
    private var bitcoinRateServiceRepository: BitcoinRateServiceRepository!
    private var mockBitcoinRateService: MockBitcoinRateService!
    private var mockCoreDataManager: MockCoreDataManager!
    private var mockAnalyticsService: MockAnalyticsService!
    private var mockNetworkMonitor: MockNetworkMonitor!
    
    // MARK: - Setup & Teardown
    override func setUp() {
        super.setUp()
        mockBitcoinRateService = MockBitcoinRateService()
        mockAnalyticsService = MockAnalyticsService()
        mockCoreDataManager = MockCoreDataManager()
        mockNetworkMonitor = MockNetworkMonitor()
        
        bitcoinRateServiceRepository = BitcoinRateServiceRepository(
            bitcoinRateService: mockBitcoinRateService,
            coreDataManager: mockCoreDataManager,
            networkMonitor: mockNetworkMonitor,
            analyticsService: mockAnalyticsService
        )
    }
    
    override func tearDown() {
        bitcoinRateServiceRepository = nil
        mockBitcoinRateService = nil
        mockCoreDataManager = nil
        mockAnalyticsService = nil
        mockNetworkMonitor = nil
        super.tearDown()
    }
    
    // MARK: - startPeriodicUpdates Tests
    
    func testStartPeriodicUpdates_ShouldStartTimerAndTrackAnalytics() {
        // Given
        let expectation = XCTestExpectation(description: "Analytics tracked")
        
        // When
        bitcoinRateServiceRepository.startPeriodicUpdates()
        
        // Then
        XCTAssertTrue(mockAnalyticsService.trackedEvents.contains { event in
            event.eventName == "bitcoin_rate_periodic_updates_started" &&
            event.parameters["interval_seconds"] == "120.0"
        })
        expectation.fulfill()
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testStartPeriodicUpdates_ShouldStopExistingTimer() {
        // Given
        bitcoinRateServiceRepository.startPeriodicUpdates()
        
        // When
        bitcoinRateServiceRepository.startPeriodicUpdates()
        
        // Then
        // Should not crash and should track analytics twice
        let startEvents = mockAnalyticsService.trackedEvents.filter { 
            $0.eventName == "bitcoin_rate_periodic_updates_started" 
        }
        XCTAssertEqual(startEvents.count, 2)
    }
    
    func testStartPeriodicUpdates_ShouldGetInitialRateFromAvailableSource() {
        // Given
        mockBitcoinRateService.shouldSucceed = true
        mockBitcoinRateService.mockRate = 50000.0
        
        // When
        bitcoinRateServiceRepository.startPeriodicUpdates()
        
        // Then
        XCTAssertTrue(mockBitcoinRateService.getBitcoinRateCalled)
    }
    
    // MARK: - stopPeriodicUpdates Tests
    
    func testStopPeriodicUpdates_ShouldStopTimerAndTrackAnalytics() {
        // Given
        bitcoinRateServiceRepository.startPeriodicUpdates()
        
        // When
        bitcoinRateServiceRepository.stopPeriodicUpdates()
        
        // Then
        XCTAssertTrue(mockAnalyticsService.trackedEvents.contains { event in
            event.eventName == "bitcoin_rate_periodic_updates_stopped"
        })
    }
    
    func testStopPeriodicUpdates_ShouldHandleWhenNoTimerRunning() {
        // Given & When
        bitcoinRateServiceRepository.stopPeriodicUpdates()
        
        // Then
        // Should not crash
        XCTAssertTrue(mockAnalyticsService.trackedEvents.isEmpty)
    }
    
    // MARK: - getCurrentRate Tests
    
    func testGetCurrentRate_ShouldReturnRateFromCoreData() {
        // Given
        let expectedRate = 45000.0
        let mockRate = Rate(id: UUID(), rate: expectedRate, date: Date())
        mockCoreDataManager.mockLatestRate = mockRate
        
        // When
        let currentRate = bitcoinRateServiceRepository.getCurrentRate()
        
        // Then
        XCTAssertEqual(currentRate, expectedRate)
        XCTAssertTrue(mockCoreDataManager.fetchLatestRateCalled)
    }
    
    func testGetCurrentRate_ShouldReturnNilWhenNoRateInCoreData() {
        // Given
        mockCoreDataManager.mockLatestRate = nil
        
        // When
        let currentRate = bitcoinRateServiceRepository.getCurrentRate()
        
        // Then
        XCTAssertNil(currentRate)
        XCTAssertTrue(mockCoreDataManager.fetchLatestRateCalled)
    }
    
    // MARK: - forceUpdate Tests
    
    func testForceUpdate_ShouldTrackAnalyticsAndGetCurrentRate() {
        // Given
        mockBitcoinRateService.shouldSucceed = true
        mockBitcoinRateService.mockRate = 50000.0
        
        // When
        bitcoinRateServiceRepository.forceUpdate()
        
        // Then
        XCTAssertTrue(mockAnalyticsService.trackedEvents.contains { event in
            event.eventName == "bitcoin_rate_force_update"
        })
        XCTAssertTrue(mockBitcoinRateService.getBitcoinRateCalled)
    }
    
    // MARK: - Rate Update Callback Tests
    
    func testOnRateUpdate_ShouldBeCalledWhenRateIsUpdated() {
        // Given
        var receivedRate: Double?
        mockBitcoinRateService.mockRate = 45000.0
        bitcoinRateServiceRepository.onRateUpdate = { rate in
            receivedRate = rate
        }
        
        let mockRate = Rate(id: UUID(), rate: 45000.0, date: Date())
        mockCoreDataManager.mockLatestRate = mockRate
        
        // When
        bitcoinRateServiceRepository.startPeriodicUpdates()
        
        // Then
        XCTAssertEqual(receivedRate, 45000.0)
    }
    
    // MARK: - Integration Tests
    
    func testFullWorkflow_ShouldWorkCorrectly() {
        // Given
        var receivedRates: [Double] = []
        bitcoinRateServiceRepository.onRateUpdate = { rate in
            receivedRates.append(rate)
        }
        
        mockBitcoinRateService.shouldSucceed = true
        mockBitcoinRateService.mockRate = 50000.0
        
        // When
        bitcoinRateServiceRepository.startPeriodicUpdates()
        bitcoinRateServiceRepository.forceUpdate()
        bitcoinRateServiceRepository.stopPeriodicUpdates()
        
        // Then
        XCTAssertTrue(mockAnalyticsService.trackedEvents.contains { $0.eventName == "bitcoin_rate_periodic_updates_started" })
        XCTAssertTrue(mockAnalyticsService.trackedEvents.contains { $0.eventName == "bitcoin_rate_force_update" })
        XCTAssertTrue(mockAnalyticsService.trackedEvents.contains { $0.eventName == "bitcoin_rate_periodic_updates_stopped" })
        XCTAssertTrue(mockBitcoinRateService.getBitcoinRateCalled)
    }
    
    // MARK: - Edge Cases Tests
    
    func testStartPeriodicUpdates_ShouldHandleMultipleCalls() {
        // Given & When
        bitcoinRateServiceRepository.startPeriodicUpdates()
        bitcoinRateServiceRepository.startPeriodicUpdates()
        bitcoinRateServiceRepository.startPeriodicUpdates()
        
        // Then
        // Should not crash and should track analytics for each start
        let startEvents = mockAnalyticsService.trackedEvents.filter { 
            $0.eventName == "bitcoin_rate_periodic_updates_started" 
        }
        XCTAssertEqual(startEvents.count, 3)
    }
    
    func testStopPeriodicUpdates_ShouldHandleMultipleCalls() {
        // Given
        bitcoinRateServiceRepository.startPeriodicUpdates()
        
        // When
        bitcoinRateServiceRepository.stopPeriodicUpdates()
        bitcoinRateServiceRepository.stopPeriodicUpdates()
        bitcoinRateServiceRepository.stopPeriodicUpdates()
        
        // Then
        // Should not crash
        let stopEvents = mockAnalyticsService.trackedEvents.filter { 
            $0.eventName == "bitcoin_rate_periodic_updates_stopped" 
        }
        XCTAssertEqual(stopEvents.count, 1)
    }
    
    func testGetCurrentRate_ShouldHandleCoreDataError() {
        // Given
        mockCoreDataManager.shouldThrowError = true
        
        // When
        let currentRate = bitcoinRateServiceRepository.getCurrentRate()
        
        // Then
        XCTAssertNil(currentRate)
        XCTAssertTrue(mockCoreDataManager.fetchLatestRateCalled)
    }
}
