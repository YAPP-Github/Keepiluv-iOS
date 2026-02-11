//
//  MainTabStore.swift
//  Feature
//
//  Created by 정지훈 on 1/4/26.
//

import Foundation

import ComposableArchitecture
import CoreLogging
import FeatureGoalDetail
import FeatureGoalDetailInterface
import FeatureHome
import FeatureHomeInterface
import FeatureProofPhoto
import FeatureProofPhotoInterface
import FeatureSettings
import FeatureSettingsInterface
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
    /// 메인 탭의 화면 상태를 정의합니다.
    ///
    /// ## 사용 예시
    /// ```swift
    /// let state = MainTabReducer.State()
    /// ```
    public struct State: Equatable {
        public var home = HomeCoordinator.State()
        public var selectedTab: TXTabItem = .home
        public var isTabBarHidden: Bool = false
        
        /// 기본 상태를 생성합니다.
        ///
        /// ## 사용 예시
        /// ```swift
        /// let state = MainTabReducer.State()
        /// ```
        public init() { }
    }

    /// 메인 탭에서 발생 가능한 액션을 정의합니다.
    ///
    /// ## 사용 예시
    /// ```swift
    /// store.send(.selectedTabChanged(.home))
    /// ```
    public enum Action: BindableAction {
        case binding(BindingAction<State>)

        // MARK: - Child Action
        case home(HomeCoordinator.Action)

        // MARK: - User Action
        case selectedTabChanged(TXTabItem)

        // MARK: - Temporary Settings Access
        // FIXME: 삭제 예정 - 설정 화면 진입점 확정 후 제거
        case showSettings

        // MARK: - Delegate
        case delegate(Delegate)

        public enum Delegate: Equatable {
            case logoutCompleted
            case withdrawCompleted
            case sessionExpired
        }
    }

    /// 기본 구성의 MainTabReducer를 생성합니다.
    ///
    /// ## 사용 예시
    /// ```swift
    /// let reducer = MainTabReducer()
    /// ```
    public init() { }

    public var body: some ReducerOf<Self> {
        BindingReducer()
        
        Scope(state: \.home, action: \.home) {
            let proofPhotoReducer = ProofPhotoReducer()
            HomeCoordinator(
                goalDetailReducer: GoalDetailReducer(proofPhotoReducer: proofPhotoReducer),
                proofPhotoReducer: proofPhotoReducer,
                makeGoalReducer: MakeGoalReducer(),
                editGoalListReducer: EditGoalListReducer(),
                settingsReducer: SettingsReducer()
            )
        }

        Reduce { state, action in
            switch action {
                // MARK: - User Action
            case .selectedTabChanged:
                switch state.selectedTab {
                case .home:
                    state.isTabBarHidden = !state.home.routes.isEmpty

                case .statistics, .couple, .settings:
                    state.isTabBarHidden = false
                }
                return .none

            // FIXME: 삭제 예정 - 설정 화면 진입점 확정 후 제거
            case .showSettings:
                state.home.settings = SettingsReducer.State()
                state.home.isSettingsPresented = true
                return .none

                // MARK: - Child Action
            case .home(.delegate(.logoutCompleted)):
                return .send(.delegate(.logoutCompleted))

            case .home(.delegate(.withdrawCompleted)):
                return .send(.delegate(.withdrawCompleted))

            case .home(.delegate(.sessionExpired)):
                return .send(.delegate(.sessionExpired))

            // FIXME: 삭제 예정 - 설정 탭 제거 시 함께 제거
            case .home(.settingsDismissed):
                // 설정 화면이 닫히면 홈 탭으로 복귀
                if state.selectedTab == .settings {
                    state.selectedTab = .home
                }
                return .none

            case .home:
                if state.selectedTab == .home {
                    state.isTabBarHidden = !state.home.routes.isEmpty
                }
                return .none

            case .delegate:
                return .none

            case .binding:
                return .none
            }
        }
    }
}
