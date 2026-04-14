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
import SharedDesignSystem
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
    public init() {
        let reducer = Reduce<SettingsReducer.State, SettingsReducer.Action> { state, action in
            switch action {
            case .view(let viewAction):
                return reduceView(state: &state, action: viewAction)

            case .internal(let internalAction):
                return reduceInternal(state: &state, action: internalAction)

            case .response(let responseAction):
                return reduceResponse(state: &state, action: responseAction)

            case .presentation(let presentationAction):
                return reducePresentation(state: &state, action: presentationAction)

            case .binding(\.data.nickname):
                if state.data.nickname.count > SettingsReducer.State.maxLength {
                    state.data.nickname = String(state.data.nickname.prefix(SettingsReducer.State.maxLength))
                }
                return .none

            case .binding:
                return .none

            case .delegate:
                return .none
            }
        }
        self.init(reducer: reducer)
    }
}

// MARK: - View

// swiftlint:disable:next function_body_length
private func reduceView(
    state: inout SettingsReducer.State,
    action: SettingsReducer.Action.View
) -> Effect<SettingsReducer.Action> {
    switch action {
    case .backButtonTapped:
        return .send(.delegate(.navigateBack))

    case .subViewBackButtonTapped:
        return .send(.delegate(.navigateBackFromSubView))

    case .editButtonTapped:
        state.ui.isEditing = true
        return .none

    case .clearButtonTapped:
        state.data.nickname = ""
        return .none

    case .languageSettingTapped:
        state.presentation.modal = .selectList(
            title: "언어 설정",
            subtitle: "이미 앱 내에 저장된 언어는 변경되지 않아요",
            options: SettingsReducer.State.languageOptions.map { $0.title },
            selectedIndex: SettingsReducer.State.languageOptions.firstIndex(of: state.ui.selectedLanguage) ?? 0,
            leftButtonText: "취소",
            rightButtonText: "완료"
        )
        return .none

    case .accountTapped:
        return .send(.delegate(.navigateToAccount))

    case .infoTapped:
        return .send(.delegate(.navigateToInfo))

    case .logoutTapped:
        guard !state.ui.isLoading else { return .none }
        @Dependency(\.authClient) var authClient
        @Dependency(\.pushClient) var pushClient
        @Dependency(\.notificationClient) var notificationClient

        state.ui.isLoading = true
        return .run { send in
            if let token = try? await pushClient.getFCMToken() {
                try? await notificationClient.deleteFCMToken(token)
            }
            do {
                try await authClient.signOut()
                await send(.response(.logoutResponse(.success(()))))
            } catch {
                await send(.response(.logoutResponse(.failure(error))))
            }
        }

    case .disconnectCoupleTapped:
        state.presentation.modalPurpose = .disconnectCouple
        state.presentation.modal = .info(
            image: .Icon.Illustration.modalWarning,
            title: "정말 커플을 끊으시겠어요?",
            subtitle: """
            오늘부로 30일 후, 모든 데이터가 삭제됩니다.
            복구 가능 기간은 30일 이내입니다.
            복구 희망시 ttwixteamm@gmail.com로
            문의해 주시기 바랍니다.
            """,
            leftButtonText: "취소",
            rightButtonText: "해제"
        )
        return .none

    case .withdrawTapped:
        state.presentation.modalPurpose = .withdraw
        state.presentation.modal = .info(
            image: .Icon.Illustration.modalWarning,
            title: "정말 탈퇴하시겠어요?",
            subtitle: """
            커플 연결이 끊어집니다.
            데이터는 전부 삭제되며 복구가 불가능합니다.
            """,
            leftButtonText: "취소",
            rightButtonText: "탈퇴"
        )
        return .none

    case .modalConfirmTapped:
        guard !state.ui.isLoading else { return .none }
        @Dependency(\.authClient) var authClient

        switch state.presentation.modalPurpose {
        case .disconnectCouple:
            // TODO: 커플 끊기 API 호출
            break
        case .withdraw:
            state.ui.isLoading = true
            return .run { send in
                do {
                    try await authClient.withdraw()
                    await send(.response(.withdrawResponse(.success(()))))
                } catch {
                    await send(.response(.withdrawResponse(.failure(error))))
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

    case .inquiryTapped:
        @Dependency(\.openURL) var openURL
        guard let url = URL(string: "http://pf.kakao.com/_znAzX/chat") else {
            return .none
        }
        return .run { _ in
            await openURL(url)
        }

    case .notificationSettingTapped:
        return .send(.delegate(.navigateToNotificationSettings))

    case .pokePushToggled(let enabled):
        @Dependency(\.notificationClient) var notificationClient
        state.ui.isPokePushEnabled = enabled
        return .run { send in
            do {
                let settings = try await notificationClient.updatePokeSetting(enabled)
                await send(.response(.updateNotificationSettingResponse(.success(settings))))
            } catch {
                await send(.response(.updateNotificationSettingResponse(.failure(error))))
            }
        }.cancellable(id: "pokePushToggle", cancelInFlight: true)

    case .marketingPushToggled(let enabled):
        @Dependency(\.notificationClient) var notificationClient
        state.ui.isMarketingPushEnabled = enabled
        return .run { send in
            do {
                let settings = try await notificationClient.updateMarketingSetting(enabled)
                await send(.response(.updateNotificationSettingResponse(.success(settings))))
            } catch {
                await send(.response(.updateNotificationSettingResponse(.failure(error))))
            }
        }.cancellable(id: "marketingPushToggle", cancelInFlight: true)

    case .nightPushToggled(let enabled):
        @Dependency(\.notificationClient) var notificationClient
        state.ui.isNightMarketingPushEnabled = enabled
        return .run { send in
            do {
                let settings = try await notificationClient.updateNightSetting(enabled)
                await send(.response(.updateNotificationSettingResponse(.success(settings))))
            } catch {
                await send(.response(.updateNotificationSettingResponse(.failure(error))))
            }
        }.cancellable(id: "nightPushToggle", cancelInFlight: true)

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

// MARK: - Internal

// swiftlint:disable:next function_body_length
private func reduceInternal(
    state: inout SettingsReducer.State,
    action: SettingsReducer.Action.Internal
) -> Effect<SettingsReducer.Action> {
    switch action {
    case .onAppear:
        @Dependency(\.authClient) var authClient
        @Dependency(\.onboardingClient) var onboardingClient

        state.data.appVersion = AppVersionProvider.currentVersion
        return .merge(
            .run { send in
                let storeVersion = await AppVersionProvider.fetchStoreVersion()
                await send(.internal(.storeVersionResponse(storeVersion)))
            },
            .run { send in
                do {
                    let profile = try await authClient.fetchMyProfile()
                    await send(.response(.fetchMyProfileResponse(.success(profile.name))))
                } catch {
                    await send(.response(.fetchMyProfileResponse(.failure(error))))
                }
            },
            .run { send in
                do {
                    let coupleCode = try await onboardingClient.fetchInviteCode()
                    await send(.response(.fetchCoupleCodeResponse(.success(coupleCode))))
                } catch {
                    await send(.response(.fetchCoupleCodeResponse(.failure(error))))
                }
            }
        )

    case .storeVersionResponse(let version):
        state.data.storeVersion = version ?? "-"
        return .none

    case .nicknameEditingEnded:
        return handleNicknameEditingEnded(state: &state)

    case .notificationSettingsOnAppear:
        @Dependency(\.notificationClient) var notificationClient

        let checkPermissionEffect: Effect<SettingsReducer.Action> = .run { send in
            let settings = await UNUserNotificationCenter.current().notificationSettings()
            let isEnabled = settings.authorizationStatus == .authorized
            await send(.response(.checkSystemNotificationResponse(isEnabled)))
        }

        guard !state.ui.isNotificationSettingsLoading else {
            return checkPermissionEffect
        }

        state.ui.isNotificationSettingsLoading = true
        return .merge(
            checkPermissionEffect,
            .run { send in
                do {
                    let notificationSettings = try await notificationClient.fetchSettings()
                    await send(.response(.fetchNotificationSettingsResponse(.success(notificationSettings))))
                } catch {
                    await send(.response(.fetchNotificationSettingsResponse(.failure(error))))
                }
            }
        )

    case .languageConfirmed(let index):
        guard SettingsReducer.State.languageOptions.indices.contains(index) else {
            return .none
        }
        state.ui.selectedLanguage = SettingsReducer.State.languageOptions[index]
        // TODO: 언어 설정 저장 로직 구현
        return .none
    }
}

// MARK: - Response

// swiftlint:disable:next function_body_length
private func reduceResponse(
    state: inout SettingsReducer.State,
    action: SettingsReducer.Action.Response
) -> Effect<SettingsReducer.Action> {
    switch action {
    case .updateNicknameResponse(.success):
        state.ui.isLoading = false
        state.data.originalNickname = state.data.nickname
        state.ui.isEditing = false
        return .none

    case .updateNicknameResponse(.failure(let error)):
        state.ui.isLoading = false
        state.data.nickname = state.data.originalNickname
        state.ui.isEditing = false
        if let networkError = error as? NetworkError,
           networkError == .authorizationError {
            return .send(.delegate(.sessionExpired))
        }
        return .none

    case .fetchMyProfileResponse(.success(let name)):
        state.data.nickname = name
        state.data.originalNickname = name
        return .none

    case .fetchMyProfileResponse(.failure(let error)):
        if let networkError = error as? NetworkError,
           networkError == .authorizationError {
            return .send(.delegate(.sessionExpired))
        }
        return .none

    case .fetchCoupleCodeResponse(.success(let coupleCode)):
        state.data.coupleCode = coupleCode
        return .none

    case .fetchCoupleCodeResponse(.failure(let error)):
        if let networkError = error as? NetworkError,
           networkError == .authorizationError {
            return .send(.delegate(.sessionExpired))
        }
        return .none

    case .logoutResponse(.success):
        state.ui.isLoading = false
        return .send(.delegate(.logoutCompleted))

    case .logoutResponse(.failure(let error)):
        state.ui.isLoading = false
        if let networkError = error as? NetworkError,
           networkError == .authorizationError {
            return .send(.delegate(.sessionExpired))
        }
        return .send(.presentation(.showToast(.warning(message: "로그아웃에 실패했어요"))))

    case .withdrawResponse(.success):
        state.ui.isLoading = false
        return .send(.delegate(.withdrawCompleted))

    case .withdrawResponse(.failure(let error)):
        state.ui.isLoading = false
        if let networkError = error as? NetworkError,
           networkError == .authorizationError {
            return .send(.delegate(.sessionExpired))
        }
        return .send(.presentation(.showToast(.warning(message: "회원 탈퇴에 실패했어요"))))

    case .fetchNotificationSettingsResponse(.success(let settings)):
        state.ui.isNotificationSettingsLoading = false
        state.ui.isPokePushEnabled = settings.isPushEnabled
        state.ui.isMarketingPushEnabled = settings.isMarketingEnabled
        state.ui.isNightMarketingPushEnabled = settings.isNightEnabled
        return .none

    case .fetchNotificationSettingsResponse(.failure(let error)):
        state.ui.isNotificationSettingsLoading = false
        if let networkError = error as? NetworkError,
           networkError == .authorizationError {
            return .send(.delegate(.sessionExpired))
        }
        return .none

    case .updateNotificationSettingResponse(.success(let settings)):
        state.ui.isPokePushEnabled = settings.isPushEnabled
        state.ui.isMarketingPushEnabled = settings.isMarketingEnabled
        state.ui.isNightMarketingPushEnabled = settings.isNightEnabled
        return .none

    case .updateNotificationSettingResponse(.failure(let error)):
        if let networkError = error as? NetworkError,
           networkError == .authorizationError {
            return .send(.delegate(.sessionExpired))
        }
        return .send(.internal(.notificationSettingsOnAppear))

    case .checkSystemNotificationResponse(let isEnabled):
        state.ui.isSystemNotificationEnabled = isEnabled
        return .none
    }
}

// MARK: - Presentation

private func reducePresentation(
    state: inout SettingsReducer.State,
    action: SettingsReducer.Action.Presentation
) -> Effect<SettingsReducer.Action> {
    switch action {
    case let .showToast(toast):
        state.presentation.toast = toast
        return .none
    }
}

// MARK: - Helpers

private func handleNicknameEditingEnded(
    state: inout SettingsReducer.State
) -> Effect<SettingsReducer.Action> {
    guard state.ui.isEditing else { return .none }

    if ProfanityFilter.containsProfanity(state.data.nickname) {
        state.data.nickname = state.data.originalNickname
        state.ui.isEditing = false
        return .none
    }

    guard state.isNicknameLengthValid else {
        state.data.nickname = state.data.originalNickname
        state.ui.isEditing = false
        return .none
    }

    guard state.isNicknameChanged else {
        state.ui.isEditing = false
        return .none
    }

    let nickname = state.data.nickname
    state.ui.isLoading = true
    return .run { send in
        @Dependency(\.onboardingClient) var onboardingClient

        do {
            try await onboardingClient.updateProfile(nickname)
            await send(.response(.updateNicknameResponse(.success(()))))
        } catch {
            await send(.response(.updateNicknameResponse(.failure(error))))
        }
    }
}
