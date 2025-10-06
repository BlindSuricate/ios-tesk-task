//
//  MainViewController.swift
//  TransactionsTestTask
//
//  Created by CodingMeerkat on 06.10.2025.
//

import UIKit

final class MainViewController: UIViewController {
    
    private let presenter: MainScreenPresenterProtocol
    private var transactions: [Transaction] = []
    
    private var contentView: MainContentView? {
        return view as? MainContentView
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
        self.transactions = mockTransactions()
        contentView?.transactionsTableView.dataSource = self
        contentView?.transactionsTableView.delegate = self
        
        setupViewHandlers()
        presenter.loadView(controller: self)
        presenter.viewDidLoad()
    }
    
    private func setupViewHandlers() {
        contentView?.onAddTransactionHandler = { [weak self] in
            self?.presenter.addTransactionTapped()
        }
        contentView?.onTransactionSelectedHandler = { [weak self] index in
            self?.presenter.transactionSelected(at: index)
        }
    }
}

//MARK: - TableView dataSource

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TransactionCell = tableView.dequeueReusableCell(for: indexPath)
        cell.configure(with: transactions[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

//MARK: - TableView delegate
extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.transactionSelected(at: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension MainViewController {
    func mockTransactions() -> [Transaction] {
        return [
            Transaction(category: .electronics, amount: 123),
            Transaction(category: .groceries, amount: 333),
            Transaction(category: .electronics, amount: 322),
            Transaction(category: .electronics, amount: 123),
            Transaction(category: .groceries, amount: 333),
            Transaction(category: .electronics, amount: 322),
            Transaction(category: .electronics, amount: 123),
            Transaction(category: .groceries, amount: 333),
            Transaction(category: .electronics, amount: 322),
            Transaction(category: .electronics, amount: 123),
            Transaction(category: .groceries, amount: 333),
            Transaction(category: .electronics, amount: 322),
            Transaction(category: .electronics, amount: 123),
            Transaction(category: .groceries, amount: 333),
            Transaction(category: .electronics, amount: 322),
            Transaction(category: .electronics, amount: 123),
            Transaction(category: .groceries, amount: 333),
            Transaction(category: .electronics, amount: 322),
            Transaction(category: .electronics, amount: 123),
            Transaction(category: .groceries, amount: 333),
            Transaction(category: .electronics, amount: 322),
            Transaction(category: .electronics, amount: 123),
            Transaction(category: .groceries, amount: 333),
            Transaction(category: .electronics, amount: 322),
            Transaction(category: .electronics, amount: 123),
            Transaction(category: .groceries, amount: 333),
            Transaction(category: .electronics, amount: 322),
            Transaction(category: .electronics, amount: 123),
            Transaction(category: .groceries, amount: 333),
            Transaction(category: .electronics, amount: 322),
            Transaction(category: .electronics, amount: 123),
            Transaction(category: .groceries, amount: 333),
            Transaction(category: .electronics, amount: 322),
            Transaction(category: .electronics, amount: 123),
            Transaction(category: .groceries, amount: 333),
            Transaction(category: .electronics, amount: 322),
            Transaction(category: .electronics, amount: 123),
            Transaction(category: .groceries, amount: 333),
            Transaction(category: .electronics, amount: 322),
            Transaction(category: .electronics, amount: 123),
            Transaction(category: .groceries, amount: 333),
            Transaction(category: .electronics, amount: 322),
            Transaction(category: .electronics, amount: 123),
            Transaction(category: .groceries, amount: 333),
            Transaction(category: .electronics, amount: 322)
        ]
    }
}

// MARK: - MainScreenViewControllerProtocol
extension MainViewController: MainScreenViewControllerProtocol {
    func updateTransactions(_ transactions: [Transaction]) {
        self.transactions = transactions
        contentView?.updateTransactions(transactions)
    }
    
    func reloadTableView() {
        contentView?.reloadTableView()
    }
}
