//
//  CrashlyticsClient.swift
//  CoreCrashlyticsInterface
//

import ComposableArchitecture
import Foundation

/// Crashlytics non-fatal 오류 추적 클라이언트입니다.
///
/// ## 사용 예시
/// ```swift
/// @Dependency(\.crashlyticsClient) var crashlytics
///
/// // non-fatal 오류 기록
/// crashlytics.record(error, [CrashlyticsKey.screen: "proof_photo"])
///
/// // 브레드크럼 로그
/// crashlytics.log("upload_step: fetchUploadURL")
///
/// // 유저 식별자 설정 (로그인 성공 시 1회)
/// crashlytics.setUserIdentifier(userId)
/// ```
public struct CrashlyticsClient: Sendable {
    public var record: @Sendable (Error, [String: String]) -> Void
    public var log: @Sendable (String) -> Void
    public var setUserIdentifier: @Sendable (String) -> Void
    public var setCustomValue: @Sendable (String, String) -> Void

    public init(
        record: @escaping @Sendable (Error, [String: String]) -> Void,
        log: @escaping @Sendable (String) -> Void,
        setUserIdentifier: @escaping @Sendable (String) -> Void,
        setCustomValue: @escaping @Sendable (String, String) -> Void
    ) {
        self.record = record
        self.log = log
        self.setUserIdentifier = setUserIdentifier
        self.setCustomValue = setCustomValue
    }
}

// MARK: - TestDependencyKey

extension CrashlyticsClient: TestDependencyKey {
    public static let testValue = Self(
        record: { _, _ in },
        log: { _ in },
        setUserIdentifier: { _ in },
        setCustomValue: { _, _ in }
    )

    public static let previewValue = Self(
        record: { _, _ in },
        log: { _ in },
        setUserIdentifier: { _ in },
        setCustomValue: { _, _ in }
    )
}

// MARK: - DependencyValues

public extension DependencyValues {
    var crashlyticsClient: CrashlyticsClient {
        get { self[CrashlyticsClient.self] }
        set { self[CrashlyticsClient.self] = newValue }
    }
}
