//
//  CrashlyticsClient.swift
//  CoreCrashlyticsInterface
//

import ComposableArchitecture
import Foundation

/// Crashlytics non-fatal 오류 추적 클라이언트입니다.
///
/// 화면/Feature별로 정의된 이벤트 타입을 통해 메시지·커스텀 키를 일관되게 전달합니다.
///
/// ## 사용 예시
/// ```swift
/// @Dependency(\.crashlyticsClient) var crashlytics
///
/// // non-fatal 오류 기록
/// crashlytics.record(
///     error,
///     ProofPhotoCrashlyticsRecordEvent.uploadFailed(step: "fetchURL", goalId: 1)
/// )
///
/// // 브레드크럼 로그
/// crashlytics.log(ProofPhotoCrashlyticsLogEvent.uploadStep(.fetchURL, goalId: 1))
///
/// // 유저 식별자 설정 (로그인 성공 시 1회)
/// crashlytics.setUserIdentifier(userId)
/// ```
public struct CrashlyticsClient: Sendable {
    public var record: @Sendable (Error, any CrashlyticsRecordEvent) -> Void
    public var log: @Sendable (any CrashlyticsLogEvent) -> Void
    public var setUserIdentifier: @Sendable (String) -> Void

    public init(
        record: @escaping @Sendable (Error, any CrashlyticsRecordEvent) -> Void,
        log: @escaping @Sendable (any CrashlyticsLogEvent) -> Void,
        setUserIdentifier: @escaping @Sendable (String) -> Void
    ) {
        self.record = record
        self.log = log
        self.setUserIdentifier = setUserIdentifier
    }
}

// MARK: - TestDependencyKey

extension CrashlyticsClient: TestDependencyKey {
    public static let testValue = Self(
        record: { _, _ in },
        log: { _ in },
        setUserIdentifier: { _ in }
    )

    public static let previewValue = Self(
        record: { _, _ in },
        log: { _ in },
        setUserIdentifier: { _ in }
    )
}

// MARK: - DependencyValues

public extension DependencyValues {
    var crashlyticsClient: CrashlyticsClient {
        get { self[CrashlyticsClient.self] }
        set { self[CrashlyticsClient.self] = newValue }
    }
}
