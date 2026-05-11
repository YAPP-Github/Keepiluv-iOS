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

// MARK: - Case Name

extension AuthLoginError {
    public var caseName: String {
        switch self {
        case .unsupportedProvider: return "unsupportedProvider"
        case .missingCredential:   return "missingCredential"
        case .userCanceled:        return "userCanceled"
        case .providerError:       return "providerError"
        case .serverError:         return "serverError"
        case .networkError:        return "networkError"
        case .storageFailed:       return "storageFailed"
        case .tokenRefreshFailed:  return "tokenRefreshFailed"
        }
    }
}

// MARK: - CustomNSError

extension AuthLoginError: CustomNSError {
    public static var errorDomain: String { "org.yapp.twix.auth" }

    public var errorCode: Int {
        switch self {
        case .unsupportedProvider: return 1
        case .missingCredential:   return 2
        case .userCanceled:        return 3
        case .providerError:       return 4
        case .serverError:         return 5
        case .networkError:        return 6
        case .storageFailed:       return 7
        case .tokenRefreshFailed:  return 8
        }
    }

    public var errorUserInfo: [String: Any] {
        var info: [String: Any] = [
            NSLocalizedDescriptionKey: errorDescription ?? localizedDescription
        ]
        switch self {
        case .providerError(let underlying),
             .networkError(let underlying),
             .storageFailed(let underlying):
            info[NSUnderlyingErrorKey] = underlying as NSError
        default:
            break
        }
        return info
    }
}
