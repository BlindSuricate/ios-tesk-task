//
//  NetworkMonitor.swift
//  TransactionsTestTask
//
//  Created by CodingMeerkat on 07.10.2025.
//

import Foundation
import Network

// MARK: - Network Monitoring Protocol
protocol NetworkMonitoringProtocol: AnyObject {
    var isConnected: Bool { get }
}

// MARK: - Network Monitor
final class NetworkMonitor: NetworkMonitoringProtocol {
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")
    var isConnected: Bool = false
    
    init() {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isConnected = path.status == .satisfied
        }
        monitor.start(queue: queue)
    }
    
    deinit {
        monitor.cancel()
    }
}
