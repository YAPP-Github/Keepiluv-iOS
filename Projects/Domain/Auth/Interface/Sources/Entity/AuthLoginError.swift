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
        case .userCanceled:
            return "로그인을 취소했어요"

        case .unsupportedProvider,
             .missingCredential,
             .providerError,
             .serverError,
             .networkError,
             .storageFailed,
             .tokenRefreshFailed:
            return "로그인에 실패했어요"
        }
    }
}
