//
//  AuthEndpoint.swift
//  DomainAuth
//
//
//  Created by Jiyong
//

import CoreNetworkInterface
import Foundation

/// Auth 관련 API 엔드포인트를 정의합니다.
enum AuthEndpoint: Endpoint {
    /// Apple 로그인
    case signInWithApple(identityToken: String)

    /// Kakao 로그인
    case signInWithKakao(accessToken: String)

    /// Google 로그인
    case signInWithGoogle(idToken: String)

    var baseURL: URL {
        guard let urlString = Configuration.apiBaseURL,
              let url = URL(string: urlString) else {
            return URL(string: "https://httpbin.org")!
        }
        return url
    }

    var path: String {
        switch self {
        case .signInWithApple:
            return Configuration.isProduction ? "/api/auth/signin/apple" : "/post"
            
        case .signInWithKakao:
            return Configuration.isProduction ? "/api/auth/signin/kakao" : "/post"
            
        case .signInWithGoogle:
            return Configuration.isProduction ? "/api/auth/signin/google" : "/post"
        }
    }

    var method: HTTPMethod {
        .post
    }

    var headers: [String: String]? {
        ["Content-Type": "application/json"]
    }

    var query: [URLQueryItem]? {
        nil
    }

    var body: Encodable? {
        switch self {
        case .signInWithApple(let identityToken):
            return SignInRequest(identityToken: identityToken, provider: "apple")
            
        case .signInWithKakao(let accessToken):
            return SignInRequest(accessToken: accessToken, provider: "kakao")
            
        case .signInWithGoogle(let idToken):
            return SignInRequest(idToken: idToken, provider: "google")
        }
    }
}

// MARK: - Configuration

private enum Configuration {
    static var apiBaseURL: String? {
        ProcessInfo.processInfo.environment["API_BASE_URL"] ??
        Bundle.main.object(forInfoDictionaryKey: "API_BASE_URL") as? String
    }

    static var isProduction: Bool {
        apiBaseURL != nil && !apiBaseURL!.contains("httpbin")
    }
}

// MARK: - Request/Response DTOs

/// 로그인 요청 DTO
private struct SignInRequest: Encodable {
    let identityToken: String?
    let accessToken: String?
    let idToken: String?
    let provider: String

    init(identityToken: String, provider: String) {
        self.identityToken = identityToken
        self.accessToken = nil
        self.idToken = nil
        self.provider = provider
    }

    init(accessToken: String, provider: String) {
        self.identityToken = nil
        self.accessToken = accessToken
        self.idToken = nil
        self.provider = provider
    }

    init(idToken: String, provider: String) {
        self.identityToken = nil
        self.accessToken = nil
        self.idToken = idToken
        self.provider = provider
    }
}

/// 로그인 응답 DTO
struct SignInResponse: Decodable {
    let accessToken: String
    let refreshToken: String
    let expiresAt: Date

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
        case expiresAt = "expires_at"
        case url
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        if let accessToken = try? container.decode(String.self, forKey: .accessToken),
           let refreshToken = try? container.decode(String.self, forKey: .refreshToken),
           let expiresAt = try? container.decode(Date.self, forKey: .expiresAt) {
            self.accessToken = accessToken
            self.refreshToken = refreshToken
            self.expiresAt = expiresAt
        } else {
            self.accessToken = "dummy_access_token_\(UUID().uuidString.prefix(8))"
            self.refreshToken = "dummy_refresh_token_\(UUID().uuidString.prefix(8))"
            self.expiresAt = Date().addingTimeInterval(3600)
        }
    }
}
