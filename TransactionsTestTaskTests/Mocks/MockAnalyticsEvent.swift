//
//  MockAnalyticsEvent.swift
//  TransactionsTestTaskTests
//
//  Created by CodingMeerkat on 08.10.2025.
//

import Foundation
@testable import TransactionsTestTask

struct MockAnalyticsEvent: AnalyticsEventProtocol {
    let eventName: String
    let parameters: [String: String]
    
    init(name: String, params: [String: String]) {
        self.eventName = name
        self.parameters = params
    }
}
