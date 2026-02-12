//
//  NetworkProviderProtocol.swift
//  CoreNetworkInterfcae
//
//  Created by 정지훈 on 12/26/25.
//

import Foundation

/// 네트워크 요청을 수행하는 프로토콜입니다.
///
/// ## 사용 예시
/// ```swift
/// let provider: NetworkProviderProtocol = NetworkProvider()
/// let profile: UserProfile = try await provider.request(endpoint: UserEndpoint.profile)
/// ```
public protocol NetworkProviderProtocol: Sendable {
    /// 네트워크 요청을 수행합니다.
    ///
    /// ## 사용 예시
    /// ```swift
    /// let profile: UserProfile = try await provider.request(endpoint: UserEndpoint.profile)
    /// ```
    func request<T: Decodable>(endpoint: Endpoint) async throws -> T

    /// 응답 본문 없이 네트워크 요청을 수행합니다.
    ///
    /// DELETE 등 응답 본문이 없는 요청에 사용합니다.
    ///
    /// ## 사용 예시
    /// ```swift
    /// try await provider.requestWithoutResponse(endpoint: PhotoLogEndpoint.deletePhotoLog(photoLogId: 1))
    /// ```
    func requestWithoutResponse(endpoint: Endpoint) async throws
}
