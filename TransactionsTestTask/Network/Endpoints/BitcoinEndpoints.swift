//
//  BitcoinEndpoints.swift
//  TransactionsTestTask
//
//  Created by CodingMeerkat on 06.10.2025.
//

import Foundation

// MARK: - Bitcoin API Endpoints
enum BitcoinAPI {
    case ticker
}

// MARK: - Bitcoin API Endpoint Implementation
extension BitcoinAPI: APIEndpoint {
    var baseURL: String {
        "https://blockchain.info"
    }
    
    var path: String {
        switch self {
        case .ticker:
            "/ticker"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .ticker:
            .GET
        }
    }
    
    var headers: [String: String]? {
        [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
    }
    
    var parameters: [String: Any]? {
        nil
    }
}
