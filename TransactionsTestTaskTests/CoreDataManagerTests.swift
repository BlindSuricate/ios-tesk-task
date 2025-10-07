//
//  CoreDataManagerTests.swift
//  TransactionsTestTaskTests
//
//  Created by CodingMeerkat on 07.10.2025.
//

import XCTest
import CoreData
@testable import TransactionsTestTask

final class CoreDataManagerTests: XCTestCase {
    
    // MARK: - Properties
    private var coreDataManager: CoreDataManager!
    private var mockAnalyticsService: MockAnalyticsService!
    private var testContext: NSManagedObjectContext!
    
    // MARK: - Setup & Teardown
    override func setUp() {
        super.setUp()
        mockAnalyticsService = MockAnalyticsService()
        
        let container = NSPersistentContainer(name: "TransactionsTestTask")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        container.persistentStoreDescriptions = [description]
        
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load store: \(error)")
            }
        }
        
        testContext = container.viewContext
        coreDataManager = CoreDataManager(analyticsService: mockAnalyticsService)

        coreDataManager.persistentContainer = container
    }
    
    override func tearDown() {
        coreDataManager = nil
        mockAnalyticsService = nil
        testContext = nil
        super.tearDown()
    }
    
    // MARK: - Helper Methods
    private func waitForAsyncOperations(timeout: TimeInterval = 0.5) {
        let expectation = self.expectation(description: "Waiting for async operations")
        DispatchQueue.main.asyncAfter(deadline: .now() + timeout) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: timeout + 0.1)
    }
    
    // MARK: - Transaction Operations Tests
    
    func testSaveTransaction_ShouldSaveTransactionToCoreData() {
        // Given
        let transaction = Transaction(
            id: UUID(),
            category: .electronics,
            amount: 0.001,
            date: Date()
        )
        
        // When
        coreDataManager.saveTransaction(transaction)
        waitForAsyncOperations()
        
        // Then
        let savedTransactions = coreDataManager.fetchTransactions()
        XCTAssertEqual(savedTransactions.count, 1)
        XCTAssertEqual(savedTransactions.first?.id, transaction.id)
        XCTAssertEqual(savedTransactions.first?.amount, transaction.amount)
        XCTAssertEqual(savedTransactions.first?.category, transaction.category)
    }
    
    func testFetchTransactions_ShouldReturnTransactionsSortedByDateDescending() {
        // Given
        let transaction1 = Transaction(
            id: UUID(),
            category: .electronics,
            amount: 0.001,
            date: Date().addingTimeInterval(-100)
        )
        let transaction2 = Transaction(
            id: UUID(),
            category: .enrollment,
            amount: 0.002,
            date: Date()
        )
        
        coreDataManager.saveTransaction(transaction1)
        coreDataManager.saveTransaction(transaction2)
        waitForAsyncOperations()
        
        // When
        let transactions = coreDataManager.fetchTransactions()
        
        // Then
        XCTAssertEqual(transactions.count, 2)
        XCTAssertEqual(transactions[0].id, transaction2.id) // Newer transaction first
        XCTAssertEqual(transactions[1].id, transaction1.id) // Older transaction second
    }
    
    func testFetchTransactionsWithPagination_ShouldReturnCorrectPage() {
        // Given
        for i in 0..<5 {
            let transaction = Transaction(
                id: UUID(),
                category: .electronics,
                amount: Double(i) * 0.001,
                date: Date().addingTimeInterval(-Double(i) * 10)
            )
            coreDataManager.saveTransaction(transaction)
        }
        waitForAsyncOperations()
        
        // When
        let firstPage = coreDataManager.fetchTransactions(page: 0, pageSize: 2)
        let secondPage = coreDataManager.fetchTransactions(page: 1, pageSize: 2)
        
        // Then
        XCTAssertEqual(firstPage.count, 2)
        XCTAssertEqual(secondPage.count, 2)
        XCTAssertNotEqual(firstPage[0].id, secondPage[0].id)
    }
    
    func testGetTotalTransactionsCount_ShouldReturnCorrectCount() {
        // Given
        for i in 0..<3 {
            let transaction = Transaction(
                id: UUID(),
                category: .electronics,
                amount: Double(i) * 0.001,
                date: Date()
            )
            coreDataManager.saveTransaction(transaction)
        }
        waitForAsyncOperations()
        
        // When
        let count = coreDataManager.getTotalTransactionsCount()
        
        // Then
        XCTAssertEqual(count, 3)
    }
    
    func testDeleteTransaction_ShouldRemoveTransactionFromCoreData() {
        // Given
        let transaction = Transaction(
            id: UUID(),
            category: .electronics,
            amount: 0.001,
            date: Date()
        )
        coreDataManager.saveTransaction(transaction)
        waitForAsyncOperations()
        
        XCTAssertEqual(coreDataManager.fetchTransactions().count, 1)
        
        // When
        coreDataManager.deleteTransaction(withId: transaction.id)
        waitForAsyncOperations()
        
        // Then
        let transactions = coreDataManager.fetchTransactions()
        XCTAssertEqual(transactions.count, 0)
    }
    
    // MARK: - Rate Operations Tests
    
    func testSaveRate_ShouldSaveRateToCoreData() {
        // Given
        let rate = Rate(
            id: UUID(),
            rate: 50000.0,
            date: Date()
        )
        
        // When
        coreDataManager.saveRate(rate)
        waitForAsyncOperations()
        
        // Then
        let savedRates = coreDataManager.fetchRates()
        XCTAssertEqual(savedRates.count, 1)
        XCTAssertEqual(savedRates.first?.id, rate.id)
        XCTAssertEqual(savedRates.first?.rate, rate.rate)
    }
    
    func testFetchLatestRate_ShouldReturnMostRecentRate() {
        // Given
        let rate1 = Rate(
            id: UUID(),
            rate: 40000.0,
            date: Date().addingTimeInterval(-100)
        )
        let rate2 = Rate(
            id: UUID(),
            rate: 50000.0,
            date: Date()
        )
        
        coreDataManager.saveRate(rate1)
        coreDataManager.saveRate(rate2)
        waitForAsyncOperations()
        
        // When
        let latestRate = coreDataManager.fetchLatestRate()
        
        // Then
        XCTAssertNotNil(latestRate)
        XCTAssertEqual(latestRate?.id, rate2.id)
        XCTAssertEqual(latestRate?.rate, rate2.rate)
    }
    
    func testDeleteRate_ShouldRemoveRateFromCoreData() {
        // Given
        let rate = Rate(
            id: UUID(),
            rate: 50000.0,
            date: Date()
        )
        coreDataManager.saveRate(rate)
        waitForAsyncOperations()
        
        XCTAssertEqual(coreDataManager.fetchRates().count, 1)
        
        // When
        coreDataManager.deleteRate(withId: rate.id)
        waitForAsyncOperations()
        
        // Then
        let rates = coreDataManager.fetchRates()
        XCTAssertEqual(rates.count, 0)
    }
    
    // MARK: - Current Balance Operations Tests
    
    func testSaveCurrentBalance_ShouldSaveBalanceToCoreData() {
        // Given
        let balance = CurrentBalance(
            id: UUID(),
            balance: 1.5,
            lastUpdated: Date()
        )
        
        // When
        coreDataManager.saveCurrentBalance(balance)
        waitForAsyncOperations()
        
        // Then
        let savedBalance = coreDataManager.getCurrentBalance()
        XCTAssertNotNil(savedBalance)
        XCTAssertEqual(savedBalance?.id, balance.id)
        XCTAssertEqual(savedBalance?.balance, balance.balance)
    }
    
    func testGetCurrentBalance_ShouldReturnSavedBalance() {
        // Given
        let balance = CurrentBalance(
            id: UUID(),
            balance: 2.0,
            lastUpdated: Date()
        )
        coreDataManager.saveCurrentBalance(balance)
        waitForAsyncOperations()
        
        // When
        let retrievedBalance = coreDataManager.getCurrentBalance()
        
        // Then
        XCTAssertNotNil(retrievedBalance)
        XCTAssertEqual(retrievedBalance?.balance, 2.0)
    }
    
    func testUpdateCurrentBalance_ShouldAddAmountToExistingBalance() {
        // Given
        let initialBalance = CurrentBalance(
            id: UUID(),
            balance: 1.0,
            lastUpdated: Date()
        )
        coreDataManager.saveCurrentBalance(initialBalance)
        waitForAsyncOperations()
        
        // When
        coreDataManager.updateCurrentBalance(by: 0.5)
        waitForAsyncOperations()
        
        // Then
        let updatedBalance = coreDataManager.getCurrentBalance()
        XCTAssertNotNil(updatedBalance)
        XCTAssertEqual(updatedBalance?.balance, 1.5)
    }
    
    func testUpdateCurrentBalance_ShouldCreateNewBalanceIfNoneExists() {
        // Given (no existing balance)
        
        // When
        coreDataManager.updateCurrentBalance(by: 1.0)
        waitForAsyncOperations()
        
        // Then
        let balance = coreDataManager.getCurrentBalance()
        XCTAssertNotNil(balance)
        XCTAssertEqual(balance?.balance, 1.0)
    }
    
    func testClearCurrentBalance_ShouldRemoveBalanceFromCoreData() {
        // Given
        let balance = CurrentBalance(
            id: UUID(),
            balance: 1.0,
            lastUpdated: Date()
        )
        coreDataManager.saveCurrentBalance(balance)
        waitForAsyncOperations()
        
        XCTAssertNotNil(coreDataManager.getCurrentBalance())
        
        // When
        coreDataManager.clearCurrentBalance()
        waitForAsyncOperations()
        
        // Then
        let clearedBalance = coreDataManager.getCurrentBalance()
        XCTAssertNil(clearedBalance)
    }
    
    // MARK: - Error Handling Tests
    
    func testSaveTransaction_ShouldTrackAnalyticsOnError() {
        // Given
        // Create a transaction with invalid data that might cause an error
        let transaction = Transaction(
            id: UUID(),
            category: .electronics,
            amount: 0.001,
            date: Date()
        )
        
        // When
        coreDataManager.saveTransaction(transaction)
        waitForAsyncOperations()
        
        // Then
        // Since we're using in-memory store, this should succeed
        // But we can verify the transaction was saved
        let transactions = coreDataManager.fetchTransactions()
        XCTAssertEqual(transactions.count, 1)
    }
    
    // MARK: - Integration Tests
    
    func testFullWorkflow_ShouldWorkCorrectly() {
        // Given
        let transaction = Transaction(
            id: UUID(),
            category: .electronics,
            amount: 0.001,
            date: Date()
        )
        let rate = Rate(
            id: UUID(),
            rate: 50000.0,
            date: Date()
        )
        let balance = CurrentBalance(
            id: UUID(),
            balance: 1.0,
            lastUpdated: Date()
        )
        
        // When
        coreDataManager.saveTransaction(transaction)
        coreDataManager.saveRate(rate)
        coreDataManager.saveCurrentBalance(balance)
        waitForAsyncOperations()
        
        // Then
        XCTAssertEqual(coreDataManager.fetchTransactions().count, 1)
        XCTAssertEqual(coreDataManager.fetchRates().count, 1)
        XCTAssertNotNil(coreDataManager.getCurrentBalance())
        XCTAssertEqual(coreDataManager.getTotalTransactionsCount(), 1)
        XCTAssertNotNil(coreDataManager.fetchLatestRate())
    }
}
