//
//  MainScreenProtocols.swift
//  TransactionsTestTask
//
//  Created by CodingMeerkat on 06.10.2025.
//

import UIKit

// MARK: - Main Screen Model Protocol
protocol MainScreenModelProtocol {
    func getTransactions() -> [Transaction]
    func addTransaction(_ transaction: Transaction)
    func removeTransaction(at index: Int)
}

// MARK: - Main Screen View Protocol
protocol MainScreenViewProtocol: UIView {
    var onAddTransactionHandler: (() -> Void)? { get set }
    var onTransactionSelectedHandler: ((Int) -> Void)? { get set }
    
    func updateTransactions(_ transactions: [Transaction])
    func reloadTableView()
}

// MARK: - Main Screen ViewController Protocol
protocol MainScreenViewControllerProtocol: AnyObject {
    func updateTransactions(_ transactions: [Transaction])
    func reloadTableView()
}

// MARK: - Main Screen Presenter Protocol
protocol MainScreenPresenterProtocol {
    func loadView(controller: MainScreenViewControllerProtocol)
    func viewDidLoad()
    func addTransactionTapped()
    func transactionSelected(at index: Int)
}
