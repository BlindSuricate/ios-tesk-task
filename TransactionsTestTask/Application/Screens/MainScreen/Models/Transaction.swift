//
//  Transaction.swift
//  TransactionsTestTask
//
//  Created by CodingMeerkat on 06.10.2025.
//

import Foundation

struct Transaction {
    let category: TransactionCategiry
    let amount: Double
    let date: Date = .now
}
