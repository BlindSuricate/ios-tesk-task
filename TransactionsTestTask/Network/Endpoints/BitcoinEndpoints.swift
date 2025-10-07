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
        return "https://blockchain.info"
    }
    
    var path: String {
        switch self {
        case .ticker:
            return "/ticker"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .ticker:
            return .GET
        }
    }
    
    var headers: [String: String]? {
        return [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
    }
    
    var parameters: [String: Any]? {
        return nil
    }
}
