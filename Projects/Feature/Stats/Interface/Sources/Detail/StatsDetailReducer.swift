//
//  StatsDetailReducer.swift
//  FeatureStatsInterface
//
//  Created by 정지훈 on 2/19/26.
//

import Foundation

import ComposableArchitecture

/// 통계 상세 화면의 상태와 액션을 관리하는 Reducer입니다.
///
/// ## 사용 예시
/// ```swift
/// let store = Store(
///     initialState: StatsDetailReducer.State()
/// ) {
///     StatsDetailReducer(reducer: Reduce { _, _ in .none })
/// }
/// ```
@Reducer
public struct StatsDetailReducer {
    let reducer: Reduce<State, Action>

    /// 통계 상세 화면에서 사용하는 상태입니다.
    @ObservableState
    public struct State: Equatable {
        /// 기본 상태를 생성합니다.
        ///
        /// ## 사용 예시
        /// ```swift
        /// let state = StatsDetailReducer.State()
        /// ```
        public init() { }
    }

    /// 통계 상세 화면에서 발생 가능한 액션입니다.
    public enum Action {
        case onAppear
    }

    /// 외부에서 주입된 Reduce로 StatsDetailReducer를 구성합니다.
    ///
    /// ## 사용 예시
    /// ```swift
    /// let reducer = StatsDetailReducer(
    ///     reducer: Reduce { _, _ in .none }
    /// )
    /// ```
    public init(reducer: Reduce<State, Action>) {
        self.reducer = reducer
    }

    public var body: some ReducerOf<Self> {
        reducer
    }
}
