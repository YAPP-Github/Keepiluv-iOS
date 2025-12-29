//
//  NetworkProvider.swift
//  CoreNetwork
//
//  Created by 정지훈 on 12/26/25.
//

import Foundation

import CoreNetworkInterface

public struct NetworkProvider: NetworkProviderProtocol {

    public init() { }

    public func request<T: Decodable>(endpoint: Endpoint) async throws -> T {
        guard let url = makeURL(endpoint: endpoint) else {
            throw NetworkError.invalidURLError
        }

        let request = try makeURLRequest(url: url, endpoint: endpoint)
        let (data, response) = try await URLSession.shared.data(for: request)
        
        return try processResponse(data: data, response: response)
    }
}

private extension NetworkProvider {
    func makeURL(endpoint: Endpoint) -> URL? {
        let url = endpoint.baseURL.appending(path: endpoint.path, directoryHint: .notDirectory)

        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            return nil
        }
        
        components.queryItems = endpoint.query
        return components.url
    }
    
    func makeURLRequest(url: URL, endpoint: Endpoint) throws -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        
        if let headers = endpoint.headers {
            headers.forEach { request.setValue($1, forHTTPHeaderField: $0) }
        }
        
        if let body = endpoint.body {
            do {
                request.httpBody = try JSONEncoder().encode(body)
            } catch {
                throw NetworkError.encodingError
            }
        }
        
        return request
    }
    
    func processResponse<T: Decodable>(data: Data, response: URLResponse) throws -> T {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponseError
        }
        
        switch httpResponse.statusCode {
        case HTTPStatusCode.success:
            guard let decodedResponse = try? JSONDecoder().decode(T.self, from: data) else {
                throw NetworkError.decodingError
            }
            return decodedResponse
            
        case HTTPStatusCode.unauthorized:
            throw NetworkError.authorizationError
            
        case HTTPStatusCode.badRequest:
            throw NetworkError.badRequestError
            
        case HTTPStatusCode.serverError:
            throw NetworkError.serverError
            
        default:
            throw NetworkError.unknownError
        }
    }
}
