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
        let mainScreenViewController = MainScreenAssembly.build(router: self)
        navigationController?.setViewControllers([mainScreenViewController], animated: false)
    }
    
    // MARK: - Add Transaction Screen Navigation
    func showAddTransactionScreen() {
        let addTransactionScreenViewController = AddTransactionScreenAssembly.build(router: self)
        navigationController?.pushViewController(addTransactionScreenViewController, animated: true)
    }
    
    // MARK: - Back Navigation
    func goBack() {
        navigationController?.popViewController(animated: true)
    }
}
