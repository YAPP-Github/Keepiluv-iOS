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
        var isRestoreCoupleSheetPresented: Bool = false
        var shareContent: String
        var myInviteCode: String

        public init(shareContent: String = "", myInviteCode: String = "") {
            self.shareContent = shareContent
            self.myInviteCode = myInviteCode
        }
    }

    public enum Action: BindableAction {
        // MARK: - Binding
        case binding(BindingAction<State>)

        // MARK: - User Action
        case directConnectCardTapped
        case sendInvitationButtonTapped
        case logoutButtonTapped
        case restoreCoupleButtonTapped

        // MARK: - Update State
        case shareSheetDismissed
        case restoreCoupleSheetDismissed

        // MARK: - Delegate
        case delegate(Delegate)

        public enum Delegate: Equatable {
            case navigateToCodeInput
            case logoutRequested
        }
    }

    public init() {}

    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding:
                return .none

            case .directConnectCardTapped:
                return .send(.delegate(.navigateToCodeInput))

            case .sendInvitationButtonTapped:
                state.isShareSheetPresented = true
                return .none

            case .logoutButtonTapped:
                return .send(.delegate(.logoutRequested))

            case .restoreCoupleButtonTapped:
                state.isRestoreCoupleSheetPresented = true
                return .none

            case .shareSheetDismissed:
                state.isShareSheetPresented = false
                return .none

            case .restoreCoupleSheetDismissed:
                state.isRestoreCoupleSheetPresented = false
                return .none

            case .delegate:
                return .none
            }
        }
    }
}
