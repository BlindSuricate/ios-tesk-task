//
//  AddTransactionScreenAssembly.swift
//  TransactionsTestTask
//
//  Created by CodingMeerkat on 06.10.2025.
//

import UIKit

final class AddTransactionScreenAssembly {
    static func build(router: Router, mainScreenModel: MainScreenModelProtocol) -> AddTransactionViewController {
        let analyticsService = ServicesAssembler.analyticsService()
        let coreDataManager = ServicesAssembler.coreDataManager()
        let model = AddTransactionScreenModel(
            coreDataManager: coreDataManager,
            mainScreenModel: mainScreenModel
        )
        
        let presenter = AddTransactionScreenPresenter(
            dependencies: .init(model: model, router: router)
        )
        
        let controller = AddTransactionViewController(
            dependencies: .init(presenter: presenter)
        )
        
        return controller
    }
}
