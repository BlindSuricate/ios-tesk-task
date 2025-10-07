//
//  CoreDataManager.swift
//  TransactionsTestTask
//
//  Created by CodingMeerkat on 06.10.2025.
//

import Foundation
import CoreData

// MARK: - Core Data Manager
final class CoreDataManager {
    
    // MARK: - Properties
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TransactionsTestTask")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    private let analyticsService: AnalyticsService
    
    // MARK: - Initialization
    init(analyticsService: AnalyticsService) {
        self.analyticsService = analyticsService
    }
    
    // MARK: - Core Data Saving Support
    func saveContext() {
        let context = persistentContainer.viewContext
        
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

// MARK: - Transaction Operations
extension CoreDataManager {
    
    func saveTransaction(_ transaction: Transaction) {
        let entity = TransactionEntity(context: context)
        entity.id = transaction.id
        entity.amount = transaction.amount
        entity.category = transaction.category.rawValue
        entity.date = transaction.date
        
        saveContext()
    }
    
    func fetchTransactions() -> [Transaction] {
        let request: NSFetchRequest<TransactionEntity> = TransactionEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        
        do {
            let entities = try context.fetch(request)
            return entities.compactMap { entity in
                guard let category = TransactionCategory(rawValue: entity.category ?? "") else {
                    return nil
                }
                return Transaction(
                    id: entity.id ?? UUID(),
                    category: category,
                    amount: entity.amount,
                    date: entity.date ?? Date()
                )
            }
        } catch {
            let event = CoreDataErrorEvent(error: "\(error)")
            analyticsService.trackEvent(event)
            return []
        }
    }
    
    func fetchTransactions(page: Int, pageSize: Int) -> [Transaction] {
        let request: NSFetchRequest<TransactionEntity> = TransactionEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        request.fetchOffset = page * pageSize
        request.fetchLimit = pageSize
        
        do {
            let entities = try context.fetch(request)
            return entities.compactMap { entity in
                guard let category = TransactionCategory(rawValue: entity.category ?? "") else {
                    return nil
                }
                return Transaction(
                    id: entity.id ?? UUID(),
                    category: category,
                    amount: entity.amount,
                    date: entity.date ?? Date()
                )
            }
        } catch {
            let event = CoreDataErrorEvent(
                operation: "fetchTransactions_page", 
                error: "\(error)",
                additionalParameters: ["page": "\(page)"]
            )
            analyticsService.trackEvent(event)
            return []
        }
    }
    
    func getTotalTransactionsCount() -> Int {
        let request: NSFetchRequest<TransactionEntity> = TransactionEntity.fetchRequest()
        
        do {
            return try context.count(for: request)
        } catch {
            let event = CoreDataErrorEvent(error: "\(error)")
            analyticsService.trackEvent(event)
            return 0
        }
    }
    
    func deleteTransaction(withId id: UUID) {
        let request: NSFetchRequest<TransactionEntity> = TransactionEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        do {
            let entities = try context.fetch(request)
            for entity in entities {
                context.delete(entity)
            }
            saveContext()
        } catch {
            let event = CoreDataErrorEvent(
                error: "\(error)",
                additionalParameters: ["transaction_id": "\(id)"]
            )
            analyticsService.trackEvent(event)
        }
    }
    
    func clearAllTransactions() {
        let request: NSFetchRequest<NSFetchRequestResult> = TransactionEntity.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        
        do {
            try context.execute(deleteRequest)
            saveContext()
        } catch {
            let event = CoreDataErrorEvent(error: "\(error)")
            analyticsService.trackEvent(event)
        }
    }
}

// MARK: - Rate Operations
extension CoreDataManager {
    
    func saveRate(_ rate: Rate) {
        let entity = RateEntity(context: context)
        entity.id = rate.id
        entity.rate = rate.rate
        entity.date = rate.date
        
        saveContext()
    }
    
    func fetchRates() -> [Rate] {
        let request: NSFetchRequest<RateEntity> = RateEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        
        do {
            let entities = try context.fetch(request)
            return entities.compactMap { entity in
                Rate(
                    id: entity.id ?? UUID(),
                    rate: entity.rate,
                    date: entity.date ?? Date()
                )
            }
        } catch {
            let event = CoreDataErrorEvent(error: "\(error)")
            analyticsService.trackEvent(event)
            return []
        }
    }
    
    func fetchLatestRate() -> Rate? {
        let request: NSFetchRequest<RateEntity> = RateEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        request.fetchLimit = 1
        
        do {
            let entities = try context.fetch(request)
            guard let entity = entities.first else { return nil }
            
            return Rate(
                id: entity.id ?? UUID(),
                rate: entity.rate,
                date: entity.date ?? Date()
            )
        } catch {
            let event = CoreDataErrorEvent(error: "\(error)")
            analyticsService.trackEvent(event)
            return nil
        }
    }
    
    func deleteRate(withId id: UUID) {
        let request: NSFetchRequest<RateEntity> = RateEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        do {
            let entities = try context.fetch(request)
            for entity in entities {
                context.delete(entity)
            }
            saveContext()
        } catch {
            let event = CoreDataErrorEvent(
                error: "\(error)",
                additionalParameters: ["rate_id": "\(id)"]
            )
            analyticsService.trackEvent(event)
        }
    }
    
    func clearAllRates() {
        let request: NSFetchRequest<NSFetchRequestResult> = RateEntity.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        
        do {
            try context.execute(deleteRequest)
            saveContext()
        } catch {
            let event = CoreDataErrorEvent(error: "\(error)")
            analyticsService.trackEvent(event)
        }
    }
}

// MARK: - Current Balance Operations
extension CoreDataManager {
    
    func saveCurrentBalance(_ balance: CurrentBalance) {
        clearCurrentBalance()
        
        let balanceEntity = CurrentBalanceEntity(context: context)
        balanceEntity.id = balance.id
        balanceEntity.balance = balance.balance
        balanceEntity.lastUpdated = balance.lastUpdated
        
        saveContext()
    }
    
    func getCurrentBalance() -> CurrentBalance? {
        let request: NSFetchRequest<CurrentBalanceEntity> = CurrentBalanceEntity.fetchRequest()
        
        do {
            let results = try context.fetch(request)
            if let balanceEntity = results.first {
                return CurrentBalance(
                    id: balanceEntity.id ?? UUID(),
                    balance: balanceEntity.balance,
                    lastUpdated: balanceEntity.lastUpdated ?? Date()
                )
            }
        } catch {
            let event = CoreDataErrorEvent(error: "\(error)")
            analyticsService.trackEvent(event)
        }
        
        return nil
    }
    
    func updateCurrentBalance(by amount: Double) {
        let request: NSFetchRequest<CurrentBalanceEntity> = CurrentBalanceEntity.fetchRequest()
        
        do {
            let results = try context.fetch(request)
            if let balanceEntity = results.first {
                balanceEntity.balance += amount
                balanceEntity.lastUpdated = Date()
            } else {
                let balanceEntity = CurrentBalanceEntity(context: context)
                balanceEntity.id = UUID()
                balanceEntity.balance = amount
                balanceEntity.lastUpdated = Date()
            }
            saveContext()
        } catch {
            let event = CoreDataErrorEvent(
                error: "\(error)",
                additionalParameters: ["amount": "\(amount)"]
            )
            analyticsService.trackEvent(event)
        }
    }
    
    func clearCurrentBalance() {
        let request: NSFetchRequest<CurrentBalanceEntity> = CurrentBalanceEntity.fetchRequest()
        
        do {
            let results = try context.fetch(request)
            for balanceEntity in results {
                context.delete(balanceEntity)
            }
            saveContext()
        } catch {
            let event = CoreDataErrorEvent(error: "\(error)")
            analyticsService.trackEvent(event)
        }
    }
}
