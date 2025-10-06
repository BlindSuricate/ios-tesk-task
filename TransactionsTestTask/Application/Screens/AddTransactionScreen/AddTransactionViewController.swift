//
//  AddTransactionViewController.swift
//  TransactionsTestTask
//
//  Created by CodingMeerkat on 06.10.2025.
//

import UIKit

class AddTransactionViewController: UIViewController {
    
    private let presenter: AddTransactionScreenPresenterProtocol
    private var contentView: AddTransactionContentView!
    
    struct Dependencies {
        let presenter: AddTransactionScreenPresenterProtocol
    }
    
    init(dependencies: Dependencies) {
        self.presenter = dependencies.presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        let view = AddTransactionContentView()
        self.contentView = view
        self.view = view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewHandlers()
        presenter.loadView(controller: self)
        presenter.viewDidLoad()
    }
    
    private func setupViewHandlers() {
        contentView.onSaveTransactionHandler = { [weak self] transaction in
            self?.presenter.saveTransactionTapped(transaction)
        }
        contentView.onCancelHandler = { [weak self] in
            self?.presenter.cancelTapped()
        }
    }
}

// MARK: - AddTransactionScreenViewControllerProtocol
extension AddTransactionViewController: AddTransactionScreenViewControllerProtocol {
    
    func showError(_ message: String) {
        contentView.showError(message)
    }
    
    func clearFields() {
        contentView.clearFields()
    }
}
