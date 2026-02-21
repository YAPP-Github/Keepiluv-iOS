//
//  NotificationApp.swift
//  FeatureNotificationExample
//
//  Created by Jiyong on 02/21/26.
//

import ComposableArchitecture
import FeatureNotification
import FeatureNotificationInterface
import SharedDesignSystem
import SwiftUI

@main
struct NotificationApp: App {
    var body: some Scene {
        WindowGroup {
            NotificationView(
                store: Store(
                    initialState: NotificationReducer.State(
                        notifications: NotificationApp.mockNotifications
                    ),
                    reducer: {
                        NotificationReducer()
                    }
                )
            )
        }
    }
}

// MARK: - Mock Data

extension NotificationApp {
    static let mockNotifications: IdentifiedArrayOf<NotificationItem> = [
        NotificationItem(
            id: "1",
            message: "닉네임길어도될까님과 연결됐어요!",
            createdAt: Date()
        ),
        NotificationItem(
            id: "2",
            message: "닉네임길어도될까님의 오늘 하루가 등록됐어요. 확인해 볼까요?",
            createdAt: Date()
        ),
        NotificationItem(
            id: "3",
            message: "닉네임길어도될까님이 찔렀어요! 오늘 하루도 파이팅~",
            createdAt: Date()
        ),
        NotificationItem(
            id: "4",
            message: "닉네임길어도될까님이 끝냄 인증샷을 올렸네요! 보러 가봐요!",
            createdAt: Date()
        ),
        NotificationItem(
            id: "5",
            message: "닉네임길어도될까님이 내게 반응을 남겼어요. 보러 가봐요!",
            createdAt: Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date()
        ),
        NotificationItem(
            id: "6",
            message: "축하해요! 오늘도 열심히 산 우리에게 박수~",
            createdAt: Calendar.current.date(byAdding: .day, value: -2, to: Date()) ?? Date()
        ),
        NotificationItem(
            id: "7",
            message: "축하해요! 오늘도 열심히 산 우리에게 박수~",
            createdAt: Calendar.current.date(byAdding: .day, value: -3, to: Date()) ?? Date()
        ),
        NotificationItem(
            id: "8",
            message: "축하해요! 오늘도 열심히 산 우리에게 박수~",
            createdAt: Calendar.current.date(byAdding: .day, value: -5, to: Date()) ?? Date()
        ),
        NotificationItem(
            id: "9",
            message: "축하해요! 오늘도 열심히 산 우리에게 박수~",
            createdAt: Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date()
        ),
        NotificationItem(
            id: "10",
            message: "축하해요! 오늘도 열심히 산 우리에게 박수~",
            createdAt: Calendar.current.date(byAdding: .day, value: -10, to: Date()) ?? Date()
        ),
        // 14일 초과 - 필터링되어 표시되지 않음
        NotificationItem(
            id: "11",
            message: "이 알림은 15일 전이라 표시되지 않아요",
            createdAt: Calendar.current.date(byAdding: .day, value: -15, to: Date()) ?? Date()
        ),
        NotificationItem(
            id: "12",
            message: "이 알림은 20일 전이라 표시되지 않아요",
            createdAt: Calendar.current.date(byAdding: .day, value: -20, to: Date()) ?? Date()
        )
    ]
}
