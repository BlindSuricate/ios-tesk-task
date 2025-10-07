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
    private let bitcoinRateService: BitcoinRateService
    private weak var controller: MainScreenViewControllerProtocol?
    
    struct Dependencies {
        let model: MainScreenModelProtocol
        let router: Router
        let bitcoinRateService: BitcoinRateService
    }
    
    init(dependencies: Dependencies) {
        self.model = dependencies.model
        self.router = dependencies.router
        self.bitcoinRateService = dependencies.bitcoinRateService
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
    
    private func loadBitcoinRate() {
        controller?.showBitcoinLoading()
        
        bitcoinRateService.getBitcoinRate { [weak self] result in
            switch result {
            case .success:
                // Rate will be updated via onRateUpdate callback
                break
            case .failure(let error):
                print("Failed to load Bitcoin rate: \(error)")
                self?.controller?.showBitcoinError()
            }
        }
    }
    
    private func setupBitcoinRateUpdates() {
        bitcoinRateService.onRateUpdate = { [weak self] rate in
            self?.controller?.updateBitcoinRate(rate)
        }
    }
}

// MARK: - MainScreenPresenterProtocol
extension MainScreenPresenter: MainScreenPresenterProtocol {
    func loadView(controller: MainScreenViewControllerProtocol) {
        self.controller = controller
    }
    
    func viewDidLoad() {
        self.updateView()
        self.setupBitcoinRateUpdates()
        self.loadBitcoinRate()
    }
    
    func addTransactionTapped() {
        self.onAddTransactionTapped()
    }
    
    func transactionSelected(at index: Int) {
        self.onTransactionSelected(at: index)
    }
    
    func getTransactions() -> [Transaction] {
        model.getTransactions()
    }
}
