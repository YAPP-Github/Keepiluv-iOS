//
//  OnboardingProfileReducer.swift
//  FeatureOnboarding
//
//  Created by Jiyong on 01/28/26.
//

import ComposableArchitecture
import DomainOnboardingInterface
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
    @Dependency(\.onboardingClient)
    private var onboardingClient

    @ObservableState
    public struct State: Equatable {
        var nickname: String = ""
        var toast: TXToastType?
        var isLoading: Bool = false

        static let minLength = 2
        static let maxLength = 8

        public init() {}
    }

    public enum Action: BindableAction {
        // MARK: - Binding
        case binding(BindingAction<State>)

        // MARK: - User Action
        case backButtonTapped
        case completeButtonTapped

        // MARK: - API Response
        case registerProfileResponse(Result<Void, Error>)

        // MARK: - Delegate
        case delegate(Delegate)

        public enum Delegate: Equatable {
            case navigateBack
            case profileCompleted
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
                guard !state.isLoading else { return .none }

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

                state.isLoading = true
                let nickname = state.nickname
                return .run { send in
                    do {
                        try await onboardingClient.registerProfile(nickname)
                        await send(.registerProfileResponse(.success(())))
                    } catch {
                        await send(.registerProfileResponse(.failure(error)))
                    }
                }

            case .registerProfileResponse(.success):
                state.isLoading = false
                return .send(.delegate(.profileCompleted))

            case let .registerProfileResponse(.failure(error)):
                state.isLoading = false
                // 이미 온보딩이 완료된 경우 (G4000), 성공과 동일하게 처리
                if let onboardingError = error as? OnboardingError,
                   onboardingError == .alreadyOnboarded {
                    return .send(.delegate(.profileCompleted))
                }
                state.toast = .fit(message: "프로필 등록에 실패했어요. 다시 시도해주세요")
                return .none

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
