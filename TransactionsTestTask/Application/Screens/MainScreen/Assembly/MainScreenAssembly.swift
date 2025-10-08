//
//  MainScreenAssembly.swift
//  TransactionsTestTask
//
//  Created by CodingMeerkat on 06.10.2025.
//

import UIKit

final class MainScreenAssembly {
    static func build(router: Router) -> (viewController: MainViewController, model: MainScreenModelProtocol) {
        let analyticsService = ServicesAssembler.analyticsService()
        let coreDataManager = ServicesAssembler.coreDataManager()
        let model = MainScreenModel(coreDataManager: coreDataManager)
        
        let bitcoinRateService = ServicesAssembler.bitcoinRateService()
        let networkMonitor = NetworkMonitor()
        let bitcoinRateServiceRepository = BitcoinRateServiceRepository(
            bitcoinRateService: bitcoinRateService,
            coreDataManager: coreDataManager,
            networkMonitor: networkMonitor,
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
        
        return (viewController: controller, model: model)
    }
}
