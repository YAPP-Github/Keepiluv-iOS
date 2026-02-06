//
//  NetworkClient.swift
//  CoreNetworkInterface
//
//  Created by 정지훈 on 12/26/25.
//

import ComposableArchitecture
import Foundation

/// TCA Dependency로 주입 가능한 네트워크 클라이언트입니다.
///
/// ## 사용 예시
/// ```swift
/// @Dependency(\.networkClient) var networkClient
/// let profile: UserProfile = try await networkClient.request(endpoint: UserEndpoint.profile)
/// ```
public struct NetworkClient: Sendable {
    private let provider: any NetworkProviderProtocol
    private let tokenProvider: (@Sendable () async -> String?)?

    public init(
        provider: any NetworkProviderProtocol,
        tokenProvider: (@Sendable () async -> String?)? = nil
    ) {
        self.provider = provider
        self.tokenProvider = tokenProvider
    }

    /// 네트워크 요청을 수행합니다.
    ///
    /// `endpoint.requiresAuth`가 true인 경우, Authorization 헤더에 Bearer 토큰을 자동으로 추가합니다.
    ///
    /// ## 사용 예시
    /// ```swift
    /// let profile: UserProfile = try await networkClient.request(endpoint: UserEndpoint.profile)
    /// ```
    public func request<T: Decodable>(endpoint: Endpoint) async throws -> T {
        var finalEndpoint = endpoint

        // 인증이 필요하고 토큰이 있으면 헤더에 추가
        if endpoint.requiresAuth, let tokenProvider, let token = await tokenProvider() {
            finalEndpoint = AuthenticatedEndpointWrapper(base: endpoint, token: token)
        }

        return try await provider.request(endpoint: finalEndpoint)
    }
}

// MARK: - Authenticated Endpoint Wrapper

/// 인증 헤더가 추가된 Endpoint Wrapper
private struct AuthenticatedEndpointWrapper: Endpoint {
    let base: Endpoint
    let token: String

    var baseURL: URL { base.baseURL }
    var path: String { base.path }
    var method: HTTPMethod { base.method }
    var query: [URLQueryItem]? { base.query }
    var body: Encodable? { base.body }
    var requiresAuth: Bool { base.requiresAuth }

    var headers: [String: String]? {
        var headers = base.headers ?? [:]
        headers["Authorization"] = "Bearer \(token)"
        return headers
    }
}

private struct UnimplementedNetworkProvider: NetworkProviderProtocol {
    func request<T: Decodable>(endpoint: Endpoint) async throws -> T {
        assertionFailure("NetworkClient.request is unimplemented. Use withDependencies to override.")
        throw NetworkError.unknownError
    }
}

extension NetworkClient: TestDependencyKey {
    public static let testValue = Self(provider: UnimplementedNetworkProvider())
}

public extension DependencyValues {
    var networkClient: NetworkClient {
        get { self[NetworkClient.self] }
        set { self[NetworkClient.self] = newValue }
    }
}
