//
//  StatsDetailReducer+Impl.swift
//  FeatureStats
//
//  Created by 정지훈 on 2/19/26.
//

import Foundation

import ComposableArchitecture
import FeatureStatsInterface

extension StatsDetailReducer {
    /// 기본 구성의 StatsDetailReducer를 생성합니다.
    ///
    /// ## 사용 예시
    /// ```swift
    /// let reducer = StatsDetailReducer()
    /// ```
    public init() {
        let reducer = Reduce<State, Action> { state, action in
            switch action {
            case .onAppear:
                return .none
            }
        }

        self.init(reducer: reducer)
    }
}
