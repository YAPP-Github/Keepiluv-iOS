//
//  AppleLoginProvider.swift
//  DomainAuth
//
//
//  Created by Jiyong
//

import AuthenticationServices
import DomainAuthInterface
import Foundation

/// Apple Sign In을 수행하는 Provider입니다.
///
/// ASAuthorizationController를 사용하여 Apple OAuth 로그인을 처리하고,
/// identityToken을 획득하여 AuthLoginResult로 변환합니다.
public final class AppleLoginProvider: NSObject, SocialLoginProviderProtocol {
    public var providerType: AuthProvider { .apple }

    private var continuation: CheckedContinuation<AuthLoginResult, Error>?

    override public init() {
        super.init()
    }

    public func performLogin() async throws -> AuthLoginResult {
        try await withCheckedThrowingContinuation { continuation in
            self.continuation = continuation

            let appleIDProvider = ASAuthorizationAppleIDProvider()
            let request = appleIDProvider.createRequest()
            request.requestedScopes = [.fullName, .email]

            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
            authorizationController.delegate = self
            authorizationController.presentationContextProvider = self
            authorizationController.performRequests()
        }
    }
}

// MARK: - ASAuthorizationControllerDelegate

extension AppleLoginProvider: ASAuthorizationControllerDelegate {
    public func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithAuthorization authorization: ASAuthorization
    ) {
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential else {
            continuation?.resume(throwing: AuthLoginError.missingCredential)
            continuation = nil
            return
        }

        guard let identityTokenData = appleIDCredential.identityToken,
              let identityToken = String(data: identityTokenData, encoding: .utf8) else {
            continuation?.resume(throwing: AuthLoginError.missingCredential)
            continuation = nil
            return
        }

        let authorizationCode: String? = {
            guard let codeData = appleIDCredential.authorizationCode else { return nil }
            return String(data: codeData, encoding: .utf8)
        }()

        let result = AuthLoginResult(
            provider: .apple,
            identityToken: identityToken,
            authorizationCode: authorizationCode
        )

        continuation?.resume(returning: result)
        continuation = nil
    }

    public func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithError error: Error
    ) {
        if let authError = error as? ASAuthorizationError,
            authError.code == .canceled {
            continuation?.resume(throwing: AuthLoginError.userCanceled)
        } else {
            continuation?.resume(throwing: AuthLoginError.providerError(error))
        }
        continuation = nil
    }
}

// MARK: - ASAuthorizationControllerPresentationContextProviding

extension AppleLoginProvider: ASAuthorizationControllerPresentationContextProviding {
    public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            fatalError("No window available for Apple Sign In presentation")
        }
        return window
    }
}

private extension PersonNameComponents {
    func formatted() -> String {
        var parts: [String] = []
        if let familyName = self.familyName { parts.append(familyName) }
        if let givenName = self.givenName { parts.append(givenName) }
        return parts.joined(separator: " ")
    }
}
