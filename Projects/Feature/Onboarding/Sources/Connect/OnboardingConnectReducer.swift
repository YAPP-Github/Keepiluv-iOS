//
//  OnboardingConnectReducer.swift
//  FeatureOnboarding
//
//  Created by Jiyong on 01/28/26.
//

import ComposableArchitecture
import Foundation

/// 커플 연결 온보딩 화면을 관리하는 Reducer입니다.
///
/// 짝꿍 초대장 보내기(Share Sheet) 및 직접 연결하기 기능을 제공합니다.
///
/// ## 사용 예시
/// ```swift
/// let store = Store(
///     initialState: OnboardingConnectReducer.State(),
///     reducer: { OnboardingConnectReducer() }
/// )
/// ```
@Reducer
public struct OnboardingConnectReducer {
    @ObservableState
    public struct State: Equatable {
        var isShareSheetPresented: Bool = false
        var shareContent: String

        public init(shareContent: String = "") {
            self.shareContent = shareContent
        }
    }

    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        case backButtonTapped
        case directConnectCardTapped
        case sendInvitationButtonTapped
        case shareSheetDismissed
        case delegate(Delegate)

        @CasePathable
        public enum Delegate: Equatable {
            case navigateBack
            case navigateToCodeInput
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

            case .directConnectCardTapped:
                return .send(.delegate(.navigateToCodeInput))

            case .sendInvitationButtonTapped:
                state.isShareSheetPresented = true
                return .none

            case .shareSheetDismissed:
                state.isShareSheetPresented = false
                return .none

            case .delegate:
                return .none
            }
        }
    }
}
