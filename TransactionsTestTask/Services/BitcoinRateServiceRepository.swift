//
//  BitcoinRateServiceRepository.swift
//  TransactionsTestTask
//
//  Created by CodingMeerkat on 06.10.2025.
//

import Foundation

// MARK: - Bitcoin Rate Service Repository Protocol
protocol BitcoinRateServiceRepositoryProtocol {
    var onRateUpdate: ((Double) -> Void)? { get set }
    func startPeriodicUpdates()
    func stopPeriodicUpdates()
    func getCurrentRate() -> Double?
    func forceUpdate()
}

// MARK: - Bitcoin Rate Service Repository
final class BitcoinRateServiceRepository: BitcoinRateServiceRepositoryProtocol {
    
    // MARK: - Properties
    var onRateUpdate: ((Double) -> Void)?
    
    private let bitcoinRateService: BitcoinRateService
    private let coreDataManager: CoreDataManager
    private let networkMonitor: NetworkMonitor
    private let analyticsService: AnalyticsService
    private var updateTimer: Timer?
    private let updateInterval: TimeInterval = 120
    
    // MARK: - Initialization
    init(
        bitcoinRateService: BitcoinRateService,
        coreDataManager: CoreDataManager,
        analyticsService: AnalyticsService
    ) {
        self.bitcoinRateService = bitcoinRateService
        self.coreDataManager = coreDataManager
        self.networkMonitor = NetworkMonitor()
        self.analyticsService = analyticsService
        
        setupBitcoinRateService()
    }
    
    // MARK: - Public Methods
    func startPeriodicUpdates() {
        stopPeriodicUpdates()
        
        let event = BitcoinRateEventFactory.periodicUpdatesStarted(interval: updateInterval)
        analyticsService.trackEvent(event)
        
        getCurrentRateFromAvailableSource()
        
        updateTimer = Timer.scheduledTimer(withTimeInterval: updateInterval, repeats: true) { [weak self] _ in
            self?.getCurrentRateFromAvailableSource()
        }
    }
    
    func stopPeriodicUpdates() {
        if updateTimer != nil {
            let event = BitcoinRateEventFactory.periodicUpdatesStopped()
            analyticsService.trackEvent(event)
        }
        updateTimer?.invalidate()
        updateTimer = nil
    }
    
    func getCurrentRate() -> Double? {
        if let latestRate = coreDataManager.fetchLatestRate() {
            return latestRate.rate
        }
        return nil
    }
    
    func forceUpdate() {
        let event = BitcoinRateEventFactory.forceUpdate()
        analyticsService.trackEvent(event)
        getCurrentRateFromAvailableSource()
    }
    
    // MARK: - Private Methods
    private func setupBitcoinRateService() {
        bitcoinRateService.onRateUpdate = { [weak self] rate in
            self?.onRateUpdate?(rate)
        }
    }
    
    private func getCurrentRateFromAvailableSource() {
        if networkMonitor.isConnected {
            fetchRateFromInternet()
        } else {
            useCachedRate()
        }
    }
    
    private func fetchRateFromInternet() {
        let event = BitcoinRateEventFactory.onlineAttempt()
        analyticsService.trackEvent(event)
        
        bitcoinRateService.getBitcoinRate { [weak self] result in
            switch result {
            case .success:
                let successEvent = BitcoinRateEventFactory.onlineSuccess()
                self?.analyticsService.trackEvent(successEvent)
            case .failure(let error):
                let failureEvent = BitcoinRateEventFactory.onlineFailure(error: "\(error)")
                self?.analyticsService.trackEvent(failureEvent)
                self?.useCachedRate()
            }
        }
    }
    
    private func useCachedRate() {
        if let latestRate = coreDataManager.fetchLatestRate() {
            let event = BitcoinRateEvent(
                eventName: "bitcoin_rate_update_offline_success",
                additionalParameters: [
                    "source": "cached",
                    "cached_date": "\(latestRate.date.timeIntervalSince1970)"
                ]
            )
            analyticsService.trackEvent(event)
            onRateUpdate?(latestRate.rate)
        } else {
            let event = BitcoinRateEvent(
                eventName: "bitcoin_rate_update_offline_failure",
                additionalParameters: [
                    "source": "cached",
                    "error": "no_cached_rate_available"
                ]
            )
            analyticsService.trackEvent(event)
        }
    }
    
    deinit {
        stopPeriodicUpdates()
    }
}
