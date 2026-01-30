//
//  OnboardingProfileReducer.swift
//  FeatureOnboarding
//
//  Created by Jiyong on 01/28/26.
//

import ComposableArchitecture
import Foundation
import SharedDesignSystem

/// 프로필 설정(닉네임 입력) 화면을 관리하는 Reducer입니다.
///
/// 2-8자 닉네임을 입력받아 프로필 설정을 완료합니다.
///
/// ## 사용 예시
/// ```swift
/// let store = Store(
///     initialState: OnboardingProfileReducer.State(),
///     reducer: { OnboardingProfileReducer() }
/// )
/// ```
@Reducer
public struct OnboardingProfileReducer {
    /// 프로필 설정 화면의 상태입니다.
    @ObservableState
    public struct State: Equatable {
        /// 닉네임 입력값
        var nickname: String = ""

        /// 토스트 상태
        var toast: TXToastType?

        /// 닉네임 최소 길이
        static let minLength = 2

        /// 닉네임 최대 길이
        static let maxLength = 8

        public init() {}
    }

    public enum Action: BindableAction {
        // MARK: - Binding
        case binding(BindingAction<State>)

        // MARK: - User Action
        case backButtonTapped
        case completeButtonTapped

        // MARK: - Delegate
        case delegate(Delegate)

        public enum Delegate: Equatable {
            case navigateBack
            case profileCompleted(nickname: String)
        }
    }

    public init() {}

    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding:
                return .none

            case .backButtonTapped:
                return .send(.delegate(.navigateBack))

            case .completeButtonTapped:
                // 비속어 체크
                if state.containsProfanity {
                    state.toast = .fit(message: "닉네임에 비속어가 포함되어 있습니다.")
                    return .none
                }

                // 길이 체크
                guard state.isNicknameLengthValid else {
                    state.toast = .fit(message: "2자에서 8자 이내로 닉네임을 입력해주세요.")
                    return .none
                }

                return .send(.delegate(.profileCompleted(nickname: state.nickname)))

            case .delegate:
                return .none
            }
        }
    }
}

// MARK: - Computed Properties

extension OnboardingProfileReducer.State {
    /// 닉네임 길이가 유효한지 여부 (2-8자)
    var isNicknameLengthValid: Bool {
        nickname.count >= Self.minLength && nickname.count <= Self.maxLength
    }

    /// 닉네임에 비속어가 포함되어 있는지 여부
    var containsProfanity: Bool {
        ProfanityFilter.containsProfanity(nickname)
    }

    /// 닉네임이 유효한지 여부 (길이 + 비속어 체크)
    var isNicknameValid: Bool {
        isNicknameLengthValid && !containsProfanity
    }
}
