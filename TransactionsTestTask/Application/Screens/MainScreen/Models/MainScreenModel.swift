//
//  MainScreenModel.swift
//  TransactionsTestTask
//
//  Created by CodingMeerkat on 06.10.2025.
//

import Foundation

final class MainScreenModel {
    let coreDataManager: CoreDataManagerProtocol
    private let pageSize: Int = 20
    
    // Pagination state
    private var currentPage: Int = 0
    private var loadedTransactions: [Transaction] = []
    private var totalItems: Int = 0
    private var isLoading: Bool = false
    
    init(coreDataManager: CoreDataManagerProtocol) {
        self.coreDataManager = coreDataManager
        self.totalItems = coreDataManager.getTotalTransactionsCount()
    }
}

// MARK: - MainScreenModelProtocol
extension MainScreenModel: MainScreenModelProtocol {
    func getTransactions() -> [Transaction] {
        loadedTransactions
    }
    
    func getTransactionSections() -> [TransactionSection] {
        TransactionGrouper.groupTransactions(loadedTransactions)
    }
    
    func loadFirstPage() {
        guard !isLoading else { return }
        isLoading = true
        
        currentPage = 0
        loadedTransactions = coreDataManager.fetchTransactions(page: currentPage, pageSize: pageSize)
        totalItems = coreDataManager.getTotalTransactionsCount()
        isLoading = false
    }
    
    func loadNextPage() -> Bool {
        guard !isLoading else { return false }
        guard hasMorePages() else { return false }
        
        isLoading = true
        
        currentPage += 1
        let newTransactions = coreDataManager.fetchTransactions(page: currentPage, pageSize: pageSize)
        loadedTransactions.append(contentsOf: newTransactions)
        
        isLoading = false
        return true
    }
    
    func refreshTransactions() {
        guard !isLoading else { return }
        isLoading = true
        
        currentPage = 0
        loadedTransactions = coreDataManager.fetchTransactions(page: currentPage, pageSize: pageSize)
        totalItems = coreDataManager.getTotalTransactionsCount()
        
        isLoading = false
    }
    
    func getPaginationInfo() -> PaginationInfo {
        let hasMore = hasMorePages()
        return PaginationInfo(
            currentPage: currentPage,
            pageSize: pageSize,
            totalItems: totalItems,
            hasMorePages: hasMore
        )
    }
    
    func addTransaction(_ transaction: Transaction) {
        coreDataManager.saveTransaction(transaction)
        totalItems = coreDataManager.getTotalTransactionsCount()
        refreshTransactions()
    }
    
    
    func removeTransaction(sectionIndex: Int, itemIndex: Int) {
        let sections = getTransactionSections()
        guard sectionIndex < sections.count else { return }
        let section = sections[sectionIndex]
        guard itemIndex < section.transactions.count else { return }
        let transaction = section.transactions[itemIndex]
        coreDataManager.deleteTransaction(withId: transaction.id)
        totalItems = coreDataManager.getTotalTransactionsCount()
        refreshTransactions()
    }
    
    func getLatestRate() -> Rate? {
        coreDataManager.fetchLatestRate()
    }
    
    func getCurrentBalance() -> CurrentBalance? {
        coreDataManager.getCurrentBalance()
    }
    
    func topUpBalance(amount: Double) {
        coreDataManager.updateCurrentBalance(by: amount)
    }
    
    func deductFromBalance(amount: Double) {
        coreDataManager.updateCurrentBalance(by: -amount)
    }
    
    
    // MARK: - Private Methods
    private func hasMorePages() -> Bool {
        let loadedCount = loadedTransactions.count
        return loadedCount < totalItems
    }
}
