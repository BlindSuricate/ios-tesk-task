//
//  AddTransactionScreenModel.swift
//  TransactionsTestTask
//
//  Created by CodingMeerkat on 06.10.2025.
//

import Foundation

final class AddTransactionScreenModel { }

// MARK: - AddTransactionScreenModelProtocol
extension AddTransactionScreenModel: AddTransactionScreenModelProtocol {
    func saveTransaction(_ transaction: Transaction) {
        print("\(transaction)")
    }
}
