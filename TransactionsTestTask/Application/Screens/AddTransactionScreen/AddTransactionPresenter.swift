//
//  AddTransactionPresenter.swift
//  TransactionsTestTask
//
//  Created by CodingMeerkat on 06.10.2025.
//

import UIKit

final class AddTransactionScreenPresenter {
    private let model: AddTransactionScreenModelProtocol
    private let router: Router
    private weak var controller: AddTransactionScreenViewControllerProtocol?
    
    struct Dependencies {
        let model: AddTransactionScreenModelProtocol
        let router: Router
    }
    
    init(dependencies: Dependencies) {
        self.model = dependencies.model
        self.router = dependencies.router
    }
}

// MARK: - Private extension
private extension AddTransactionScreenPresenter {
    func onSaveTransactionTapped(_ transaction: Transaction) {
        model.saveTransaction(transaction)
        router.goBack()
    }
    
}

// MARK: - AddTransactionScreenPresenterProtocol
extension AddTransactionScreenPresenter: AddTransactionScreenPresenterProtocol {
    func loadView(controller: AddTransactionScreenViewControllerProtocol) {
        self.controller = controller
    }
    
    func viewDidLoad() {
    }
    
    func saveTransactionTapped(_ transaction: Transaction) {
        self.onSaveTransactionTapped(transaction)
    }
    
}
