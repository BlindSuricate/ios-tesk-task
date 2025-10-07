//
//  NetworkProtocols.swift
//  TransactionsTestTask
//
//  Created by CodingMeerkat on 06.10.2025.
//

import Foundation

// MARK: - Network Error
enum NetworkError: Error, LocalizedError {
    case invalidURL
    case noData
    case decodingError(Error)
    case networkError(Error)
    case serverError(Int)
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .noData:
            return "No data received"
        case .decodingError(let error):
            return "Decoding error: \(error.localizedDescription)"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .serverError(let code):
            return "Server error with code: \(code)"
        case .unknown:
            return "Unknown error occurred"
        }
    }
}

// MARK: - HTTP Method
enum HTTPMethod: String {
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
    case DELETE = "DELETE"
    case PATCH = "PATCH"
}

// MARK: - API Endpoint
protocol APIEndpoint {
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    var parameters: [String: Any]? { get }
}

// MARK: - Network Service Protocol
protocol NetworkServiceProtocol {
    func request<T: Decodable>(
        endpoint: APIEndpoint,
        responseType: T.Type,
        completion: @escaping (Result<T, NetworkError>) -> Void
    )
}
