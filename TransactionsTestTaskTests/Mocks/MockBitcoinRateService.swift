//
//  MockBitcoinRateService.swift
//  TransactionsTestTaskTests
//
//  Created by CodingMeerkat on 08.10.2025.
//

import Foundation
@testable import TransactionsTestTask

class MockBitcoinRateService: BitcoinRateService {
    var shouldSucceed = true
    var mockRate: Double = 50000.0
    var mockError: NetworkError = .networkError(NSError(domain: "test", code: 1, userInfo: nil))
    var getBitcoinRateCalled = false
    var onRateUpdate: ((Double) -> Void)?
    
    func getBitcoinRate(completion: @escaping (Result<Void, NetworkError>) -> Void) {
        getBitcoinRateCalled = true
        
        if shouldSucceed {
            onRateUpdate?(mockRate)
            completion(.success(()))
        } else {
            completion(.failure(mockError))
        }
    }
}
