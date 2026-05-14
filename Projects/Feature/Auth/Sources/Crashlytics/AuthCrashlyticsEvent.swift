//
//  AuthCrashlyticsEvent.swift
//  FeatureAuth
//

import CoreCrashlyticsInterface
import DomainAuthInterface
import Foundation

enum AuthCrashlyticsRecordEvent: CrashlyticsRecordEvent {
    case loginFailed(AuthLoginError?)

    var customKeys: [String: String] {
        switch self {
        case let .loginFailed(error):
            [CrashlyticsKey.authErrorType: errorType(for: error)]
        }
    }

    private func errorType(for error: AuthLoginError?) -> String {
        switch error {
        case .unsupportedProvider: "unsupportedProvider"
        case .missingCredential:   "missingCredential"
        case .userCanceled:        "userCanceled"
        case .providerError:       "providerError"
        case .serverError:         "serverError"
        case .networkError:        "networkError"
        case .storageFailed:       "storageFailed"
        case .tokenRefreshFailed:  "tokenRefreshFailed"
        case .none:                "unknown"
        }
    }
}
