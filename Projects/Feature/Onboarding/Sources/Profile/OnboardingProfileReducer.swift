//
//  OnboardingProfileReducer.swift
//  FeatureOnboarding
//
//  Created by Jiyong on 01/28/26.
//

import ComposableArchitecture
import Foundation

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

        /// 토스트 표시 여부
        var showToast: Bool = false

        /// 닉네임 최소 길이
        static let minLength = 2

        /// 닉네임 최대 길이
        static let maxLength = 8

        public init() {}
    }

    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        case backButtonTapped
        case completeButtonTapped
        case toastDismissed
        case delegate(Delegate)

        @CasePathable
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
                guard state.isNicknameValid else {
                    state.showToast = true
                    return .none
                }
                return .send(.delegate(.profileCompleted(nickname: state.nickname)))

            case .toastDismissed:
                state.showToast = false
                return .none

            case .delegate:
                return .none
            }
        }
    }
}

// MARK: - Computed Properties

extension OnboardingProfileReducer.State {
    /// 닉네임이 유효한지 여부 (2-8자)
    var isNicknameValid: Bool {
        nickname.count >= Self.minLength && nickname.count <= Self.maxLength
    }
}
