//
//  OnboardingCoordinator.swift
//  FeatureOnboarding
//
//  Created by Jiyong on 01/28/26.
//

import ComposableArchitecture
import Foundation

/// 온보딩 플로우 전체를 관리하는 Coordinator Reducer입니다.
///
/// Connect → CodeInput 화면 전환을 NavigationStack으로 관리합니다.
///
/// ## 사용 예시
/// ```swift
/// let store = Store(
///     initialState: OnboardingCoordinator.State(myInviteCode: "KDJ34923"),
///     reducer: { OnboardingCoordinator() }
/// )
/// ```
@Reducer
public struct OnboardingCoordinator {
    @ObservableState
    public struct State: Equatable {
        var path = StackState<Path.State>()
        var connect: OnboardingConnectReducer.State
        var myInviteCode: String

        public init(
            myInviteCode: String = "",
            shareContent: String = ""
        ) {
            self.myInviteCode = myInviteCode
            self.connect = OnboardingConnectReducer.State(shareContent: shareContent)
        }
    }

    public enum Action {
        case path(StackActionOf<Path>)
        case connect(OnboardingConnectReducer.Action)
        case delegate(Delegate)

        @CasePathable
        public enum Delegate: Equatable {
            case navigateBack
            case onboardingCompleted
        }
    }

    @Reducer(state: .equatable)
    public enum Path {
        case codeInput(OnboardingCodeInputReducer)
    }

    public init() {}

    public var body: some ReducerOf<Self> {
        Scope(state: \.connect, action: \.connect) {
            OnboardingConnectReducer()
        }

        Reduce { state, action in
            switch action {
            case .connect(.delegate(.navigateBack)):
                return .send(.delegate(.navigateBack))

            case .connect(.delegate(.navigateToCodeInput)):
                state.path.append(
                    .codeInput(OnboardingCodeInputReducer.State(myInviteCode: state.myInviteCode))
                )
                return .none

            case .connect:
                return .none

            case .path(.element(id: _, action: .codeInput(.delegate(.navigateBack)))):
                state.path.removeLast()
                return .none

            case .path(.element(id: _, action: .codeInput(.delegate(.coupleConnected)))):
                return .send(.delegate(.onboardingCompleted))

            case .path:
                return .none

            case .delegate:
                return .none
            }
        }
        .forEach(\.path, action: \.path)
    }
}
