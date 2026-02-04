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
    case signInWithApple(code: String)

    /// Kakao 로그인
    case signInWithKakao(code: String)

    /// Google 로그인
    case signInWithGoogle(code: String)

    /// 로그아웃
    case logout

    /// 토큰 갱신
    case refresh(refreshToken: String)

    var baseURL: URL {
        guard let urlString = Configuration.apiBaseURL,
              let url = URL(string: urlString) else {
            return Configuration.fallbackURL
        }
        return url
    }

    var path: String {
        switch self {
        case .signInWithApple:
            return "/api/v1/auth/apple"

        case .signInWithKakao:
            return "/api/v1/auth/kakao"

        case .signInWithGoogle:
            return "/api/v1/auth/google"

        case .logout:
            return "/api/v1/auth/logout"

        case .refresh:
            return "/api/v1/auth/refresh"
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
        case .signInWithApple(let code),
             .signInWithKakao(let code),
             .signInWithGoogle(let code):
            return SignInRequest(code: code)

        case .logout:
            return nil

        case .refresh(let refreshToken):
            return RefreshRequest(refreshToken: refreshToken)
        }
    }

    var requiresAuth: Bool {
        switch self {
        case .logout:
            return true

        case .signInWithApple, .signInWithKakao, .signInWithGoogle, .refresh:
            return false
        }
    }

    var featureTag: FeatureTag { .auth }
}

// MARK: - Configuration

private enum Configuration {
    /// Fallback URL for development/testing
    static let fallbackURL = URL(string: "https://httpbin.org")! // swiftlint:disable:this force_unwrapping

    static var apiBaseURL: String? {
        ProcessInfo.processInfo.environment["API_BASE_URL"] ??
        Bundle.main.object(forInfoDictionaryKey: "API_BASE_URL") as? String
    }
}

// MARK: - Request DTOs

/// 로그인 요청 DTO
private struct SignInRequest: Encodable {
    let code: String
}

/// 토큰 갱신 요청 DTO
private struct RefreshRequest: Encodable {
    let refreshToken: String
}
