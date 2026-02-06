//
//  NetworkProvider.swift
//  CoreNetwork
//
//  Created by 정지훈 on 12/26/25.
//

import ComposableArchitecture
import CoreNetworkInterface
import Foundation

#if DEBUG
import CoreLogging
#endif

public final class NetworkProvider: NetworkProviderProtocol, Sendable {
    private let session: URLSession
    private let interceptors: [NetworkInterceptor]

    /// NetworkProvider를 생성합니다.
    /// - Parameter interceptors: 네트워크 요청을 intercept할 Interceptor 배열 (기본값: 빈 배열)
    public init(interceptors: [NetworkInterceptor] = []) {
        self.session = URLSession.shared
        self.interceptors = interceptors
    }

    // swiftlint:disable:next function_body_length
    public func request<T: Decodable>(endpoint: Endpoint) async throws -> T {
        guard let url = makeURL(endpoint: endpoint) else {
            throw NetworkError.invalidURLError
        }

        let request = try makeURLRequest(url: url, endpoint: endpoint)
        let featureTag = endpoint.featureTag.rawValue

        return try await withCheckedThrowingContinuation { continuation in
            var createdTask: URLSessionDataTask?
            let task = session.dataTask(with: request) { [interceptors] data, response, error in
                if let task = createdTask {
                    if let data = data {
                        interceptors.forEach { $0.didReceiveData(task, data: data) }
                    }
                    interceptors.forEach { $0.didCompleteTask(task, error: error) }
                }

                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }

                guard let data = data, let response = response else {
                    continuation.resume(throwing: NetworkError.invalidResponseError)
                    return
                }

                do {
                    let result: T = try self.processResponse(data: data, response: response)
                    continuation.resume(returning: result)
                } catch {
                    continuation.resume(throwing: error)
                }
            }

            task.taskDescription = featureTag
            createdTask = task

            interceptors.forEach { $0.didCreateTask(task) }

            task.resume()
        }
    }
}

extension NetworkClient: @retroactive DependencyKey {
    public static let liveValue: NetworkClient = {
        #if DEBUG
        let interceptors: [NetworkInterceptor] = [PulseNetworkInterceptor(label: "Network")]
        #else
        let interceptors: [NetworkInterceptor] = []
        #endif

        return Self(
            provider: NetworkProvider(interceptors: interceptors),
            tokenProvider: nil
        )
    }()

    public static func live(
        tokenProvider: @escaping @Sendable () async -> String?
    ) -> NetworkClient {
        #if DEBUG
        let interceptors: [NetworkInterceptor] = [PulseNetworkInterceptor(label: "Network")]
        #else
        let interceptors: [NetworkInterceptor] = []
        #endif

        return Self(
            provider: NetworkProvider(interceptors: interceptors),
            tokenProvider: tokenProvider
        )
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
            let jsonData = data.isEmpty ? Data("{}".utf8) : data

            guard let decodedResponse = try? JSONDecoder().decode(T.self, from: jsonData) else {
                throw NetworkError.decodingError
            }
            return decodedResponse
            
        case HTTPStatusCode.unauthorized:
            throw NetworkError.authorizationError
            
        case HTTPStatusCode.notFound:
            throw NetworkError.notFoundError

        case HTTPStatusCode.badRequest:
            throw NetworkError.badRequestError
            
        case HTTPStatusCode.serverError:
            throw NetworkError.serverError
            
        default:
            throw NetworkError.unknownError
        }
    }
}
