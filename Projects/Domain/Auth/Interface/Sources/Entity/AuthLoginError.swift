//
//  AuthLoginError.swift
//  DomainAuthInterface
//
//  Created by Jiyong
//

import Foundation

/// 인증 과정에서 발생할 수 있는 에러를 나타냅니다.
public enum AuthLoginError: Error {
    /// 지원하지 않는 로그인 제공자
    case unsupportedProvider

    /// 필수 인증 정보 누락 (identityToken 등)
    case missingCredential

    /// 사용자가 로그인을 취소함
    case userCanceled

    /// OAuth 제공자에서 발생한 에러
    case providerError(Error)

    /// 서버 API 호출 실패
    case serverError

    /// 네트워크 연결 실패
    case networkError(Error)

    /// 토큰 저장 실패
    case storageFailed(Error)
}

// MARK: - LocalizedError

extension AuthLoginError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .unsupportedProvider:
            return "지원하지 않는 로그인 방식입니다."
            
        case .missingCredential:
            return "인증 정보를 가져올 수 없습니다."
            
        case .userCanceled:
            return "로그인이 취소되었습니다."
            
        case .providerError(let error):
            return "로그인 실패: \(error.localizedDescription)"
            
        case .serverError:
            return "서버 오류가 발생했습니다."
            
        case .networkError(let error):
            return "네트워크 오류: \(error.localizedDescription)"
            
        case .storageFailed(let error):
            return "토큰 저장 실패: \(error.localizedDescription)"
        }
    }
}
