//
//  MockCoreDataManager.swift
//  TransactionsTestTaskTests
//
//  Created by CodingMeerkat on 08.10.2025.
//

import Foundation
import CoreData
@testable import TransactionsTestTask

class MockCoreDataManager: CoreDataManagerProtocol {
    var mockLatestRate: Rate?
    var shouldThrowError = false
    var fetchLatestRateCalled = false
    
    // MARK: - Core Data Properties
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TransactionsTestTask")
        return container
    }()
    
    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    // MARK: - Core Data Saving Support
    func saveContext() { }
    
    // MARK: - Transaction Operations
    func saveTransaction(_ transaction: Transaction) {
        // Mock implementation
    }
    
    func fetchTransactions() -> [Transaction] {
        return []
    }
    
    func fetchTransactions(page: Int, pageSize: Int) -> [Transaction] {
        return []
    }
    
    func getTotalTransactionsCount() -> Int {
        return 0
    }
    
    func deleteTransaction(withId id: UUID) { }
    
    func clearAllTransactions() { }
    
    // MARK: - Rate Operations
    func saveRate(_ rate: Rate) { }
    
    func fetchRates() -> [Rate] {
        return []
    }
    
    func fetchLatestRate() -> Rate? {
        fetchLatestRateCalled = true
        
        if shouldThrowError {
            return nil
        }
        
        return mockLatestRate
    }
    
    func deleteRate(withId id: UUID) { }
    
    func clearAllRates() { }
    
    // MARK: - Current Balance Operations
    func saveCurrentBalance(_ balance: CurrentBalance) { }
    
    func getCurrentBalance() -> CurrentBalance? {
        return nil
    }
    
    func updateCurrentBalance(by amount: Double) { }
    
    func clearCurrentBalance() { }
}
