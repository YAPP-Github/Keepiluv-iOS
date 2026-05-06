//
//  File.swift
//  CoreAnalyticsInterface
//
//  Created by 정지훈 on 5/3/26.
//

import Foundation

import ComposableArchitecture

/// 앱의 분석 이벤트와 사용자 식별 정보를 기록하는 클라이언트입니다.
///
/// ## 사용 예시
/// ```swift
/// @Dependency(\.analyticsClient) var analyticsClient
///
/// analyticsClient.setUserProfile((id: 1, name: "Twix"))
/// analyticsClient.logEvent(event)
/// analyticsClient.logEventParameter(event, ["goalId": 10])
/// ```
public struct AnalyticsClient {
    public var setUserProfile: ((id: Int64?, name: String?)) -> Void
    public var logEvent: (AnalyticsEvent) -> Void
    public var logEventParameter: (AnalyticsEvent, [String: Any]) -> Void

    /// 분석 클라이언트의 동작을 클로저로 주입합니다.
    public init(
        setUserProfile: @escaping ((id: Int64?, name: String?)) -> Void,
        logEvent: @escaping (AnalyticsEvent) -> Void,
        logEventParameter: @escaping (AnalyticsEvent, [String: Any]) -> Void,
    ) {
        self.setUserProfile = setUserProfile
        self.logEvent = logEvent
        self.logEventParameter = logEventParameter
    }
}

extension AnalyticsClient: TestDependencyKey {
    public static var testValue: AnalyticsClient {
        Self(
            setUserProfile: { _ in },
            logEvent: { _ in },
            logEventParameter: { _, _ in }
        )
    }
}

public extension DependencyValues {
    var analyticsClient: AnalyticsClient {
        get { self[AnalyticsClient.self] }
        set { self[AnalyticsClient.self] = newValue }
    }
}
