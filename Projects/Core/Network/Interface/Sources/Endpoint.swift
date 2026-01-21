//
//  Endpoint.swift
//  CoreNetworkInterfcae
//
//  Created by 정지훈 on 12/26/25.
//

import Foundation

/// 네트워크 요청의 기본 정보를 정의하는 프로토콜입니다.
///
/// ## 사용 예시
/// ```swift
/// struct UserEndpoint: Endpoint {
///     let baseURL = URL(string: "https://api.example.com")!
///     let path = "/users/me"
///     let method: HTTPMethod = .get
///     let headers: [String: String]? = nil
///     let query: [URLQueryItem]? = nil
///     let body: Encodable? = nil
/// }
/// ```
public protocol Endpoint {
    var baseURL: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    var query: [URLQueryItem]? { get }
    var body: Encodable? { get }
}
