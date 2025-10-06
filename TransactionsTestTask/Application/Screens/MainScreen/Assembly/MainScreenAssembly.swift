//
//  MainScreenAssembly.swift
//  TransactionsTestTask
//
//  Created by CodingMeerkat on 06.10.2025.
//

import UIKit

final class MainScreenAssembly {
    static func build(router: Router) -> MainViewController {
        let model = MainScreenModel()
        
        let presenter = MainScreenPresenter(
            dependencies: .init(model: model, router: router)
        )
        
        let controller = MainViewController(
            dependencies: .init(presenter: presenter)
        )
        
        return controller
    }
}
