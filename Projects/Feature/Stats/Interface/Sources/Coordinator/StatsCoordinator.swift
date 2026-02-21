//
//  StatsCoordinatorReducer.swift
//  FeatureStats
//
//  Created by 정지훈 on 2/19/26.
//

import Foundation

import ComposableArchitecture

/// Stats Feature의 NavigationStack 흐름을 관리하는 Coordinator Reducer입니다.
///
/// ## 사용 예시
/// ```swift
/// let store = Store(
///     initialState: StatsCoordinator.State()
/// ) {
///     StatsCoordinator(
///         statsReducer: StatsReducer(reducer: Reduce { _, _ in .none }),
///         statsDetailReducer: StatsDetailReducer(reducer: Reduce { _, _ in .none }),
///         reducer: Reduce { _, _ in .none }
///     )
/// }
/// ```
@Reducer
public struct StatsCoordinator {
    private let statsReducer: StatsReducer
    private let statsDetailReducer: StatsDetailReducer
    
    private let reducer: Reduce<State, Action>
    
    /// StatsCoordinator 화면에서 사용하는 상태입니다.
    @ObservableState
    public struct State: Equatable {
        public var routes: [StatsRoute] = []
        public var stats = StatsReducer.State()
        public var detail: StatsDetailReducer.State?
        
        /// 기본 상태를 생성합니다.
        ///
        /// ## 사용 예시
        /// ```swift
        /// let state = StatsCoordinator.State()
        /// ```
        public init() { }
    }
    
    /// StatsCoordinator 화면에서 발생 가능한 액션입니다.
    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        
        case stats(StatsReducer.Action)
        case detail(StatsDetailReducer.Action)
    }
    
    /// 외부에서 주입된 Reduce와 하위 Reducer로 StatsCoordinator를 구성합니다.
    ///
    /// ## 사용 예시
    /// ```swift
    /// let coordinator = StatsCoordinator(
    ///     statsReducer: StatsReducer(reducer: Reduce { _, _ in .none }),
    ///     statsDetailReducer: StatsDetailReducer(reducer: Reduce { _, _ in .none }),
    ///     reducer: Reduce { _, _ in .none }
    /// )
    /// ```
    public init(
        statsReducer: StatsReducer,
        statsDetailReducer: StatsDetailReducer,
        reducer: Reduce<State, Action>
    ) {
        self.statsReducer = statsReducer
        self.statsDetailReducer = statsDetailReducer
        self.reducer = reducer
    }
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        
        Scope(state: \.stats, action: \.stats) {
            statsReducer
        }
        
        reducer
            .ifLet(\.detail, action: \.detail) {
                statsDetailReducer
            }
    }
}
