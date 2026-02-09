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

    /// 최대 시도 횟수 (원본 1회 + 재시도 1회)
    private let maxAttempts = 2

    /// NetworkProvider를 생성합니다.
    /// - Parameter interceptors: 네트워크 요청을 intercept할 Interceptor 배열 (기본값: 빈 배열)
    public init(interceptors: [NetworkInterceptor] = []) {
        self.session = URLSession.shared
        self.interceptors = interceptors
    }

    public func request<T: Decodable>(endpoint: Endpoint) async throws -> T {
        guard let url = makeURL(endpoint: endpoint) else {
            throw NetworkError.invalidURLError
        }

        let baseRequest = try makeURLRequest(url: url, endpoint: endpoint)
        var context = RequestContext(endpoint: endpoint, request: baseRequest)

        // Adapt: 모든 interceptor에게 요청 수정 기회 제공
        for interceptor in interceptors {
            context = try await interceptor.adapt(context)
        }

        var attemptCount = 0

        while attemptCount < maxAttempts {
            attemptCount += 1

            do {
                return try await performRequest(context: context)
            } catch {
                // Retry: interceptor에게 재시도 결정 요청
                var shouldRetry = false

                for interceptor in interceptors {
                    let decision = await interceptor.retry(context, dueTo: error, attemptCount: attemptCount)

                    if case .retry(let newRequest) = decision {
                        context.request = newRequest
                        shouldRetry = true
                        break
                    }
                }

                if !shouldRetry {
                    throw error
                }
            }
        }

        // maxAttempts 초과 시 마지막 요청 수행
        return try await performRequest(context: context)
    }

    // MARK: - Private

    private func performRequest<T: Decodable>(context: RequestContext) async throws -> T {
        let featureTag = context.endpoint.featureTag.rawValue

        return try await withCheckedThrowingContinuation { continuation in
            var createdTask: URLSessionDataTask?
            let task = session.dataTask(with: context.request) { [interceptors] data, response, error in
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

        return Self(provider: NetworkProvider(interceptors: interceptors))
    }()

    /// 커스텀 interceptor를 사용하는 NetworkClient를 생성합니다.
    ///
    /// - Parameter interceptors: 적용할 NetworkInterceptor 배열
    /// - Returns: 구성된 NetworkClient
    public static func live(
        interceptors: [NetworkInterceptor]
    ) -> NetworkClient {
        Self(provider: NetworkProvider(interceptors: interceptors))
    }
}


private extension NetworkProvider {
    struct APIErrorResponse: Decodable {
        let code: String?
    }

    func parseErrorCode(from data: Data) -> String? {
        try? JSONDecoder().decode(APIErrorResponse.self, from: data).code
    }

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
            let errorCode = parseErrorCode(from: data)
            throw NetworkError.badRequestError(code: errorCode)
            
        case HTTPStatusCode.serverError:
            throw NetworkError.serverError
            
        default:
            throw NetworkError.unknownError
        }
    }
}
