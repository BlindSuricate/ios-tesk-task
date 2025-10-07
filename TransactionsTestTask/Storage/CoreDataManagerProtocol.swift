//
//  CoreDataManagerProtocol.swift
//  TransactionsTestTask
//
//  Created by CodingMeerkat on 06.10.2025.
//

import Foundation
import CoreData

// MARK: - Core Data Manager Protocol
protocol CoreDataManagerProtocol: AnyObject {
    
    // MARK: - Core Data Properties
    var persistentContainer: NSPersistentContainer { get }
    var context: NSManagedObjectContext { get }
    
    // MARK: - Core Data Saving Support
    func saveContext()
    
    // MARK: - Transaction Operations
    func saveTransaction(_ transaction: Transaction)
    func fetchTransactions() -> [Transaction]
    func fetchTransactions(page: Int, pageSize: Int) -> [Transaction]
    func getTotalTransactionsCount() -> Int
    func deleteTransaction(withId id: UUID)
    func clearAllTransactions()
    
    // MARK: - Rate Operations
    func saveRate(_ rate: Rate)
    func fetchRates() -> [Rate]
    func fetchLatestRate() -> Rate?
    func deleteRate(withId id: UUID)
    func clearAllRates()
    
    // MARK: - Current Balance Operations
    func saveCurrentBalance(_ balance: CurrentBalance)
    func getCurrentBalance() -> CurrentBalance?
    func updateCurrentBalance(by amount: Double)
    func clearCurrentBalance()
}
