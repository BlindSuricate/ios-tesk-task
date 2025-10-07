//
//  MainScreenAssembly.swift
//  TransactionsTestTask
//
//  Created by CodingMeerkat on 06.10.2025.
//

import UIKit

final class MainScreenAssembly {
    static func build(router: Router) -> MainViewController {
        let analyticsService = ServicesAssembler.analyticsService()
        let coreDataManager = CoreDataManager(analyticsService: analyticsService)
        let model = MainScreenModel(coreDataManager: coreDataManager)
        
        let bitcoinRateService = ServicesAssembler.bitcoinRateService()
        let bitcoinRateServiceRepository = BitcoinRateServiceRepository(
            bitcoinRateService: bitcoinRateService,
            coreDataManager: coreDataManager,
            analyticsService: analyticsService
        )
        
        let presenter = MainScreenPresenter(
            dependencies: .init(
                model: model,
                router: router,
                bitcoinRateServiceRepository: bitcoinRateServiceRepository
            )
        )
        
        let controller = MainViewController(
            dependencies: .init(presenter: presenter)
        )
        
        return controller
    }
}
