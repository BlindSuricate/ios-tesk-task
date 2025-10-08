//
//  Router.swift
//  TransactionsTestTask
//
//  Created by CodingMeerkat on 06.10.2025.
//

import UIKit

final class Router {
    
    // MARK: - Properties
    private var navigationController: UINavigationController?
    private var window: UIWindow?
    private var mainScreenModel: MainScreenModelProtocol?
    
    // MARK: - Initialization
    init(window: UIWindow?) {
        self.window = window
    }
    
    func start() {
        navigationController = UINavigationController()
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        showMainScreen()
    }
    
    // MARK: - Main Screen Navigation
    private func showMainScreen() {
        let mainScreenResult = MainScreenAssembly.build(router: self)
        let mainScreenViewController = mainScreenResult.viewController
        mainScreenModel = mainScreenResult.model
        
        navigationController?.setViewControllers([mainScreenViewController], animated: false)
    }
    
    // MARK: - Add Transaction Screen Navigation
    func showAddTransactionScreen() {
        var addTransactionScreen = AddTransactionScreenAssembly.build(router: self)
        addTransactionScreen.presenter.onSaveTapped = { [weak self] transaction in
            self?.mainScreenModel?.deductFromBalance(amount: transaction.amount)
            self?.mainScreenModel?.addTransaction(transaction)
        }
        navigationController?.pushViewController(addTransactionScreen.view, animated: true)
    }
    
    // MARK: - Back Navigation
    func goBack() {
        navigationController?.popViewController(animated: true)
    }
}
