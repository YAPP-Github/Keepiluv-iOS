//
//  OnboardingEndpoint.swift
//  DomainOnboarding
//

import CoreNetworkInterface
import Foundation

/// Onboarding 관련 API 엔드포인트를 정의합니다.
enum OnboardingEndpoint: Endpoint {
    /// 내 초대 코드 조회
    case fetchInviteCode

    /// 커플 연결
    case connectCouple(inviteCode: String)

    /// 프로필 등록
    case registerProfile(nickname: String)

    /// 기념일 설정
    case setAnniversary(date: String)

    /// 온보딩 상태 조회
    case fetchStatus

    var baseURL: URL {
        guard let urlString = Configuration.apiBaseURL,
              let url = URL(string: urlString) else {
            return Configuration.fallbackURL
        }
        return url
    }

    var path: String {
        switch self {
        case .fetchInviteCode:
            return "/api/v1/onboarding/invite-code"

        case .connectCouple:
            return "/api/v1/onboarding/couple-connection"

        case .registerProfile:
            return "/api/v1/onboarding/profile"

        case .setAnniversary:
            return "/api/v1/onboarding/anniversary"

        case .fetchStatus:
            return "/api/v1/onboarding/status"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .fetchInviteCode, .fetchStatus:
            return .get

        case .connectCouple, .registerProfile, .setAnniversary:
            return .post
        }
    }

    var headers: [String: String]? {
        ["Content-Type": "application/json"]
    }

    var query: [URLQueryItem]? {
        nil
    }

    var body: Encodable? {
        switch self {
        case .fetchInviteCode, .fetchStatus:
            return nil

        case .connectCouple(let inviteCode):
            return CoupleConnectionRequest(inviteCode: inviteCode)

        case .registerProfile(let nickname):
            return ProfileRequest(nickname: nickname)

        case .setAnniversary(let date):
            return AnniversaryRequest(anniversaryDate: date)
        }
    }

    var requiresAuth: Bool { true }

    var featureTag: FeatureTag { .onboarding }
}

// MARK: - Configuration

private enum Configuration {
    static let fallbackURL = URL(string: "https://httpbin.org")! // swiftlint:disable:this force_unwrapping

    static var apiBaseURL: String? {
        ProcessInfo.processInfo.environment["API_BASE_URL"] ??
        Bundle.main.object(forInfoDictionaryKey: "API_BASE_URL") as? String
    }
}

// MARK: - Request DTOs

struct CoupleConnectionRequest: Encodable {
    let inviteCode: String
}

struct ProfileRequest: Encodable {
    let nickname: String
}

struct AnniversaryRequest: Encodable {
    let anniversaryDate: String
}
