//
//  NotificationReducer.swift
//  FeatureNotificationInterface
//
//  Created by Jiyong on 02/21/26.
//

import ComposableArchitecture
import Foundation

/// 알림 화면의 상태와 액션을 정의하는 리듀서입니다.
@Reducer
public struct NotificationReducer {
    private let reducer: Reduce<State, Action>

    /// 알림 화면의 상태입니다.
    @ObservableState
    public struct State: Equatable {
        public var notifications: IdentifiedArrayOf<NotificationItem>

        public init(
            notifications: IdentifiedArrayOf<NotificationItem> = []
        ) {
            self.notifications = notifications
        }
    }

    /// 알림 화면에서 발생하는 액션입니다.
    public enum Action: BindableAction {
        case binding(BindingAction<State>)

        // MARK: - User Action
        case backButtonTapped
        case notificationTapped(NotificationItem)

        // MARK: - Lifecycle
        case onAppear

        // MARK: - Delegate
        case delegate(Delegate)

        public enum Delegate: Equatable {
            case navigateBack
            case notificationSelected(NotificationItem)
        }
    }

    public init(reducer: Reduce<State, Action>) {
        self.reducer = reducer
    }

    public var body: some ReducerOf<Self> {
        BindingReducer()
        reducer
    }
}
