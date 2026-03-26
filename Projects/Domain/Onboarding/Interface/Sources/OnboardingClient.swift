//
//  OnboardingClient.swift
//  DomainOnboardingInterface
//

import ComposableArchitecture
import Foundation

/// Onboarding 관련 비즈니스 로직을 제공하는 Client입니다.
///
/// TCA의 Dependency 시스템을 통해 주입되며,
/// 각 함수는 closure로 구현되어 테스트 시 쉽게 mock 가능합니다.
///
/// 인증 실패(401)는 NetworkError.authorizationError로 전달됩니다.
///
/// ## 사용 예시
/// ```swift
/// @Dependency(\.onboardingClient) var onboardingClient
///
/// let inviteCode = try await onboardingClient.fetchInviteCode()
/// ```
public struct OnboardingClient: Sendable {
    public var fetchInviteCode: @Sendable () async throws -> String

    public var connectCouple: @Sendable (_ inviteCode: String) async throws -> Void

    public var registerProfile: @Sendable (_ nickname: String) async throws -> Void

    public var updateProfile: @Sendable (_ nickname: String) async throws -> Void

    public var setAnniversary: @Sendable (_ date: Date) async throws -> Void

    public var fetchStatus: @Sendable () async throws -> OnboardingStatus

    public init(
        fetchInviteCode: @escaping @Sendable () async throws -> String,
        connectCouple: @escaping @Sendable (_ inviteCode: String) async throws -> Void,
        registerProfile: @escaping @Sendable (_ nickname: String) async throws -> Void,
        updateProfile: @escaping @Sendable (_ nickname: String) async throws -> Void,
        setAnniversary: @escaping @Sendable (_ date: Date) async throws -> Void,
        fetchStatus: @escaping @Sendable () async throws -> OnboardingStatus
    ) {
        self.fetchInviteCode = fetchInviteCode
        self.connectCouple = connectCouple
        self.registerProfile = registerProfile
        self.updateProfile = updateProfile
        self.setAnniversary = setAnniversary
        self.fetchStatus = fetchStatus
    }
}

// MARK: - TestDependencyKey

extension OnboardingClient: TestDependencyKey {
    /// Preview에서 사용할 기본값입니다.
    public static var previewValue = Self(
        fetchInviteCode: { "ABC123" },
        connectCouple: { _ in },
        registerProfile: { _ in },
        updateProfile: { _ in },
        setAnniversary: { _ in },
        fetchStatus: { .coupleConnection }
    )

    /// 테스트에서 사용할 기본값입니다.
    public static let testValue = Self(
        fetchInviteCode: {
            assertionFailure("OnboardingClient.fetchInviteCode가 구현되지 않았습니다.")
            throw OnboardingError.unknown
        },
        connectCouple: { _ in
            assertionFailure("OnboardingClient.connectCouple이 구현되지 않았습니다.")
            throw OnboardingError.unknown
        },
        registerProfile: { _ in
            assertionFailure("OnboardingClient.registerProfile이 구현되지 않았습니다.")
            throw OnboardingError.unknown
        },
        updateProfile: { _ in
            assertionFailure("OnboardingClient.updateProfile이 구현되지 않았습니다.")
            throw OnboardingError.unknown
        },
        setAnniversary: { _ in
            assertionFailure("OnboardingClient.setAnniversary가 구현되지 않았습니다.")
            throw OnboardingError.unknown
        },
        fetchStatus: {
            assertionFailure("OnboardingClient.fetchStatus가 구현되지 않았습니다.")
            throw OnboardingError.unknown
        }
    )
}

// MARK: - DependencyValues Extension

extension DependencyValues {
    public var onboardingClient: OnboardingClient {
        get { self[OnboardingClient.self] }
        set { self[OnboardingClient.self] = newValue }
    }
}
