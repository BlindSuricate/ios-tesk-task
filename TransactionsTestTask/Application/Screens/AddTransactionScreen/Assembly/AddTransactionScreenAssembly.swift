//
//  AddTransactionScreenAssembly.swift
//  TransactionsTestTask
//
//  Created by CodingMeerkat on 06.10.2025.
//

import UIKit

final class AddTransactionScreenAssembly {
    static func build(router: Router) -> AddTransactionViewController {
        let model = AddTransactionScreenModel()
        
        let presenter = AddTransactionScreenPresenter(
            dependencies: .init(model: model, router: router)
        )
        
        let controller = AddTransactionViewController(
            dependencies: .init(presenter: presenter)
        )
        
        return controller
    }
}
