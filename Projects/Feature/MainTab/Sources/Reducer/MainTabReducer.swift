//
//  MainTabStore.swift
//  Feature
//
//  Created by 정지훈 on 1/4/26.
//

import Foundation

import ComposableArchitecture
import CoreLogging
import FeatureHome
import FeatureHomeInterface
import SharedDesignSystem

/// 앱의 메인 탭 화면을 관리하는 Reducer입니다.
///
/// 홈, 통계, 커플, 마이페이지 탭으로 구성된 메인 화면의 상태와 액션을 처리합니다.
///
/// ## 사용 예시
/// ```swift
/// let store = Store(
///     initialState: MainTabReducer.State(),
///     reducer: { MainTabReducer() }
/// )
/// ```
@Reducer
public struct MainTabReducer {
    @ObservableState
    public struct State {
        public var home = RootHomeReducer.State()
        public var modal: TXModalType?
        public var selectedTab: TXTabItem = .home
        
        public init() { }
    }

    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        
        // MARK: - Reducer
        case home(RootHomeReducer.Action)
        
        // MARK: - User Action
        case selectedTabChanged(TXTabItem)

        // MARK: - Modal
        case modalConfirmTapped

    }

    public init() { }

    public var body: some ReducerOf<Self> {
        BindingReducer()
        
        Scope(state: \.home, action: \.home) {
            RootHomeReducer()
        }

        Reduce { state, action in
            switch action {
                // MARK: - User Action
            case let .selectedTabChanged(tab):
                state.selectedTab = tab
                
                return .none

            case .modalConfirmTapped:
                state.modal = nil
                return .send(.home(.home(.modalConfirmTapped)))
                
            case .home(.delegate(.showDeleteGoalModal)):
                state.modal = .deleteGoal
                return .none

            case .home:
                return .none
                
            case .binding:
                return .none
            }
        }
    }
}
