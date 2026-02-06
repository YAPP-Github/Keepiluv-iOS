//
//  AuthLoginError.swift
//  DomainAuthInterface
//
//  Created by Jiyong
//

import Foundation

/// 인증 과정에서 발생할 수 있는 에러를 나타냅니다.
public enum AuthLoginError: Error {
    case unsupportedProvider

    case missingCredential

    case userCanceled

    case providerError(Error)

    case serverError

    case networkError(Error)

    case storageFailed(Error)

    case tokenRefreshFailed
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

        case .tokenRefreshFailed:
            return "토큰 갱신에 실패했습니다."
        }
    }
}
