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
        router.showAddTransactionScreen()
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
    
    private func setupBitcoinRateUpdates() {
        bitcoinRateServiceRepository.onRateUpdate = { [weak self] rate in
            self?.controller?.updateBitcoinRate(rate)
        }
    }
    
}

// MARK: - MainScreenPresenterProtocol
extension MainScreenPresenter: MainScreenPresenterProtocol {
    func loadView(controller: MainScreenViewControllerProtocol) {
        self.controller = controller
    }
    
    func updateView() {
        let sections = model.getTransactionSections()
        controller?.updateTransactionSections(sections)
        loadCurrentBalance()
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
        controller?.showTopUpBalanceAlert()
    }
    
    func loadCurrentBalance() {
        if let currentBalance = model.getCurrentBalance() {
            controller?.updateBalance(currentBalance)
        } else {
            controller?.updateBalance(0.0)
        }
    }
    
    func getTransactionSections() -> [TransactionSection] {
        model.getTransactionSections()
    }
    
    func loadNextPage() {
        controller?.showPaginationLoading()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            if self?.model.loadNextPage() == true {
                self?.loadCurrentBalance()
                self?.updateView()
            }
            self?.controller?.hidePaginationLoading()
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

