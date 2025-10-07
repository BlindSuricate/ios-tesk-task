//
//  BitcoinRateService.swift
//  TransactionsTestTask
//
//

/// Rate Service should fetch data from https://api.coindesk.com/v1/bpi/currentprice.json
/// Fetching should be scheduled with dynamic update interval
/// Rate should be cached for the offline mode
/// Every successful fetch should be logged with analytics service
/// The service should be covered by unit tests
protocol BitcoinRateService: AnyObject {
    var onRateUpdate: ((Double) -> Void)? { get set }
    func getBitcoinRate(completion: @escaping (Result<Void, NetworkError>) -> Void)
}

final class BitcoinRateServiceImpl {
    
    var onRateUpdate: ((Double) -> Void)?
    
    // MARK: - Properties
    private let networkService: NetworkServiceProtocol
    private let analyticsService: AnalyticsService
    
    // MARK: - Initialization
    init(
        networkService: NetworkServiceProtocol,
        analyticsService: AnalyticsService
    ) {
        self.networkService = networkService
        self.analyticsService = analyticsService
    }
    
    // MARK: - BitcoinRateServiceProtocol
    func getBitcoinRate(completion: @escaping (Result<Void, NetworkError>) -> Void) {
        networkService.request(
            endpoint: BitcoinAPI.ticker,
            responseType: BitcoinRateResponse.self
        ) { [weak self] result in
            switch result {
            case .success(let response):
                self?.handleBitcoinRateResponse(response, completion: completion)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - Private Methods
    private func handleBitcoinRateResponse(
        _ response: BitcoinRateResponse,
        completion: @escaping (Result<Void, NetworkError>) -> Void
    ) {
        guard let usdRate = response.rates["USD"]?.last else {
            completion(.failure(.noData))
            return
        }
        
        onRateUpdate?(usdRate)
        analyticsService.trackEvent(name: "bitcoin_rate_updated", parameters: ["rate": String(usdRate)])
        completion(.success(()))
    }
}

extension BitcoinRateServiceImpl: BitcoinRateService {
    
}
