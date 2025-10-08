//
//  MainViewController.swift
//  TransactionsTestTask
//
//  Created by CodingMeerkat on 06.10.2025.
//

import UIKit

final class MainViewController: UIViewController {
    
    // MARK: - Constants
    private enum Constants {
        static let cellHeight: CGFloat = 100
        static let headerHeight: CGFloat = 40
        static let paginationTriggerOffset: Int = 3
    }
    
    private let presenter: MainScreenPresenterProtocol
    private var transactionSections: [TransactionSection] = []
    
    private var contentView: MainContentView? {
        view as? MainContentView
    }
    
    struct Dependencies {
        let presenter: MainScreenPresenterProtocol
    }
    
    init(dependencies: Dependencies) {
        self.presenter = dependencies.presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = MainContentView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.transactionSections = presenter.getTransactionSections()
        contentView?.transactionsTableView.dataSource = self
        contentView?.transactionsTableView.delegate = self
        
        setupViewHandlers()
        presenter.loadView(controller: self)
        presenter.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.viewWillAppear()
    }
    
    private func setupViewHandlers() {
        contentView?.onAddTransactionHandler = { [weak self] in
            self?.presenter.addTransactionTapped()
        }
        contentView?.onTopUpBalanceHandler = { [weak self] in
            self?.presenter.topUpBalanceTapped()
        }
    }
    
}

//MARK: - TableView dataSource

extension MainViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        transactionSections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard section < transactionSections.count else { return 0 }
        return transactionSections[section].transactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TransactionCell = tableView.dequeueReusableCell(for: indexPath)
        let section = transactionSections[indexPath.section]
        let transaction = section.transactions[indexPath.row]
        
        cell.configure(with: transaction)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        Constants.cellHeight
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard section < transactionSections.count else { return nil }
        return transactionSections[section].title
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        Constants.headerHeight
    }
}

//MARK: - TableView delegate
extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let paginationInfo = presenter.getPaginationInfo()
        
        if indexPath.section == transactionSections.count - 1 {
            let lastSection = transactionSections[indexPath.section]
            if indexPath.row >= lastSection.transactions.count - Constants.paginationTriggerOffset && paginationInfo.hasMorePages {
                presenter.loadNextPage()
            }
        }
    }
}

// MARK: - MainScreenViewControllerProtocol
extension MainViewController: MainScreenViewControllerProtocol {
    
    func updateTransactionSections(_ sections: [TransactionSection]) {
        self.transactionSections = sections
        contentView?.updateTransactionSections(sections)
    }
    
    func reloadTableView() {
        contentView?.reloadTableView()
    }
    
    func updateBitcoinRate(_ rate: Double) {
        contentView?.updateBitcoinRate(rate)
    }
    
    func updateBitcoinRateWithDate(_ rate: Double, date: Date) {
        contentView?.updateBitcoinRateWithDate(rate, date: date)
    }
    
    func showBitcoinLoading() {
        contentView?.showBitcoinLoading()
    }
    
    func showBitcoinError() {
        contentView?.showBitcoinError()
    }
    
    func updateBalance(_ amount: Double) {
        contentView?.updateBalance(amount)
    }
    
    func updateBalance(_ currentBalance: CurrentBalance) {
        contentView?.updateBalance(currentBalance)
    }
    
    func showPaginationLoading() {
        contentView?.showPaginationLoading()
    }
    
    func hidePaginationLoading() {
        contentView?.hidePaginationLoading()
    }
    
    // MARK: - Helper Methods
    func getModel() -> MainScreenModelProtocol {
        presenter.getModel()
    }
}
