//
//  NotificationReducer+Impl.swift
//  FeatureNotification
//
//  Created by Jiyong on 02/21/26.
//

import ComposableArchitecture
import DomainNotificationInterface
import FeatureNotificationInterface
import Foundation

extension NotificationReducer {
    /// 기본 구현을 제공하는 리듀서를 생성합니다.
    public init() {
        @Dependency(\.notificationClient) var notificationClient

        let reducer = Reduce<NotificationReducer.State, NotificationReducer.Action> { state, action in
            reduceCore(state: &state, action: action, notificationClient: notificationClient)
        }
        self.init(reducer: reducer)
    }
}

// MARK: - Core Reduce Logic

// swiftlint:disable:next function_body_length
private func reduceCore(
    state: inout NotificationReducer.State,
    action: NotificationReducer.Action,
    notificationClient: NotificationClient
) -> Effect<NotificationReducer.Action> {
    switch action {
    case .binding:
        return .none

    case .onAppear:
        return handleOnAppear(state: &state, notificationClient: notificationClient)

    case .fetchListResponse(.success(let result)):
        state.isLoading = false
        state.notifications = IdentifiedArray(
            uniqueElements: result.notifications.map { NotificationItem(from: $0) }
        )
        state.hasNext = result.hasNext
        state.lastId = result.lastId
        return .none

    case .fetchListResponse(.failure):
        state.isLoading = false
        return .none

    case .loadMore:
        return handleLoadMore(state: &state, notificationClient: notificationClient)

    case .fetchMoreResponse(.success(let result)):
        state.isLoadingMore = false
        let newItems = result.notifications.map { NotificationItem(from: $0) }
        for item in newItems {
            state.notifications.append(item)
        }
        state.hasNext = result.hasNext
        state.lastId = result.lastId
        return .none

    case .fetchMoreResponse(.failure):
        state.isLoadingMore = false
        return .none

    case .backButtonTapped:
        return .send(.delegate(.navigateBack))

    case .notificationTapped(let item):
        return handleNotificationTapped(item: item, notificationClient: notificationClient)

    case .markAsReadResponse(let item, .success):
        state.notifications.remove(id: item.id)
        return .send(.delegate(.notificationSelected(item)))

    case .markAsReadResponse(let item, .failure):
        return .send(.delegate(.notificationSelected(item)))

    case .delegate:
        return .none
    }
}

// MARK: - Action Handlers

private func handleOnAppear(
    state: inout NotificationReducer.State,
    notificationClient: NotificationClient
) -> Effect<NotificationReducer.Action> {
    guard !state.isLoading else { return .none }
    state.isLoading = true
    return .run { send in
        do {
            let result = try await notificationClient.fetchList(nil, 10)
            await send(.fetchListResponse(.success(result)))

            try? await notificationClient.markAllAsRead()
        } catch {
            await send(.fetchListResponse(.failure(error)))
        }
    }
}

private func handleLoadMore(
    state: inout NotificationReducer.State,
    notificationClient: NotificationClient
) -> Effect<NotificationReducer.Action> {
    guard !state.isLoadingMore,
          state.hasNext,
          let lastId = state.lastId else {
        return .none
    }

    state.isLoadingMore = true
    return .run { send in
        do {
            let result = try await notificationClient.fetchList(lastId, 20)
            await send(.fetchMoreResponse(.success(result)))
        } catch {
            await send(.fetchMoreResponse(.failure(error)))
        }
    }
}

private func handleNotificationTapped(
    item: NotificationItem,
    notificationClient: NotificationClient
) -> Effect<NotificationReducer.Action> {
    guard !item.isRead else {
        return .send(.delegate(.notificationSelected(item)))
    }

    return .run { send in
        do {
            try await notificationClient.markAsRead(item.id)
            await send(.markAsReadResponse(item, .success(())))
        } catch {
            await send(.markAsReadResponse(item, .failure(error)))
        }
    }
}
