//
//  TransactionSection.swift
//  TransactionsTestTask
//
//  Created by CodingMeerkat on 06.10.2025.
//

import Foundation

// MARK: - Transaction Section
struct TransactionSection {
    let date: Date
    let transactions: [Transaction]
    
    var title: String {
        return date.sectionTitle
    }
    
    var totalAmount: Double {
        transactions.reduce(0) { $0 + $1.amount }
    }
}

// MARK: - Transaction Grouping Helper
struct TransactionGrouper {
    static func groupTransactions(_ transactions: [Transaction]) -> [TransactionSection] {
        let calendar = Calendar.current
        
        let grouped = Dictionary(grouping: transactions) { transaction in
            calendar.startOfDay(for: transaction.date)
        }
        
        let sections = grouped.map { date, transactions in
            TransactionSection(
                date: date,
                transactions: transactions.sorted { $0.date > $1.date }
            )
        }.sorted { $0.date > $1.date }
        
        return sections
    }
}
