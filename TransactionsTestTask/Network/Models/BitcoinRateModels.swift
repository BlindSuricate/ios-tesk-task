//
//  BitcoinRateModels.swift
//  TransactionsTestTask
//
//  Created by CodingMeerkat on 06.10.2025.
//

import Foundation

// MARK: - Bitcoin Rate Response
struct BitcoinRateResponse: Decodable {
    let rates: [String: CurrencyRate]
    
    enum CodingKeys: String, CodingKey {
        case rates = ""
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        rates = try container.decode([String: CurrencyRate].self)
    }
}

// MARK: - Currency Rate
struct CurrencyRate: Decodable {
    let last: Double
}
