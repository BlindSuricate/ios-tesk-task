//
//  ServicesAssembler.swift
//  TransactionsTestTask
//
//

/// Services Assembler is used for Dependency Injection
/// There is an example of a _bad_ services relationship built on `onRateUpdate` callback
/// This kind of relationship must be refactored with a more convenient and reliable approach
///
/// It's ok to move the logging to model/viewModel/interactor/etc when you have 1-2 modules in your app
/// Imagine having rate updates in 20-50 diffent modules
/// Make this logic not depending on any module
enum ServicesAssembler {
    
    // MARK: - BitcoinRateService
    
    static let bitcoinRateService: PerformOnce<BitcoinRateService> = {
        lazy var analyticsService = Self.analyticsService()
        lazy var networkService = Self.networkService()
        
        let service = BitcoinRateServiceImpl(
            networkService: networkService,
            analyticsService: analyticsService
        )
        
        return { service }
    }()
    
    // MARK: - AnalyticsService
    
    static let analyticsService: PerformOnce<AnalyticsService> = {
        let service = AnalyticsServiceImpl()
        
        return { service }
    }()
    
    static let networkService: PerformOnce<NetworkServiceProtocol> = {
        let networkService = NetworkService()
        return { networkService }
    }()
}
