//
//  MainScreenModel.swift
//  TransactionsTestTask
//
//  Created by CodingMeerkat on 06.10.2025.
//

import Foundation

final class MainScreenModel {
    private var transactions: [Transaction] = []
    
    init() {
        self.transactions = mockTransactions()
    }
    
    private func mockTransactions() -> [Transaction] {
        return [
            Transaction(category: .electronics, amount: 123),
            Transaction(category: .groceries, amount: 333),
            Transaction(category: .electronics, amount: 322),
            Transaction(category: .electronics, amount: 123),
            Transaction(category: .groceries, amount: 333),
            Transaction(category: .electronics, amount: 322),
            Transaction(category: .electronics, amount: 123),
            Transaction(category: .groceries, amount: 333),
            Transaction(category: .electronics, amount: 322),
            Transaction(category: .electronics, amount: 123),
            Transaction(category: .groceries, amount: 333),
            Transaction(category: .electronics, amount: 322)
        ]
    }
}

// MARK: - MainScreenModelProtocol
extension MainScreenModel: MainScreenModelProtocol {
    func getTransactions() -> [Transaction] {
        return transactions
    }
    
    func addTransaction(_ transaction: Transaction) {
        transactions.insert(transaction, at: 0)
    }
    
    func removeTransaction(at index: Int) {
        guard index < transactions.count else { return }
        transactions.remove(at: index)
    }
}
