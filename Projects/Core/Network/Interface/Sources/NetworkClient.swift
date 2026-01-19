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

    public init(provider: any NetworkProviderProtocol) {
        self.provider = provider
    }

    /// 네트워크 요청을 수행합니다.
    ///
    /// ## 사용 예시
    /// ```swift
    /// let profile: UserProfile = try await networkClient.request(endpoint: UserEndpoint.profile)
    /// ```
    public func request<T: Decodable>(endpoint: Endpoint) async throws -> T {
        try await provider.request(endpoint: endpoint)
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
