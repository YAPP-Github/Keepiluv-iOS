//
//  OnboardingError.swift
//  DomainOnboardingInterface
//

import Foundation

/// 온보딩 과정에서 발생할 수 있는 에러를 나타냅니다.
public enum OnboardingError: Error, Equatable {
    case invalidInviteCode
    case inviteCodeNotFound
    case alreadyConnected
    case alreadyOnboarded
    case networkError
    case serverError
    case unknown
}

// MARK: - LocalizedError

extension OnboardingError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .invalidInviteCode:
            return "유효하지 않은 초대 코드입니다."

        case .inviteCodeNotFound:
            return "초대 코드를 찾을 수 없습니다."

        case .alreadyConnected:
            return "이미 커플이 연결되어 있습니다."

        case .alreadyOnboarded:
            return "이미 온보딩이 완료되었습니다."

        case .networkError:
            return "네트워크 연결을 확인해주세요."

        case .serverError:
            return "서버 오류가 발생했습니다."

        case .unknown:
            return "알 수 없는 오류가 발생했습니다."
        }
    }
}
