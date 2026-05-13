//
//  CrashlyticsEvent.swift
//  CoreCrashlyticsInterface
//

import Foundation

/// Crashlytics 브레드크럼 로그 이벤트가 따라야 하는 공통 인터페이스입니다.
///
/// ## 사용 예시
/// ```swift
/// enum ProofPhotoCrashlyticsLogEvent: CrashlyticsLogEvent {
///     case uploadStep(UploadStep, goalId: Int64)
///
///     var message: String {
///         switch self {
///         case let .uploadStep(step, goalId):
///             "upload_step: \(step.rawValue), goalId=\(goalId)"
///         }
///     }
/// }
/// ```
public protocol CrashlyticsLogEvent: Sendable {
    var message: String { get }
}

/// Crashlytics non-fatal 오류 기록 이벤트가 따라야 하는 공통 인터페이스입니다.
///
/// `customKeys`에 화면 식별자(`CrashlyticsKey.screen`) 등 컨텍스트 정보를 담아 전달합니다.
///
/// ## 사용 예시
/// ```swift
/// enum ProofPhotoCrashlyticsRecordEvent: CrashlyticsRecordEvent {
///     case uploadFailed(step: String, goalId: Int64)
///
///     var customKeys: [String: String] {
///         switch self {
///         case let .uploadFailed(step, goalId):
///             [
///                 CrashlyticsKey.screen: "proof_photo_upload",
///                 CrashlyticsKey.uploadStep: step,
///                 CrashlyticsKey.goalId: "\(goalId)"
///             ]
///         }
///     }
/// }
/// ```
public protocol CrashlyticsRecordEvent: Sendable {
    var customKeys: [String: String] { get }
}
