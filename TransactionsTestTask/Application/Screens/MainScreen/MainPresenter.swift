//
//  MainPresenter.swift
//  TransactionsTestTask
//
//  Created by CodingMeerkat on 06.10.2025.
//

import UIKit

final class MainScreenPresenter {
    private let model: MainScreenModelProtocol
    private let router: Router
    private weak var controller: MainScreenViewControllerProtocol?
    
    struct Dependencies {
        let model: MainScreenModelProtocol
        let router: Router
    }
    
    init(dependencies: Dependencies) {
        self.model = dependencies.model
        self.router = dependencies.router
    }
}

// MARK: - Private extension
private extension MainScreenPresenter {
    private func onAddTransactionTapped() {
        self.router.showAddTransactionScreen()
    }
    
    private func onTransactionSelected(at index: Int) {
        print("Transaction selected at index: \(index)")
        // Handle transaction selection if needed
    }
    
    private func updateView() {
        let transactions = self.model.getTransactions()
        self.controller?.updateTransactions(transactions)
    }
}

// MARK: - MainScreenPresenterProtocol
extension MainScreenPresenter: MainScreenPresenterProtocol {
    func loadView(controller: MainScreenViewControllerProtocol) {
        self.controller = controller
    }
    
    func viewDidLoad() {
        self.updateView()
    }
    
    func addTransactionTapped() {
        self.onAddTransactionTapped()
    }
    
    func transactionSelected(at index: Int) {
        self.onTransactionSelected(at: index)
    }
}
