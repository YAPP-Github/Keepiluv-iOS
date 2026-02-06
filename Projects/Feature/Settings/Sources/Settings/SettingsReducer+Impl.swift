//
//  SettingsReducer+Impl.swift
//  FeatureSettings
//
//  Created by Jiyong on 02/05/26.
//

import ComposableArchitecture
import FeatureSettingsInterface
import Foundation
import SharedUtil

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
        state.appVersion = AppVersionProvider.currentVersion
        return .run { send in
            let storeVersion = await AppVersionProvider.fetchStoreVersion()
            await send(.storeVersionResponse(storeVersion))
        }

    case .storeVersionResponse(let version):
        state.storeVersion = version ?? "-"
        return .none

    case .backButtonTapped:
        return .send(.delegate(.navigateBack))

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

    case .updateNicknameResponse(.failure):
        state.isLoading = false
        state.nickname = state.originalNickname
        state.isEditing = false
        return .none

    case .languageSettingTapped:
        state.isLanguageModalPresented = true
        return .none

    case .languageConfirmed:
        state.isLanguageModalPresented = false
        // TODO: 언어 설정 저장 로직 구현
        return .none

    case .accountTapped:
        state.routes.append(.account)
        return .none

    case .infoTapped:
        state.routes.append(.info)
        return .none

    case .popRoute:
        guard !state.routes.isEmpty else { return .none }
        state.routes.removeLast()
        return .none

    case .logoutTapped:
        // TODO: 로그아웃 로직 구현
        return .none

    case .disconnectCoupleTapped:
        state.modal = .disconnectCouple
        return .none

    case .withdrawTapped:
        state.modal = .withdraw
        return .none

    case .modalConfirmTapped:
        switch state.modal {
        case .disconnectCouple:
            // TODO: 커플 끊기 API 호출
            break
        case .withdraw:
            // TODO: 탈퇴 API 호출
            break
        default:
            break
        }
        return .none

    case .termsOfServiceTapped:
        // TODO: 이용약관 URL 열기
        return .none

    case .privacyPolicyTapped:
        // TODO: 개인정보 처리방침 URL 열기
        return .none

    case .notificationSettingTapped:
        state.routes.append(.notificationSettings)
        return .none

    case .inquiryTapped,
         .delegate:
        return .none
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
