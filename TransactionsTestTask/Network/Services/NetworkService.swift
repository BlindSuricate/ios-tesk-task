//
//  NetworkService.swift
//  TransactionsTestTask
//
//  Created by CodingMeerkat on 06.10.2025.
//

import Foundation

final class NetworkService: NetworkServiceProtocol {
    
    // MARK: - Properties
    private let session: URLSession
    private let jsonDecoder: JSONDecoder
    
    // MARK: - Initialization
    init(session: URLSession = URLSession.shared) {
        self.session = session
        self.jsonDecoder = JSONDecoder()
    }
    
    // MARK: - NetworkServiceProtocol
    func request<T: Decodable>(
        endpoint: APIEndpoint,
        responseType: T.Type,
        completion: @escaping (Result<T, NetworkError>) -> Void
    ) {
        // Create URL
        guard let url = createURL(from: endpoint) else {
            DispatchQueue.main.async {
                completion(.failure(.invalidURL))
            }
            return
        }
        
        // Create request
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        
        // Add headers
        if let headers = endpoint.headers {
            for (key, value) in headers {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        // Add parameters for GET request
        if let parameters = endpoint.parameters, endpoint.method == .GET {
            if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) {
                urlComponents.queryItems = parameters.map { key, value in
                    URLQueryItem(name: key, value: "\(value)")
                }
                request.url = urlComponents.url
            }
        }
        
        // Perform request on background queue
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.performRequest(request: request, responseType: responseType, completion: completion)
        }
    }
    
    // MARK: - Private Methods
    private func createURL(from endpoint: APIEndpoint) -> URL? {
        let fullURL = endpoint.baseURL + endpoint.path
        return URL(string: fullURL)
    }
    
    private func performRequest<T: Decodable>(
        request: URLRequest,
        responseType: T.Type,
        completion: @escaping (Result<T, NetworkError>) -> Void
    ) {
        session.dataTask(with: request) { [weak self] data, response, error in
            // Handle network error
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(.networkError(error)))
                }
                return
            }
            
            // Handle HTTP response
            guard let httpResponse = response as? HTTPURLResponse else {
                DispatchQueue.main.async {
                    completion(.failure(.unknown))
                }
                return
            }
            
            // Check status code
            guard 200...299 ~= httpResponse.statusCode else {
                DispatchQueue.main.async {
                    completion(.failure(.serverError(httpResponse.statusCode)))
                }
                return
            }
            
            // Handle data
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(.noData))
                }
                return
            }
            
            // Decode response
            self?.decodeResponse(data: data, responseType: responseType, completion: completion)
            
        }.resume()
    }
    
    private func decodeResponse<T: Decodable>(
        data: Data,
        responseType: T.Type,
        completion: @escaping (Result<T, NetworkError>) -> Void
    ) {
        do {
            let decodedResponse = try jsonDecoder.decode(responseType, from: data)
            DispatchQueue.main.async {
                completion(.success(decodedResponse))
            }
        } catch {
            DispatchQueue.main.async {
                completion(.failure(.decodingError(error)))
            }
        }
    }
}
