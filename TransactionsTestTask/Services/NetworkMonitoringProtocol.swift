import Foundation

/// Protocol for network connectivity monitoring
protocol NetworkMonitoringProtocol: AnyObject {
    /// Indicates whether the device is currently connected to the internet
    var isConnected: Bool { get }
    
    /// Starts monitoring network connectivity
    func startMonitoring()
    
    /// Stops monitoring network connectivity
    func stopMonitoring()
}
