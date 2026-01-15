//
//  MainTabStore.swift
//  Feature
//
//  Created by 정지훈 on 1/4/26.
//

import ComposableArchitecture
import CoreLogging
import Foundation

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
    public struct State: Equatable {
        public init() { }
    }

    public enum Action {
        case onAppear
    }

    public init() { }

    @Dependency(\.mainTabLogger)
    var logger

    public var body: some ReducerOf<Self> {
        Reduce { _, action in
            switch action {
            case .onAppear:
                return .none
            }
        }
    }
}

extension DependencyValues {
    var mainTabLogger: TXLogger {
        get { self[MainTabLoggerKey.self] }
        set { self[MainTabLoggerKey.self] = newValue }
    }
}

private enum MainTabLoggerKey: DependencyKey {
    static let liveValue: TXLogger = {
        return TXLogger(label: "MainTab")
    }()
}
