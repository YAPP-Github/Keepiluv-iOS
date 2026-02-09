//
//  Endpoint.swift
//  CoreNetworkInterfcae
//
//  Created by 정지훈 on 12/26/25.
//

import Foundation

/// 네트워크 요청을 호출하는 Feature를 구분하기 위한 태그입니다.
public enum FeatureTag: String {
    case auth = "Auth"
    case onboarding = "Onboarding"
    case home = "Home"
    case goal = "Goal"
    case proopPhoto = "ProofPhoto"
    case unknown = "Unknown"
}

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
    var requiresAuth: Bool { get }
    var featureTag: FeatureTag { get }
}

// MARK: - Default Values

public extension Endpoint {
    var requiresAuth: Bool { false }
    var featureTag: FeatureTag { .unknown }
    
    var baseURL: URL {
        let fallbackURL = URL(string: "https://httpbin.org")! // swiftlint:disable:this force_unwrapping
        
        let apiBaseURL: String? = ProcessInfo.processInfo.environment["API_BASE_URL"] ??
        Bundle.main.object(forInfoDictionaryKey: "API_BASE_URL") as? String
        
        guard let urlString = apiBaseURL,
              let url = URL(string: urlString) else {
            return fallbackURL
        }
        return url
    }
}
