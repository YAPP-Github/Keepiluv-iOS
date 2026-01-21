//
//  GoogleLoginProvider.swift
//  DomainAuth
//
//
//  Created by Jiyong
//

import DomainAuthInterface
import Foundation
@preconcurrency import GoogleSignIn
import UIKit

/// Google 로그인을 수행하는 Provider입니다.
///
/// Google Sign-In SDK를 사용하여 Google OAuth 로그인을 처리하고,
/// idToken을 획득하여 AuthLoginResult로 변환합니다.
@preconcurrency
public final class GoogleLoginProvider: SocialLoginProviderProtocol {
    public var providerType: AuthProvider { .google }

    public init() {}

    @MainActor
    public func performLogin() async throws -> AuthLoginResult {
        let rootViewController = try getRootViewController()
        let clientID = try getClientID()

        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        do {
            let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)
            return try extractAuthResult(from: result)
        } catch {
            throw AuthLoginError.providerError(error)
        }
    }
}

// MARK: - Private Helpers

private extension GoogleLoginProvider {
    @MainActor
    func getRootViewController() throws -> UIViewController {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = windowScene.windows.first?.rootViewController else {
            throw AuthLoginError.providerError(
                NSError(domain: "GoogleLoginProvider", code: -1, userInfo: [
                    NSLocalizedDescriptionKey: "rootViewController를 찾을 수 없습니다."
                ])
            )
        }
        return rootViewController
    }

    func getClientID() throws -> String {
        enum ErrorCode {
            static let missingClientID = -2
        }

        guard let clientID = Bundle.main.object(forInfoDictionaryKey: "GOOGLE_CLIENT_ID") as? String else {
            throw AuthLoginError.providerError(
                NSError(domain: "GoogleLoginProvider", code: ErrorCode.missingClientID, userInfo: [
                    NSLocalizedDescriptionKey: "GOOGLE_CLIENT_ID가 설정되지 않았습니다."
                ])
            )
        }
        return clientID
    }

    func extractAuthResult(from result: GIDSignInResult) throws -> AuthLoginResult {
        guard let idToken = result.user.idToken?.tokenString else {
            throw AuthLoginError.missingCredential
        }

        return AuthLoginResult(
            provider: .google,
            identityToken: idToken,
            authorizationCode: result.serverAuthCode
        )
    }
}
