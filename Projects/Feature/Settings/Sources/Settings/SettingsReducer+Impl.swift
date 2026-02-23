//
//  SettingsReducer+Impl.swift
//  FeatureSettings
//
//  Created by Jiyong on 02/05/26.
//

import ComposableArchitecture
import CoreNetworkInterface
import CorePushInterface
import DomainAuthInterface
import DomainNotificationInterface
import DomainOnboardingInterface
import FeatureSettingsInterface
import Foundation
import SharedUtil
import UIKit
import UserNotifications

extension SettingsReducer {
    /// 기본 구현을 제공하는 리듀서를 생성합니다.
    ///
    /// ## 사용 예시
    /// ```swift
    /// let store = Store(
    ///     initialState: SettingsReducer.State(nickname: "김민정"),
    ///     reducer: { SettingsReducer() }
    /// )
    /// ```
    // swiftlint:disable function_body_length
    public init() {
        let reducer = Reduce<SettingsReducer.State, SettingsReducer.Action> { state, action in
            reduceCore(state: &state, action: action)
        }
        self.init(reducer: reducer)
    }
    // swiftlint:enable function_body_length
}

// MARK: - Core Reduce Logic

// swiftlint:disable function_body_length
private func reduceCore(
    state: inout SettingsReducer.State,
    action: SettingsReducer.Action
) -> Effect<SettingsReducer.Action> {
    switch action {
    case .binding(\.nickname):
        if state.nickname.count > SettingsReducer.State.maxLength {
            state.nickname = String(state.nickname.prefix(SettingsReducer.State.maxLength))
        }
        return .none

    case .binding:
        return .none

    case .onAppear:
        @Dependency(\.authClient) var authClient
        @Dependency(\.onboardingClient) var onboardingClient

        state.appVersion = AppVersionProvider.currentVersion
        return .merge(
            .run { send in
                let storeVersion = await AppVersionProvider.fetchStoreVersion()
                await send(.storeVersionResponse(storeVersion))
            },
            .run { send in
                do {
                    let profile = try await authClient.fetchMyProfile()
                    await send(.fetchMyProfileResponse(.success(profile.name)))
                } catch {
                    await send(.fetchMyProfileResponse(.failure(error)))
                }
            },
            .run { send in
                do {
                    let coupleCode = try await onboardingClient.fetchInviteCode()
                    await send(.fetchCoupleCodeResponse(.success(coupleCode)))
                } catch {
                    await send(.fetchCoupleCodeResponse(.failure(error)))
                }
            }
        )

    case .storeVersionResponse(let version):
        state.storeVersion = version ?? "-"
        return .none

    case .backButtonTapped:
        return .send(.delegate(.navigateBack))

    case .subViewBackButtonTapped:
        return .send(.delegate(.navigateBackFromSubView))

    case .editButtonTapped:
        state.isEditing = true
        return .none

    case .clearButtonTapped:
        state.nickname = ""
        return .none

    case .nicknameEditingEnded:
        return handleNicknameEditingEnded(state: &state)

    case .updateNicknameResponse(.success):
        state.isLoading = false
        state.originalNickname = state.nickname
        state.isEditing = false
        return .none

    case .updateNicknameResponse(.failure(let error)):
        state.isLoading = false
        state.nickname = state.originalNickname
        state.isEditing = false
        if let networkError = error as? NetworkError,
           networkError == .authorizationError {
            return .send(.delegate(.sessionExpired))
        }
        return .none

    case .languageSettingTapped:
        state.isLanguageModalPresented = true
        return .none

    case .languageConfirmed:
        state.isLanguageModalPresented = false
        // TODO: 언어 설정 저장 로직 구현
        return .none

    case .accountTapped:
        return .send(.delegate(.navigateToAccount))

    case .infoTapped:
        return .send(.delegate(.navigateToInfo))

    case .logoutTapped:
        guard !state.isLoading else { return .none }
        @Dependency(\.authClient) var authClient
        @Dependency(\.pushClient) var pushClient
        @Dependency(\.notificationClient) var notificationClient

        state.isLoading = true
        return .run { send in
            // FCM 토큰 삭제 (실패해도 로그아웃 진행)
            if let token = try? await pushClient.getFCMToken() {
                try? await notificationClient.deleteFCMToken(token)
            }

            do {
                try await authClient.signOut()
                await send(.logoutResponse(.success(())))
            } catch {
                await send(.logoutResponse(.failure(error)))
            }
        }

    case .disconnectCoupleTapped:
        state.modal = .info(.disconnectCouple)
        return .none

    case .withdrawTapped:
        state.modal = .info(.withdraw)
        return .none

    case .modalConfirmTapped:
        guard !state.isLoading else { return .none }
        @Dependency(\.authClient) var authClient

        switch state.modal {
        case .info(.disconnectCouple):
            // TODO: 커플 끊기 API 호출
            break
        case .info(.withdraw):
            state.isLoading = true
            return .run { send in
                do {
                    try await authClient.withdraw()
                    await send(.withdrawResponse(.success(())))
                } catch {
                    await send(.withdrawResponse(.failure(error)))
                }
            }
        default:
            break
        }
        return .none

    case .privacyPolicyTapped:
        if let url = URL(string: "https://incongruous-sweatshirt-b32.notion.site/Keepliuv-3024eb2e10638051824ef9ac7f9a522f") {
            return .send(.delegate(.navigateToWebView(url: url, title: "개인정보 처리방침")))
        }
        return .none

    case .notificationSettingTapped:
        return .send(.delegate(.navigateToNotificationSettings))

    case .fetchMyProfileResponse(.success(let name)):
        state.nickname = name
        state.originalNickname = name
        return .none

    case .fetchMyProfileResponse(.failure(let error)):
        if let networkError = error as? NetworkError,
           networkError == .authorizationError {
            return .send(.delegate(.sessionExpired))
        }
        return .none

    case .fetchCoupleCodeResponse(.success(let coupleCode)):
        state.coupleCode = coupleCode
        return .none

    case .fetchCoupleCodeResponse(.failure(let error)):
        if let networkError = error as? NetworkError,
           networkError == .authorizationError {
            return .send(.delegate(.sessionExpired))
        }
        return .none

    case .logoutResponse(.success):
        state.isLoading = false
        return .send(.delegate(.logoutCompleted))

    case .logoutResponse(.failure(let error)):
        state.isLoading = false
        if let networkError = error as? NetworkError,
           networkError == .authorizationError {
            return .send(.delegate(.sessionExpired))
        }
        return .send(.showToast(.warning(message: "로그아웃에 실패했어요")))

    case .withdrawResponse(.success):
        state.isLoading = false
        return .send(.delegate(.withdrawCompleted))

    case .withdrawResponse(.failure(let error)):
        state.isLoading = false
        if let networkError = error as? NetworkError,
           networkError == .authorizationError {
            return .send(.delegate(.sessionExpired))
        }
        return .send(.showToast(.warning(message: "회원 탈퇴에 실패했어요")))

    case let .showToast(toast):
        state.toast = toast
        return .none

    case .inquiryTapped:
        @Dependency(\.openURL) var openURL
        guard let url = URL(string: "http://pf.kakao.com/_znAzX/chat") else {
            return .none
        }
        return .run { _ in
            await openURL(url)
        }

    case .delegate:
        return .none

    // MARK: - Notification Settings

    case .notificationSettingsOnAppear:
        @Dependency(\.notificationClient) var notificationClient

        let checkPermissionEffect: Effect<SettingsReducer.Action> = .run { send in
            let settings = await UNUserNotificationCenter.current().notificationSettings()
            let isEnabled = settings.authorizationStatus == .authorized
            await send(.checkSystemNotificationResponse(isEnabled))
        }

        guard !state.isNotificationSettingsLoading else {
            return checkPermissionEffect
        }

        state.isNotificationSettingsLoading = true
        return .merge(
            checkPermissionEffect,
            .run { send in
                do {
                    let notificationSettings = try await notificationClient.fetchSettings()
                    await send(.fetchNotificationSettingsResponse(.success(notificationSettings)))
                } catch {
                    await send(.fetchNotificationSettingsResponse(.failure(error)))
                }
            }
        )

    case .fetchNotificationSettingsResponse(.success(let settings)):
        state.isNotificationSettingsLoading = false
        state.isPokePushEnabled = settings.isPushEnabled
        state.isMarketingPushEnabled = settings.isMarketingEnabled
        state.isNightMarketingPushEnabled = settings.isNightEnabled
        return .none

    case .fetchNotificationSettingsResponse(.failure(let error)):
        state.isNotificationSettingsLoading = false
        if let networkError = error as? NetworkError,
           networkError == .authorizationError {
            return .send(.delegate(.sessionExpired))
        }
        return .none

    case .pokePushToggled(let enabled):
        @Dependency(\.notificationClient) var notificationClient
        // 낙관적 업데이트
        state.isPokePushEnabled = enabled
        return .run { send in
            do {
                let settings = try await notificationClient.updatePokeSetting(enabled)
                await send(.updateNotificationSettingResponse(.success(settings)))
            } catch {
                await send(.updateNotificationSettingResponse(.failure(error)))
            }
        }.cancellable(id: "pokePushToggle", cancelInFlight: true)

    case .marketingPushToggled(let enabled):
        @Dependency(\.notificationClient) var notificationClient
        // 낙관적 업데이트
        state.isMarketingPushEnabled = enabled
        return .run { send in
            do {
                let settings = try await notificationClient.updateMarketingSetting(enabled)
                await send(.updateNotificationSettingResponse(.success(settings)))
            } catch {
                await send(.updateNotificationSettingResponse(.failure(error)))
            }
        }.cancellable(id: "marketingPushToggle", cancelInFlight: true)

    case .nightPushToggled(let enabled):
        @Dependency(\.notificationClient) var notificationClient
        // 낙관적 업데이트
        state.isNightMarketingPushEnabled = enabled
        return .run { send in
            do {
                let settings = try await notificationClient.updateNightSetting(enabled)
                await send(.updateNotificationSettingResponse(.success(settings)))
            } catch {
                await send(.updateNotificationSettingResponse(.failure(error)))
            }
        }.cancellable(id: "nightPushToggle", cancelInFlight: true)

    case .updateNotificationSettingResponse(.success(let settings)):
        // 서버 응답으로 상태 동기화
        state.isPokePushEnabled = settings.isPushEnabled
        state.isMarketingPushEnabled = settings.isMarketingEnabled
        state.isNightMarketingPushEnabled = settings.isNightEnabled
        return .none

    case .updateNotificationSettingResponse(.failure(let error)):
        // 실패 시 서버에서 다시 가져오기
        if let networkError = error as? NetworkError,
           networkError == .authorizationError {
            return .send(.delegate(.sessionExpired))
        }
        return .send(.notificationSettingsOnAppear)

    case let .checkSystemNotificationResponse(isEnabled):
        state.isSystemNotificationEnabled = isEnabled
        return .none

    case .enableNotificationBannerTapped:
        return .run { _ in
            await MainActor.run {
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
            }
        }
    }
}
// swiftlint:enable function_body_length

private func handleNicknameEditingEnded(
    state: inout SettingsReducer.State
) -> Effect<SettingsReducer.Action> {
    guard state.isEditing else { return .none }

    if ProfanityFilter.containsProfanity(state.nickname) {
        state.nickname = state.originalNickname
        state.isEditing = false
        return .none
    }

    guard state.isNicknameLengthValid else {
        state.nickname = state.originalNickname
        state.isEditing = false
        return .none
    }

    guard state.isNicknameChanged else {
        state.isEditing = false
        return .none
    }

    state.isLoading = true
    return .run { send in
        try? await Task.sleep(for: .milliseconds(500))
        await send(.updateNicknameResponse(.success(())))
    }
}
