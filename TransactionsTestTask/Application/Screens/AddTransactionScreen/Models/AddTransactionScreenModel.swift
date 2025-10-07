//
//  AddTransactionScreenModel.swift
//  TransactionsTestTask
//
//  Created by CodingMeerkat on 06.10.2025.
//

import Foundation

final class AddTransactionScreenModel {
    private let coreDataManager: CoreDataManagerProtocol
    private let mainScreenModel: MainScreenModelProtocol
    
    init(
        coreDataManager: CoreDataManagerProtocol,
        mainScreenModel: MainScreenModelProtocol
    ) {
        self.coreDataManager = coreDataManager
        self.mainScreenModel = mainScreenModel
    }
}

// MARK: - AddTransactionScreenModelProtocol
extension AddTransactionScreenModel: AddTransactionScreenModelProtocol {
    func saveTransaction(_ transaction: Transaction) {
        mainScreenModel.deductFromBalance(amount: transaction.amount)
        mainScreenModel.addTransaction(transaction)
    }
}
