//
//  AddTransactionScreenProtocols.swift
//  TransactionsTestTask
//
//  Created by CodingMeerkat on 06.10.2025.
//

import UIKit

// MARK: - Add Transaction Screen Model Protocol
protocol AddTransactionScreenModelProtocol {
    func saveTransaction(_ transaction: Transaction)
}

// MARK: - Add Transaction Screen View Protocol
protocol AddTransactionScreenViewProtocol: UIView {
    var onSaveTransactionHandler: ((Transaction) -> Void)? { get set }
}

// MARK: - Add Transaction Screen ViewController Protocol
protocol AddTransactionScreenViewControllerProtocol: AnyObject {
    func showError(_ message: String)
}

// MARK: - Add Transaction Screen Presenter Protocol
protocol AddTransactionScreenPresenterProtocol {
    func loadView(controller: AddTransactionScreenViewControllerProtocol)
    func viewDidLoad()
    func saveTransactionTapped(_ transaction: Transaction)
}
