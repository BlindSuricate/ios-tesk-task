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
    func getTransactionSections() -> [TransactionSection]
    func loadFirstPage()
    func loadNextPage() -> Bool
    func refreshTransactions()
    func getPaginationInfo() -> PaginationInfo
    func addTransaction(_ transaction: Transaction)
    func removeTransaction(sectionIndex: Int, itemIndex: Int)
    func getLatestRate() -> Rate?
    func getCurrentBalance() -> CurrentBalance?
    func topUpBalance(amount: Double)
    func deductFromBalance(amount: Double)
}

// MARK: - Main Screen View Protocol
protocol MainScreenViewProtocol: UIView {
    var onAddTransactionHandler: (() -> Void)? { get set }
    
    func updateTransactionSections(_ sections: [TransactionSection])
    func reloadTableView()
    func updateBitcoinRate(_ rate: Double)
    func updateBitcoinRateWithDate(_ rate: Double, date: Date)
    func updateBalance(_ amount: Double)
    func updateBalance(_ currentBalance: CurrentBalance)
    func showBitcoinLoading()
    func showBitcoinError()
    func showPaginationLoading()
    func hidePaginationLoading()
}

// MARK: - Main Screen ViewController Protocol
protocol MainScreenViewControllerProtocol: AnyObject {
    func updateTransactionSections(_ sections: [TransactionSection])
    func reloadTableView()
    func updateBitcoinRate(_ rate: Double)
    func updateBitcoinRateWithDate(_ rate: Double, date: Date)
    func updateBalance(_ amount: Double)
    func updateBalance(_ currentBalance: CurrentBalance)
    func showBitcoinLoading()
    func showBitcoinError()
    func showPaginationLoading()
    func hidePaginationLoading()
    func showTopUpBalanceAlert()
}

// MARK: - Main Screen Presenter Protocol
protocol MainScreenPresenterProtocol {
    func loadView(controller: MainScreenViewControllerProtocol)
    func viewDidLoad()
    func viewWillAppear()
    func updateView()
    func loadCurrentBalance()
    func addTransactionTapped()
    func topUpBalanceTapped()
    func loadNextPage()
    func refreshTransactions()
    func getTransactionSections() -> [TransactionSection]
    func getPaginationInfo() -> PaginationInfo
    func getLatestRate() -> Rate?
    func getModel() -> MainScreenModelProtocol
}
