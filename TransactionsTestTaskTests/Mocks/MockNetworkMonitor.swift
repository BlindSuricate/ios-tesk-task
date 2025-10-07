//
//  MockNetworkMonitor.swift
//  TransactionsTestTaskTests
//
//  Created by CodingMeerkat on 08.10.2025.
//

import Foundation
@testable import TransactionsTestTask

class MockNetworkMonitor: NetworkMonitoringProtocol {
    var isConnected: Bool = true
}
