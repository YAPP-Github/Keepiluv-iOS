//
//  NotificationReducer+Impl.swift
//  FeatureNotification
//
//  Created by Jiyong on 02/21/26.
//

import ComposableArchitecture
import FeatureNotificationInterface
import Foundation

extension NotificationReducer {
    /// 기본 구현을 제공하는 리듀서를 생성합니다.
    public init() {
        let reducer = Reduce<NotificationReducer.State, NotificationReducer.Action> { state, action in
            reduceCore(state: &state, action: action)
        }
        self.init(reducer: reducer)
    }
}

// MARK: - Core Reduce Logic

private func reduceCore(
    state: inout NotificationReducer.State,
    action: NotificationReducer.Action
) -> Effect<NotificationReducer.Action> {
    switch action {
    case .binding:
        return .none

    case .onAppear:
        // TODO: API 호출로 알림 목록 가져오기
        return .none

    case .backButtonTapped:
        return .send(.delegate(.navigateBack))

    case .notificationTapped(let item):
        return .send(.delegate(.notificationSelected(item)))

    case .delegate:
        return .none
    }
}
