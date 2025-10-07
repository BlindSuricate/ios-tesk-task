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
    private var bitcoinRateServiceRepository: BitcoinRateServiceRepositoryProtocol
    private weak var controller: MainScreenViewControllerProtocol?
    
    struct Dependencies {
        let model: MainScreenModelProtocol
        let router: Router
        let bitcoinRateServiceRepository: BitcoinRateServiceRepositoryProtocol
    }
    
    init(dependencies: Dependencies) {
        self.model = dependencies.model
        self.router = dependencies.router
        self.bitcoinRateServiceRepository = dependencies.bitcoinRateServiceRepository
    }
    
    deinit {
        bitcoinRateServiceRepository.stopPeriodicUpdates()
    }
}

// MARK: - Private extension
private extension MainScreenPresenter {
    private func onAddTransactionTapped() {
        self.router.showAddTransactionScreen()
    }
    
    private func updateView() {
        let sections = self.model.getTransactionSections()
        self.controller?.updateTransactionSections(sections)
        loadCurrentBalance()
    }
    
    private func loadBitcoinRate() {
        controller?.showBitcoinLoading()
        bitcoinRateServiceRepository.startPeriodicUpdates()
    }
    
    private func loadLatestRateFromStorage() {
        if let latestRate = model.getLatestRate() {
            controller?.updateBitcoinRateWithDate(latestRate.rate, date: latestRate.date)
        }
    }
    
    private func loadCurrentBalance() {
        if let currentBalance = model.getCurrentBalance() {
            controller?.updateBalance(currentBalance)
        } else {
            controller?.updateBalance(0.0)
        }
    }
    
    private func setupBitcoinRateUpdates() {
        bitcoinRateServiceRepository.onRateUpdate = { [weak self] rate in
            self?.controller?.updateBitcoinRate(rate)
        }
    }
    
    private func showTopUpBalanceAlert() {
        let alert = UIAlertController(title: "Top Up Balance", message: "Enter the amount of bitcoins to add to your balance", preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "Amount (BTC)"
            textField.keyboardType = .decimalPad
        }
        
        let addAction = UIAlertAction(title: "Add", style: .default) { [weak self] _ in
            guard let textField = alert.textFields?.first,
                  let text = textField.text,
                  !text.isEmpty,
                  let amount = Double(text),
                  amount > 0 else {
                return
            }
            
            self?.model.topUpBalance(amount: amount)
            
            let topUpTransaction = Transaction(
                id: UUID(),
                category: .enrollment,
                amount: amount,
                date: Date()
            )
            
            self?.model.addTransaction(topUpTransaction)
            self?.loadCurrentBalance()
            self?.updateView()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first,
           let rootViewController = window.rootViewController {
            var topController = rootViewController
            while let presentedController = topController.presentedViewController {
                topController = presentedController
            }
            topController.present(alert, animated: true)
        }
    }
}

// MARK: - MainScreenPresenterProtocol
extension MainScreenPresenter: MainScreenPresenterProtocol {
    func loadView(controller: MainScreenViewControllerProtocol) {
        self.controller = controller
    }
    
    func viewDidLoad() {
        self.loadFirstPage()
        self.loadLatestRateFromStorage()
        self.loadCurrentBalance()
        self.setupBitcoinRateUpdates()
        self.loadBitcoinRate()
    }
    
    func addTransactionTapped() {
        self.onAddTransactionTapped()
    }
    
    func topUpBalanceTapped() {
        showTopUpBalanceAlert()
    }
    
    func getTransactionSections() -> [TransactionSection] {
        model.getTransactionSections()
    }
    
    func loadNextPage() {
        if model.loadNextPage() {
            loadCurrentBalance()
            updateView()
        }
    }
    
    func refreshTransactions() {
        model.refreshTransactions()
        loadCurrentBalance()
        updateView()
    }
    
    func getPaginationInfo() -> PaginationInfo {
        model.getPaginationInfo()
    }
    
    func getLatestRate() -> Rate? {
        model.getLatestRate()
    }
    
    func getModel() -> MainScreenModelProtocol {
        model
    }
    
    func getCurrentBalance() -> CurrentBalance? {
        model.getCurrentBalance()
    }
    
    func viewWillAppear() {
        loadCurrentBalance()
        updateView()
    }
    
    // MARK: - Private Methods
    private func loadFirstPage() {
        model.loadFirstPage()
        loadCurrentBalance()
        updateView()
    }
}
