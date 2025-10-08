//
//  AddTransactionPresenter.swift
//  TransactionsTestTask
//
//  Created by CodingMeerkat on 06.10.2025.
//

import UIKit

final class AddTransactionScreenPresenter {
    private let router: Router
    private weak var controller: AddTransactionScreenViewControllerProtocol?
    
    var onSaveTapped: ((Transaction) -> Void)?

    struct Dependencies {
        let router: Router
    }
    
    init(dependencies: Dependencies) {
        self.router = dependencies.router
    }
}

// MARK: - Private extension
private extension AddTransactionScreenPresenter {
    func onSaveTransactionTapped(_ transaction: Transaction) {
        onSaveTapped?(transaction)
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
    
    func categoryButtonTapped() {
        controller?.showCategoryPicker()
    }
}
